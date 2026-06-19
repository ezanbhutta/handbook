-- =============================================================================
-- HaseebMadeit Handbook — 0032 content (batch 24): the Manager position
-- The two shift leads (Ezan, Zubair) are the company's Managers — "Team Leader"
-- was the old name for the same role. This migration:
--   1. Renames every "Team Leader / Team Lead" mention in section bodies to
--      "Manager" (case-preserving, longest-match-first so plurals stay intact).
--   2. Updates the roster: Ezan and Zubair become Managers on 12-hour shifts
--      (Ezan 9 AM–9 PM, Zubair 9 PM–9 AM), stored as working_time.
--   3. Adds "The Manager Role" to the "Your Role" chapter, next to the other
--      role descriptions, scoped to hr/pm/manager.
--   4. Rewrites "Company Hierarchy and Shifts" to spell out the reporting lines.
-- The RosterWidget / admin roster code is updated alongside this migration so
-- the new role and hours render correctly. Idempotent.
-- =============================================================================

-- 1) Rename Team Leader -> Manager in all section bodies ----------------------
-- Longest / plural forms first so "Team Leaders" never becomes "Managerers".
update sections set body = replace(body, 'Team Leaders', 'Managers') where body like '%Team Leaders%';
update sections set body = replace(body, 'Team Leader',  'Manager')  where body like '%Team Leader%';
update sections set body = replace(body, 'Team Leads',   'Managers') where body like '%Team Leads%';
update sections set body = replace(body, 'Team Lead',    'Manager')  where body like '%Team Lead%';
update sections set body = replace(body, 'team leaders', 'managers') where body like '%team leaders%';
update sections set body = replace(body, 'team leader',  'manager')  where body like '%team leader%';
update sections set body = replace(body, 'team leads',   'managers') where body like '%team leads%';
update sections set body = replace(body, 'team lead',    'manager')  where body like '%team lead%';

-- 2) Promote the two shift leads to Managers with their 12-hour shifts --------
update roster set role = 'Manager', shift = null, working_time = '9 AM to 9 PM', updated_at = now()
 where name = 'Ezan';
update roster set role = 'Manager', shift = null, working_time = '9 PM to 9 AM', updated_at = now()
 where name = 'Zubair';

-- 3) "Your Role" — The Manager Role ------------------------------------------
update sections set order_index = 6 where slug = 'hr-manager-role';  -- make room at 5

insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='your-role'),
  'The Manager Role', 'role-manager',
  $BODY$
The Managers run the floor. Between them they cover the whole clock — one on the day shift, one on nights — so there is always a Manager on duty to keep work moving and to step in the moment a CSR needs help.

## The shifts they cover

```keyvalue
Day | A Manager on from 9 AM to 9 PM
Night | A Manager on from 9 PM to 9 AM
Reports to | The CEO
```

See [Company Hierarchy and Shifts](/section/company-hierarchy) for who is on days and nights right now.

## What a Manager owns
- Run the shift: every CSR online, on time, and on task.
- Be the first escalation point — when something is past what a CSR can handle, it comes to you.
- Step in on cancellations, disputes, and difficult clients alongside the CSR.
- Coach the team on quality, communication, and steady improvement.
- Keep the shift's numbers and hand over cleanly to the next Manager.
- Raise anything serious to the Project Manager, HR, or the CEO.

## Who reports to a Manager
- CSRs report to their shift Manager first, for anything on the floor.
- HR and the Project Managers can also bring a Manager in on a query when that is the quicker way to settle it.

> **Note:** For workplace culture, attendance, payroll, or a personal matter, anyone can go straight to HR.
$BODY$,
  array['hr','pm','manager']::user_role[], false, 5
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

-- 4) Welcome — Company Hierarchy and Shifts (reporting lines) -----------------
insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='welcome'),
  'Company Hierarchy and Shifts', 'company-hierarchy',
  $BODY$
HaseebMadeit runs around the clock across three shifts, with a Manager always on duty, so there is always someone to turn to. When something is past what you can handle on your own, your Manager is the first person you go to.

```roster
live team
```

## Who reports to whom

```keyvalue
Managers | Report to the CEO
HR | Reports to the CEO
Project Managers | Report to the CEO
CSRs | Report to their shift Manager
Designers | Report to the Project Manager
```

Managers, HR, and the Project Managers all answer directly to the CEO. HR and the Project Managers can also bring a question to a Manager when that is the quicker way to sort it.

For anything about workplace culture, attendance, payroll, or a personal matter, CSRs and designers can go straight to HR.

See the [Manager role](/section/role-manager), the [Project Manager role](/section/role-pm), and the [CSR role](/section/role-csr) for what each one does day to day.

> **Tip:** Not sure who to ask? Start with your shift Manager. They will take it up to the Project Manager, HR, or the CEO if it needs to go further.
$BODY$,
  array['csr','asr','hr','pm','manager','office_boy']::user_role[], true, 4
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;
