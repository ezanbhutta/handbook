-- =============================================================================
-- HaseebMadeIt Handbook — 0002 security (Row Level Security)
--
-- Two helper functions read the current user's role and admin status; every
-- read policy enforces the allowed-roles rule. Admin bypasses all read
-- restrictions and is the only writer.
--
-- Why this is safe from infinite recursion:
--   is_admin()/auth_role() are SECURITY DEFINER and run as their owner
--   (the `postgres` role that applies this migration). `postgres` also owns
--   the `profiles` table, and a table owner bypasses RLS unless FORCE ROW
--   LEVEL SECURITY is set (we never set it). So the SELECT on `profiles`
--   inside the helpers does NOT re-trigger the profiles policy -> no loop.
--   The explicit `set search_path` also hardens the definer functions.
-- =============================================================================

set search_path = public, extensions;

create or replace function auth_role()
returns user_role
language sql
security definer
stable
set search_path = public
as $$
  select role from profiles where id = auth.uid()
$$;

create or replace function is_admin()
returns boolean
language sql
security definer
stable
set search_path = public
as $$
  select coalesce((select is_admin from profiles where id = auth.uid()), false)
$$;

alter table profiles        enable row level security;
alter table chapters        enable row level security;
alter table sections        enable row level security;
alter table change_log      enable row level security;
alter table search_synonyms enable row level security;
alter table search_log      enable row level security;

-- ---- PROFILES: user reads own row; admin reads/writes all ----
drop policy if exists profiles_self_read on profiles;
create policy profiles_self_read on profiles for select
  using (id = auth.uid() or is_admin());

drop policy if exists profiles_admin_all on profiles;
create policy profiles_admin_all on profiles for all
  using (is_admin()) with check (is_admin());

-- ---- CHAPTERS: any signed-in user reads metadata; admin writes ----
-- Real protection is at the section level; the frontend hides chapters with no
-- visible sections (see get_navigation in 0003).
drop policy if exists chapters_read on chapters;
create policy chapters_read on chapters for select
  using (auth.uid() is not null);

drop policy if exists chapters_admin_write on chapters;
create policy chapters_admin_write on chapters for all
  using (is_admin()) with check (is_admin());

-- ---- SECTIONS: readable only if the user's role is allowed, or admin ----
drop policy if exists sections_read on sections;
create policy sections_read on sections for select
  using ( is_admin() or auth_role() = any(allowed_roles) );

drop policy if exists sections_admin_write on sections;
create policy sections_admin_write on sections for all
  using (is_admin()) with check (is_admin());

-- ---- CHANGE LOG: same visibility rule as the section it describes ----
drop policy if exists changelog_read on change_log;
create policy changelog_read on change_log for select
  using ( is_admin() or auth_role() = any(allowed_roles) );

drop policy if exists changelog_admin_write on change_log;
create policy changelog_admin_write on change_log for all
  using (is_admin()) with check (is_admin());

-- ---- SYNONYMS: everyone reads (needed to expand searches); admin writes ----
drop policy if exists synonyms_read on search_synonyms;
create policy synonyms_read on search_synonyms for select
  using (auth.uid() is not null);

drop policy if exists synonyms_write on search_synonyms;
create policy synonyms_write on search_synonyms for all
  using (is_admin()) with check (is_admin());

-- ---- SEARCH LOG: a user writes only their own rows; only admin reads ----
-- Deviation from brief: added an owner UPDATE policy so the client can set
-- clicked_section_id after a result is clicked (the brief documents this
-- behavior but only granted INSERT). No SELECT for non-admins, so the client
-- generates the row id locally instead of relying on INSERT ... RETURNING.
drop policy if exists searchlog_insert on search_log;
create policy searchlog_insert on search_log for insert
  with check (user_id = auth.uid());

drop policy if exists searchlog_update on search_log;
create policy searchlog_update on search_log for update
  using (user_id = auth.uid()) with check (user_id = auth.uid());

drop policy if exists searchlog_admin_read on search_log;
create policy searchlog_admin_read on search_log for select
  using (is_admin());
