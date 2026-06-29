-- =============================================================================
-- HaseebMadeit Handbook — 0056 security hardening
-- Findings from the security audit, fixed:
--   1. Access tokens were 6 characters (~35 bits) and the reader RPCs are
--      reachable with the public anon key, so tokens were brute-forceable.
--      Rotate every weak token to a strong 64-hex value (~244 bits), and add a
--      CHECK constraint so a short token can never be stored again (defence that
--      holds even if the client generator regresses).
--   2. search_for_token used `body ILIKE '%' || q || '%'`, letting a caller
--      inject LIKE wildcards (%/_) for a cheap match-everything query. Strip
--      those metacharacters before the ILIKE.
--
-- OPERATIONAL NOTE: rotating tokens invalidates any already-shared team links.
-- Re-share the new links from Admin -> Links. Admin/founder login (password) is
-- unaffected. Idempotent: the rotation only touches tokens still under 20 chars.
-- =============================================================================

set search_path = public, extensions;

-- 1a. Rotate weak tokens to strong, unguessable values.
update access_links
   set token = replace(gen_random_uuid()::text || gen_random_uuid()::text, '-', '')
 where char_length(token) < 20;

-- 1b. Refuse to ever store a weak token again.
alter table access_links drop constraint if exists access_links_token_strong;
alter table access_links add  constraint access_links_token_strong
  check (char_length(token) >= 20);

-- 2. Harden the reader search: strip LIKE metacharacters from the user query so
--    it cannot inject wildcards into the ILIKE fallback. Only this line changes.
create or replace function search_for_token(p_token text, q text)
returns table (
  section_id uuid, section_title text, section_slug text,
  chapter_title text, chapter_slug text, snippet text, rank real
)
language sql stable security definer set search_path = public, extensions as $$
  with link as (
    select role from access_links where token = p_token and is_active
  ),
  terms as (
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
  where (select role from link) = any(s.allowed_roles)
    and (
      s.search_vector @@ plainto_tsquery('english', (select qx from expanded))
      or similarity(s.title, q) > 0.2
      or s.body ilike '%' || translate(q, '%_' || chr(92), '') || '%'
    )
  order by rank desc
  limit 8;
$$;
