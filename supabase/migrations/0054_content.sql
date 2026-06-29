-- =============================================================================
-- HaseebMadeit Handbook — 0054 content (batch 44): full designer leave policy
-- Replace the thin designer leave page with the full, explained policy that
-- mirrors the CSR Leave Policy (including the corrected rules: monthly casual
-- draws down annual, emergency falls under casual, medical is separate), adapted
-- for designers (Project Manager / Team Lead / HR approvals) and keeping the
-- designer "before you go" handover. Full re-upsert, idempotent by slug.
-- =============================================================================

insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='designers'),
  'Designer Leave Policy', 'designer-leave',
  $BODY$
This covers every type of leave and how to ask for it. All leave is applied for in advance, and unapproved absence is treated as misconduct.

```stats
14 | Annual (days)
3 | Medical (days)
7 | Marriage (days)
2 | Half days a year
```

## How the leave types work together
Your monthly casual leave and your annual leave share one pool, and emergency leave falls under your casual leave. Medical, marriage, and half day leave are separate allowances of their own.

- Casual leave is your monthly allowance, 1 a month, and it comes straight out of your annual leave. Every casual leave you take is automatically deducted from your annual days, and once you have used all of your monthly casual leaves, you cannot take any further annual leave that year.
- Medical, marriage, and half day leave are their own separate allowances. Taking them does not reduce your annual leave, and your 3 medical days a year never count against your casual leave.
- Emergency leave is not a separate allowance. It falls under your casual leave, so it counts against your annual leave just as a casual leave does.
- Annual leave is the yearly allowance you plan ahead for, and it is what your monthly casual leaves draw down.

> **Example:** Say you take a casual leave in June. That day comes straight off your annual balance. If you then take 2 medical days later in the year, those are separate and do not touch your annual leave. But if you have already used up your monthly casual leaves for the year, you cannot apply for annual leave on top.

> **Rule:** Leave is only unpaid or deducted when it is unapproved, when a second casual leave in a month is not specially approved, when it falls under the sandwich rule, or during your notice period. Approved leave is paid. Casual leave, and any emergency leave taken under it, comes out of your annual allowance; medical, marriage, and half day leave do not reduce any other allowance.

## Annual leave
You get 14 working days of paid annual leave each calendar year. Apply at least 3 to 4 weeks in advance. Scheduling is at the company's discretion so work is never left uncovered.

- Your monthly casual leaves come out of this allowance automatically, and once you have used all of them, you cannot take any further annual leave.
- Apply 15 to 30 days in advance, with approval from your Project Manager and HR.
- Annual leave cannot be taken during your notice period, and it is not cashable.
- The leave cycle ends in September. Unused annual leave does not carry forward and lapses, unless the company decides otherwise in writing.

## Casual leave
- 1 casual leave per month, with prior notice. Each one is deducted from your annual leave allowance automatically.
- It cannot be more than 1 day in a row.
- Apply 48 hours in advance, with Project Manager approval.
- More than 1 casual leave in a month is unpaid, unless management approves it specially.
- For an emergency, call HR or your Team Lead before your shift starts.

## Medical leave
3 working days of paid medical leave per calendar year, and these do not count against your casual or annual leave. Tell the company in good time and, where asked, give a medical certificate from a registered doctor. The company may check that certificates are genuine, and misuse is treated as misconduct.

## Marriage leave
7 working days in a row, with pay, once during your whole time with us. Give reasonable notice and proof if asked.

## Emergency leave
Paid emergency leave may be granted for genuine, urgent situations such as family emergencies, accidents, or unexpected medical needs. It is subject to checking, and you should provide supporting documents where you can. The company decides whether to grant it. Emergency leave falls under your casual leave, so it counts against your annual leave just as a casual leave does.

## Half day leave
Up to 2 half days per calendar year, together equal to 1 full day, with prior approval.

## Compensatory leave
Earned for weekend or public holiday work that a Team Lead and Management approved in advance. It needs its own application and approval, and cannot be combined with casual, sick, or annual leave.

## Leave during the notice period
All benefits and earned leave are forfeited during the notice period. Any leave taken then is unpaid, and no annual leave can be taken.

## Sandwich leave
Unapproved leave taken next to a weekend or public holiday is treated as Sandwich Leave, and salary is deducted for all the days, including the holidays in between.

> **Example:** An off day on Sunday, then leave on Monday, then an off day or a holiday right after. That is treated as sandwich leave.

## Working on a holiday
If you are asked to work on an approved company holiday, you get either an equal day of compensatory leave or an extra day's salary, with management approval.

## Before you go
- Finish anything urgent before your leave starts.
- Hand over or assign any pending work.
- Make sure no deadline is missed while you are away.
- Clear any pending revisions. Leave nothing half done.

> **Rule:** Apply for every leave in advance. Absence without proper notice is misconduct and can lead to a wage deduction or termination.
$BODY$,
  array['designer','pm','manager','hr']::user_role[], false, 3
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;
