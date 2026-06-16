-- =============================================================================
-- HaseebMadeIt Handbook — 0001 schema
-- Extensions, enums, tables, indexes, and the search-vector trigger.
--
-- Verified against Supabase (Postgres 15/16/17). Notes on deviations from the
-- build brief are inline. Migration is written to be re-runnable (idempotent).
-- =============================================================================

-- Extensions live in the dedicated `extensions` schema (Supabase convention),
-- and we put it on the search_path for this migration so the pg_trgm operator
-- classes and unaccent() resolve during index/trigger creation.
create schema if not exists extensions;
set search_path = public, extensions;

create extension if not exists pg_trgm  with schema extensions;
create extension if not exists unaccent with schema extensions;

-- ===== ENUMS (guarded so the migration can be re-applied) =====
do $$ begin
  create type user_role as enum ('csr','asr','hr','pm','manager','office_boy');
exception when duplicate_object then null; end $$;

do $$ begin
  create type change_type as enum ('created','updated','deleted');
exception when duplicate_object then null; end $$;

-- ===== PROFILES (extends Supabase auth.users) =====
create table if not exists profiles (
  id          uuid primary key references auth.users(id) on delete cascade,
  full_name   text not null,
  role        user_role not null,
  is_admin    boolean not null default false,
  is_active   boolean not null default true,
  created_at  timestamptz not null default now()
);

-- ===== CHAPTERS =====
create table if not exists chapters (
  id           uuid primary key default gen_random_uuid(),
  title        text not null,
  slug         text not null unique,
  description  text,
  icon         text,                 -- name of an SVG icon, optional
  order_index  int  not null default 0,
  created_at   timestamptz not null default now(),
  updated_at   timestamptz not null default now()
);

-- ===== SECTIONS =====
-- allowed_roles defaults to ALL roles = visible to everyone.
-- Narrow it to restrict a sensitive section.
create table if not exists sections (
  id                 uuid primary key default gen_random_uuid(),
  chapter_id         uuid not null references chapters(id) on delete cascade,
  title              text not null,
  slug               text not null unique,
  body               text not null default '',   -- markdown
  video_url          text,                        -- Google Drive link, nullable
  allowed_roles      user_role[] not null
                       default array['csr','asr','hr','pm','manager','office_boy']::user_role[],
  show_in_onboarding boolean not null default false,
  order_index        int not null default 0,
  search_vector      tsvector,
  created_at         timestamptz not null default now(),
  updated_at         timestamptz not null default now(),
  updated_by         uuid references profiles(id)
);

create index if not exists sections_chapter_idx    on sections (chapter_id);
create index if not exists sections_search_idx      on sections using gin (search_vector);
create index if not exists sections_title_trgm_idx  on sections using gin (title gin_trgm_ops);
create index if not exists sections_body_trgm_idx   on sections using gin (body  gin_trgm_ops);
create index if not exists sections_onboarding_idx  on sections (show_in_onboarding) where show_in_onboarding;

-- keep search_vector + updated_at fresh on every write
create or replace function sections_search_trigger()
returns trigger
language plpgsql
set search_path = public, extensions
as $$
begin
  new.search_vector :=
    setweight(to_tsvector('english', unaccent(coalesce(new.title,''))), 'A') ||
    setweight(to_tsvector('english', unaccent(coalesce(new.body ,''))), 'B');
  new.updated_at := now();
  return new;
end $$;

drop trigger if exists sections_search_update on sections;
create trigger sections_search_update
  before insert or update on sections
  for each row execute function sections_search_trigger();

-- ===== CHANGE LOG (Chapter 12 + the banner feed) =====
-- allowed_roles mirrors the section's visibility so the log itself leaks nothing.
create table if not exists change_log (
  id            uuid primary key default gen_random_uuid(),
  section_id    uuid references sections(id) on delete set null,
  chapter_id    uuid references chapters(id) on delete set null,
  section_title text,                         -- snapshot, survives deletion
  type          change_type not null,
  summary       text not null,                -- human-written "what changed"
  allowed_roles user_role[] not null
                  default array['csr','asr','hr','pm','manager','office_boy']::user_role[],
  changed_by    uuid references profiles(id),
  created_at    timestamptz not null default now()
);
create index if not exists change_log_created_idx on change_log (created_at desc);

-- ===== SEARCH SYNONYMS (the cheap intelligence layer) =====
-- e.g. ('chutti','leave'), ('refund','cancellation')
create table if not exists search_synonyms (
  id         uuid primary key default gen_random_uuid(),
  term       text not null,     -- what a user might type
  maps_to    text not null,     -- the canonical word in the content
  created_at timestamptz not null default now()
);
create unique index if not exists search_synonyms_term_idx
  on search_synonyms (lower(term), lower(maps_to));

-- ===== SEARCH LOG (silent, from day one — feeds the future Gap Report) =====
create table if not exists search_log (
  id                 uuid primary key default gen_random_uuid(),
  user_id            uuid references profiles(id),
  query_text         text not null,
  results_count      int  not null default 0,
  clicked_section_id uuid references sections(id) on delete set null,
  created_at         timestamptz not null default now()
);
create index if not exists search_log_created_idx on search_log (created_at desc);
