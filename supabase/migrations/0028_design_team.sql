-- =============================================================================
-- HaseebMadeit Handbook, 0028 — Design team in the roster
-- Add specialty and working time to the roster, seed the design team (editable
-- in Admin > Roster), and add a Design Team view for CSRs, PM, Manager, and HR.
-- The read RPC is made role-aware: a designer token can only ever see designers,
-- never the CSR roster. Idempotent.
-- =============================================================================

set search_path = public, extensions;

alter table roster add column if not exists specialty text;
alter table roster add column if not exists working_time text;

-- Role-aware reader: everyone but a designer sees the whole roster; a designer
-- token sees only the design team, so CSR names never reach a designer.
create or replace function roster_for_token(p_token text)
returns table (
  id uuid, name text, role text, shift text, off_day text,
  specialty text, working_time text, order_index int, active boolean
)
language sql stable security definer set search_path = public as $$
  select r.id, r.name, r.role, r.shift, r.off_day, r.specialty, r.working_time, r.order_index, r.active
  from access_links al
  join roster r on r.active
  where al.token = p_token and al.is_active
    and (al.role <> 'designer' or r.role = 'Designer')
  order by r.order_index, r.name
$$;

grant execute on function roster_for_token(text) to anon, authenticated;

-- Seed the design team once (working times left blank to fill in). Only when no
-- designers exist yet, so later edits and removals are never overwritten.
insert into roster (name, role, specialty, order_index)
select v.name, 'Designer', v.specialty, v.ord
from (values
  ('Owais Nadeem',      'Branding',       40),
  ('Khubaib',           'Branding',       41),
  ('Hamid',             'Branding',       42),
  ('Owais Rehan',       'Branding',       43),
  ('Afjal Hussain',     'Branding',       44),
  ('Amin Ullah',        'Logo',           50),
  ('Rejaul Karim',      'Logo',           51),
  ('Abiha Imran',       'Logo',           52),
  ('Nimeazad',          'Logo',           53),
  ('M. Tariq',          'Logo',           54),
  ('Md Dulal',          'Logo',           55),
  ('Md Rashadul Haque', 'Logo',           56),
  ('Md Zahid Hasan',    'Logo',           57),
  ('Md Rezaul',         'Logo',           58),
  ('Atta Razaq',        'Logo',           59),
  ('Shaoor Haider',     'Logo',           60),
  ('Syed Mubahat',      'Animation',      70),
  ('Aqeel',             'PPT Designer',   71),
  ('Shahmeer',          'Canva Designer', 72)
) as v(name, specialty, ord)
where not exists (select 1 from roster where role = 'Designer');

-- The Design Team view (CSRs, PM, Manager, HR). Designers are not included, so
-- the section never shows for a designer.
insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='welcome'),
  'The Design Team', 'design-team',
  $BODY$
Our design team turns the briefs into the work clients see. Here is who is on it, by craft.

```designteam
live design team
```

> **Note:** Working times are kept current by management. If something here looks off, tell your Senior.
$BODY$,
  array['csr','pm','manager','hr']::user_role[], false, 3
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;
