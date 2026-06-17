-- =============================================================================
-- HaseebMadeit Handbook, 0022 — the team roster
-- An editable roster (name, role, shift, day off) that drives the Company
-- Hierarchy section. Admins manage it under RLS; readers see it through a
-- SECURITY DEFINER token RPC (base table denies anon, like the rest). Removing
-- a row removes that person from the handbook. Idempotent.
-- =============================================================================

set search_path = public, extensions;

create table if not exists roster (
  id          uuid primary key default gen_random_uuid(),
  name        text not null,
  role        text not null default 'CSR',
  shift       text,
  off_day     text,
  order_index int  not null default 0,
  active      boolean not null default true,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);

alter table roster enable row level security;

drop policy if exists roster_admin_all on roster;
create policy roster_admin_all on roster for all
  using (is_admin()) with check (is_admin());

-- Reader RPC: any valid, active token can read the active roster (the hierarchy
-- is common content). SECURITY DEFINER, so it bypasses RLS but is gated on the
-- token being live.
create or replace function roster_for_token(p_token text)
returns table (id uuid, name text, role text, shift text, off_day text, order_index int, active boolean)
language sql stable security definer set search_path = public as $$
  select r.id, r.name, r.role, r.shift, r.off_day, r.order_index, r.active
  from access_links al
  join roster r on r.active
  where al.token = p_token and al.is_active
  order by r.order_index, r.name
$$;

grant execute on function roster_for_token(text) to anon, authenticated;

-- Seed the current team once (only when the roster is empty, so later edits and
-- removals are never overwritten by a re-run).
insert into roster (name, role, shift, order_index)
select v.name, v.role, v.shift, v.ord
from (values
  ('Abdul Haseeb',    'CEO',         null::text, 0),
  ('Ezan',            'Team Leader', 'Morning',  1),
  ('Zubair',          'Team Leader', 'Night',    2),
  ('Iqra Qaiser',     'CSR',         'Morning',  10),
  ('Tanzeel Bibi',    'CSR',         'Morning',  11),
  ('Hassan Mehdi',    'CSR',         'Morning',  12),
  ('Amrah Shoaib',    'CSR',         'Morning',  13),
  ('Abdul Basit',     'CSR',         'Evening',  20),
  ('Tayyab',          'CSR',         'Evening',  21),
  ('Husnain Gillani', 'CSR',         'Evening',  22),
  ('Abdul Hadi',      'CSR',         'Evening',  23),
  ('Ali Shakeel',     'CSR',         'Evening',  24),
  ('Salman Malik',    'CSR',         'Night',    30),
  ('Ahmed Bibrash',   'CSR',         'Night',    31),
  ('Swaid Khan',      'CSR',         'Night',    32),
  ('Saad Khan',       'CSR',         'Night',    33),
  ('Nadir Ali',       'CSR',         'Night',    34),
  ('Samama',          'CSR',         'Night',    35)
) as v(name, role, shift, ord)
where not exists (select 1 from roster);

-- Point the Company Hierarchy section at the live roster widget.
insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='welcome'),
  'Company Hierarchy and Shifts', 'company-hierarchy',
  $BODY$
We run three shifts. Each one has a Team Leader you report to, and its own CSR team. When something is past what you can handle on your own, your Team Leader is the first person you go to.

```roster
live team
```

See the [Project Manager role](/section/role-pm) and the [CSR role](/section/role-csr) for what each one does day to day.

> **Tip:** Not sure who to ask? Go to your shift Team Leader first. They will take it up to the Project Manager or the CEO if it needs to go further. HR and the Seniors keep this list current.
$BODY$,
  array['csr','asr','hr','pm','manager','office_boy']::user_role[], true, 2
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;
