-- =============================================================================
-- HaseebMadeit Handbook — 0053 content (batch 43): scope the designer view
-- Designers are remote. Their link should show only the Designers chapter plus
-- the Communication and Social Media page (mobile/social conduct). Remove the
-- designer role from the onsite/general HR, conduct, design-process, and
-- company-overview pages so a remote designer never sees a dress code, the
-- salary-lumped compensation page, or platform names. Also reframe the shift
-- page for remote work and add a focused designer pay-and-deductions note.
-- Idempotent: array_remove is a no-op once the role is gone; upserts by slug.
-- =============================================================================

-- 1) Remove the designer role from everything except the Designers chapter and
--    the Communication and Social Media page.
update sections
  set allowed_roles = array_remove(allowed_roles, 'designer'::user_role)
where slug in (
  'code-of-conduct', 'disciplinary-process',
  'design-philosophy', 'full-process', 'internal-process',
  'career-growth', 'compensation-benefits', 'hr-manager-role',
  'performance-review', 'probation-period', 'termination-resignation',
  'ceo-message', 'mission-vision-values', 'our-services', 'our-story', 'what-we-do'
);

-- 2) Reframe the designer shift page for remote work (was "Office Shifts").
insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='designers'),
  'Your Shift Hours', 'designer-shifts',
  $BODY$
You work remotely, on one of three shift windows that run around the clock. Your hours sit inside the one you are assigned.

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

-- 3) A focused, designer-only pay-and-deductions note (no onsite perks, no
--    salary lumped with other things).
insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='designers'),
  'Pay and Deductions', 'designer-pay',
  $BODY$
## How you are paid
You are on a monthly salary, paid in line with your contract.

## What gets deducted
Your pay stays whole when your work is clean, on time, and inside your shift. It can be reduced for:

- A delay, a late submission, or a missed deadline. See [Designer SOPs](/section/designer-sops).
- Going quiet for days after reminders.
- Leave taken without approval, or against the rules. See [Designer Leave Policy](/section/designer-leave).

> **Rule:** Deductions come from missed commitments, not from the work itself. Deliver on time, keep the Project Manager in the loop, and your pay stays whole.
$BODY$,
  array['designer','pm','manager','hr']::user_role[], false, 5
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;
