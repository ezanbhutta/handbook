-- =============================================================================
-- HaseebMadeIt Handbook — 0003 RPCs
--   get_navigation()  -> permission-filtered chapter/section tree for the nav
--   search_handbook() -> typo + keyword + synonym search, RLS-aware
--
-- Both run SECURITY INVOKER so RLS auto-filters: a user can never see (or even
-- detect) a section their role isn't allowed to read.
-- =============================================================================

set search_path = public, extensions;

-- Navigation that respects visibility. The INNER JOIN drops any chapter that
-- has no section readable by the current user, so empty/forbidden chapters
-- never appear in the nav.
create or replace function get_navigation()
returns table (
  chapter_id uuid, chapter_title text, chapter_slug text, chapter_order int,
  chapter_icon text, chapter_description text,
  section_id uuid, section_title text, section_slug text, section_order int
)
language sql
stable
security invoker
set search_path = public
as $$
  select c.id, c.title, c.slug, c.order_index, c.icon, c.description,
         s.id, s.title, s.slug, s.order_index
  from chapters c
  join sections s on s.chapter_id = c.id   -- RLS filters s; empty chapters drop out
  order by c.order_index, s.order_index
$$;

-- V1 search: typos/partial words (trigram), keywords (full-text), and synonyms
-- (expanded into the query). SECURITY INVOKER => restricted sections never
-- appear, not even as a locked hint.
create or replace function search_handbook(q text)
returns table (
  section_id uuid, section_title text, section_slug text,
  chapter_title text, chapter_slug text, snippet text, rank real
)
language sql
stable
security invoker
set search_path = public, extensions
as $$
  with terms as (
    select unnest(string_to_array(lower(unaccent(q)), ' ')) as tok
  ),
  expanded as (
    select string_agg(distinct w, ' ') as qx from (
      select tok as w from terms where length(tok) > 0
      union select maps_to from search_synonyms where lower(term)    in (select tok from terms)
      union select term    from search_synonyms where lower(maps_to) in (select tok from terms)
    ) u
  )
  select
    s.id, s.title, s.slug, c.title, c.slug,
    ts_headline('english', s.body,
      plainto_tsquery('english', (select qx from expanded)),
      'MaxFragments=1, MaxWords=20, MinWords=8') as snippet,
    ( ts_rank(s.search_vector, plainto_tsquery('english', (select qx from expanded)))
      + similarity(s.title, q) * 0.5 )::real as rank
  from sections s
  join chapters c on c.id = s.chapter_id
  where s.search_vector @@ plainto_tsquery('english', (select qx from expanded))
     or similarity(s.title, q) > 0.2
     or s.body ilike '%' || q || '%'
  order by rank desc
  limit 8;
$$;

-- Allow the app roles to call the RPCs.
grant execute on function get_navigation()        to anon, authenticated;
grant execute on function search_handbook(text)   to anon, authenticated;
