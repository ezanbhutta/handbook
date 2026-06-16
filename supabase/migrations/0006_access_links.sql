-- =============================================================================
-- HaseebMadeIt Handbook — 0006 access links (no-login, role-based access)
--
-- The team reads the handbook with NO login. Each role has a secret link whose
-- token maps to that role. All reader content flows through SECURITY DEFINER
-- functions that take the token, resolve the role, and return only content that
-- role is allowed to see (common sections show for everyone). The base tables
-- still deny anonymous reads (auth.uid() is null in these policies), so the
-- token is the only way in. Tokens are bearer secrets — rotate to revoke.
--
-- The founder still logs in (password) to author; that path is unchanged.
-- =============================================================================

set search_path = public, extensions;

-- One secret token per role (admin can add more / rotate).
create table if not exists access_links (
  token       text primary key,
  role        user_role not null,
  label       text,
  is_active   boolean not null default true,
  created_at  timestamptz not null default now()
);

alter table access_links enable row level security;

drop policy if exists access_links_admin_all on access_links;
create policy access_links_admin_all on access_links for all
  using (is_admin()) with check (is_admin());

-- Seed one active link per role with a short random token (idempotent).
insert into access_links (token, role, label)
select substr(md5(gen_random_uuid()::text || clock_timestamp()::text), 1, 10),
       t.r, t.lbl
from (values
  ('csr'::user_role,        'CSR team link'),
  ('asr'::user_role,        'ASR team link'),
  ('hr'::user_role,         'HR team link'),
  ('pm'::user_role,         'Project Manager link'),
  ('manager'::user_role,    'Manager link'),
  ('office_boy'::user_role, 'Office Boy link')
) as t(r, lbl)
where not exists (select 1 from access_links a where a.role = t.r);

-- Tag reader searches with their role so the Gap Report can segment them.
alter table search_log add column if not exists searched_role user_role;

-- ===== Reader RPCs (token in, role-filtered content out) =====================
-- All SECURITY DEFINER: they run as owner (bypassing RLS) but gate every row on
-- the token's role. An invalid/!active token joins to nothing => empty result.

create or replace function link_info(p_token text)
returns table (role user_role, label text)
language sql stable security definer set search_path = public as $$
  select role, label from access_links where token = p_token and is_active
$$;

create or replace function nav_for_token(p_token text)
returns table (
  chapter_id uuid, chapter_title text, chapter_slug text, chapter_order int,
  chapter_icon text, chapter_description text,
  section_id uuid, section_title text, section_slug text, section_order int
)
language sql stable security definer set search_path = public as $$
  select c.id, c.title, c.slug, c.order_index, c.icon, c.description,
         s.id, s.title, s.slug, s.order_index
  from access_links al
  join sections s on al.role = any(s.allowed_roles)
  join chapters c on c.id = s.chapter_id
  where al.token = p_token and al.is_active
  order by c.order_index, s.order_index
$$;

create or replace function chapter_for_token(p_token text, p_slug text)
returns table (id uuid, title text, slug text, description text, icon text, order_index int)
language sql stable security definer set search_path = public as $$
  select c.id, c.title, c.slug, c.description, c.icon, c.order_index
  from access_links al
  join chapters c on c.slug = p_slug
  where al.token = p_token and al.is_active
$$;

create or replace function chapter_sections_for_token(p_token text, p_slug text)
returns table (id uuid, title text, slug text, order_index int, show_in_onboarding boolean)
language sql stable security definer set search_path = public as $$
  select s.id, s.title, s.slug, s.order_index, s.show_in_onboarding
  from access_links al
  join chapters c on c.slug = p_slug
  join sections s on s.chapter_id = c.id and al.role = any(s.allowed_roles)
  where al.token = p_token and al.is_active
  order by s.order_index
$$;

create or replace function section_for_token(p_token text, p_slug text)
returns table (
  id uuid, title text, slug text, body text, video_url text,
  allowed_roles user_role[], show_in_onboarding boolean, updated_at timestamptz,
  chapter_title text, chapter_slug text
)
language sql stable security definer set search_path = public as $$
  select s.id, s.title, s.slug, s.body, s.video_url, s.allowed_roles,
         s.show_in_onboarding, s.updated_at, c.title, c.slug
  from access_links al
  join sections s on s.slug = p_slug and al.role = any(s.allowed_roles)
  join chapters c on c.id = s.chapter_id
  where al.token = p_token and al.is_active
$$;

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
      or s.body ilike '%' || q || '%'
    )
  order by rank desc
  limit 8;
$$;

create or replace function latest_change_for_token(p_token text)
returns table (
  id uuid, section_title text, type change_type, summary text,
  created_at timestamptz, section_slug text
)
language sql stable security definer set search_path = public as $$
  select cl.id, cl.section_title, cl.type, cl.summary, cl.created_at, s.slug
  from access_links al
  join change_log cl on al.role = any(cl.allowed_roles)
  left join sections s on s.id = cl.section_id
  where al.token = p_token and al.is_active
  order by cl.created_at desc
  limit 1
$$;

create or replace function changelog_for_token(p_token text)
returns table (
  id uuid, section_title text, type change_type, summary text,
  created_at timestamptz, section_slug text
)
language sql stable security definer set search_path = public as $$
  select cl.id, cl.section_title, cl.type, cl.summary, cl.created_at, s.slug
  from access_links al
  join change_log cl on al.role = any(cl.allowed_roles)
  left join sections s on s.id = cl.section_id
  where al.token = p_token and al.is_active
  order by cl.created_at desc
  limit 200
$$;

create or replace function onboarding_for_token(p_token text)
returns table (id uuid, title text, slug text, chapter_title text, chapter_slug text)
language sql stable security definer set search_path = public as $$
  select s.id, s.title, s.slug, c.title, c.slug
  from access_links al
  join sections s on al.role = any(s.allowed_roles) and s.show_in_onboarding
  join chapters c on c.id = s.chapter_id
  where al.token = p_token and al.is_active
  order by s.order_index
$$;

-- Silent search logging for readers (no auth). Returns the row id so a later
-- click can be attributed.
create or replace function log_search(p_token text, p_query text, p_count int)
returns uuid
language plpgsql volatile security definer set search_path = public as $$
declare
  r user_role;
  new_id uuid;
begin
  select role into r from access_links where token = p_token and is_active;
  if r is null then return null; end if;
  insert into search_log (query_text, results_count, searched_role)
  values (p_query, coalesce(p_count, 0), r)
  returning id into new_id;
  return new_id;
end $$;

create or replace function log_search_click(p_token text, p_log_id uuid, p_section_id uuid)
returns void
language plpgsql volatile security definer set search_path = public as $$
begin
  if exists (select 1 from access_links where token = p_token and is_active) then
    update search_log set clicked_section_id = p_section_id where id = p_log_id;
  end if;
end $$;

-- The reader RPCs are called with the public anon key.
grant execute on function link_info(text)                       to anon, authenticated;
grant execute on function nav_for_token(text)                   to anon, authenticated;
grant execute on function chapter_for_token(text, text)         to anon, authenticated;
grant execute on function chapter_sections_for_token(text, text) to anon, authenticated;
grant execute on function section_for_token(text, text)         to anon, authenticated;
grant execute on function search_for_token(text, text)          to anon, authenticated;
grant execute on function latest_change_for_token(text)         to anon, authenticated;
grant execute on function changelog_for_token(text)             to anon, authenticated;
grant execute on function onboarding_for_token(text)            to anon, authenticated;
grant execute on function log_search(text, text, int)           to anon, authenticated;
grant execute on function log_search_click(text, uuid, uuid)    to anon, authenticated;
