-- =============================================================================
-- HaseebMadeit Handbook, 0027 — Designer link + Designers chapter
-- Designers get their own, totally separate link and a focused chapter: SOPs,
-- the quality bar, the leave policy, and the office shift times. Visible to
-- Designer, PM, Manager, and HR only. No CSR names, no profile names, no order
-- numbers, and no platform names (the word "Platform" is used if ever needed).
-- Idempotent.
-- =============================================================================

-- A separate secret link for the design team.
insert into access_links (token, role, label)
select substr(md5(gen_random_uuid()::text || clock_timestamp()::text), 1, 6),
       'designer'::user_role, 'Designer team link'
where not exists (select 1 from access_links a where a.role = 'designer'::user_role);

-- The Designers chapter.
insert into chapters (title, slug, description, icon, order_index)
select 'Designers', 'designers', 'How designers work, deliver, and take leave.', 'image', 13
where not exists (select 1 from chapters where slug = 'designers');

-- ===== The Designer role =====================================================
insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='designers'),
  'Working as a Designer', 'designer-overview',
  $BODY$
The project management team leads how work flows from here, and they keep a close eye on quality and timing. Your performance is reviewed every month. Steady, careful work keeps your standing strong, and repeated slips pull it down.

> **Key principle:** Do clean work, on time, inside your shift, and keep the Project Manager in the loop. That is the whole job.
$BODY$,
  array['designer','pm','manager','hr']::user_role[], true, 1
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

-- ===== Designer SOPs =========================================================
insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='designers'),
  'Designer SOPs', 'designer-sops',
  $BODY$
Follow these every day. They keep the work moving and your performance strong.

```checklist
Check your email and the WhatsApp group announcements regularly.
When the project management team asks for an update, give an hourly update until it is done.
Submit every file through ClickUp, and upload to the shared Google Drive every day.
Use the required format and the proper file naming every time. Unapproved naming is not accepted.
Respond to the project management team promptly and attentively.
Finish all your work inside your assigned shift hours.
The moment any issue comes up, tell the Project Manager straight away, on any channel.
```

> **Rule:** A delay or a late submission is counted as task delay accountability, and it can lead to a salary deduction. The same goes for going quiet for days after reminders, or missing a deadline.

> **Note:** No extra hours are counted when a delay comes from mismanagement. Plan your shift so the work lands inside it.

## What quality is judged on
Your work is checked closely on:

- Clear, professional communication with the project team.
- Finishing every assigned task.
- Correct grammar and spelling.
- Following the instructions exactly.
- Clean alignment and strong design quality.

> **Important:** If there is a misunderstanding, a meeting is scheduled to sort it out. Bring your questions there.
$BODY$,
  array['designer','pm','manager','hr']::user_role[], false, 2
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

-- ===== Designer Leave Policy =================================================
insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='designers'),
  'Designer Leave Policy', 'designer-leave',
  $BODY$
Plan your leave properly, and never let it sit against an off day or a holiday.

## No sandwich leave
You cannot take leave that falls between two off days, or next to a holiday.

> **Example:** Off on Sunday, then leave on Monday, then an off or a holiday right after. That is not allowed.

## When you can take leave
- Leave is only for regular working days.
- It must not be attached to any off day or holiday.

## How to ask

```steps
Ask in advance | Request your leave at least 24 to 48 hours before.
Give the reason | Say clearly why you need the day.
Get it approved | Approval comes from HR, your Team Lead, or the Project Manager.
```

## Before you go
- Finish anything urgent before your leave starts.
- Hand over or assign any pending work.
- Make sure no deadline is missed while you are away.
- Clear any pending revisions. Leave nothing half done.

> **Rule:** Leave taken without approval, or against these rules, can mean a leave deduction and a hit to your performance.
$BODY$,
  array['designer','pm','manager','hr']::user_role[], false, 3
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

-- ===== Office shifts (times only, no names) ==================================
insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='designers'),
  'Office Shifts', 'designer-shifts',
  $BODY$
The office runs three shifts, around the clock. Your hours sit inside one of them.

| Shift | Hours |
| --- | --- |
| Morning | 9:00 AM to 5:00 PM |
| Evening | 5:00 PM to 1:00 AM |
| Night | 1:00 AM to 9:00 AM |

All your work is done inside your assigned shift hours.
$BODY$,
  array['designer','pm','manager','hr']::user_role[], false, 4
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;
