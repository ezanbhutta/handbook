-- =============================================================================
-- HaseebMadeit Handbook, 0021 content (batch 14)
-- Work Schedule: add the day-off policy (no self-swaps; Manager + HR must
-- approve). Leave Policy: explain that each leave type is a separate allowance,
-- so using casual or medical leave does not reduce annual leave. Idempotent.
-- =============================================================================

insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='attendance'),
  'Work Schedule and Shifts', 'work-schedule',
  $BODY$
We run three shifts. Each one is 8 hours, with a 45 minute break.

| Shift | Hours | Break |
| --- | --- | --- |
| Morning | 9:00 AM to 5:00 PM | 1:15 PM to 2:00 PM |
| Evening | 5:00 PM to 1:00 AM | 9:45 PM to 10:30 PM |
| Night | 1:00 AM to 9:00 AM | 5:45 AM to 6:30 AM |

Working days are Monday through Sunday. Everyone gets 1 day off each week, set by your supervisor as part of the shift schedule.

## Your day off
Some people have a fixed day off, and that is normal. Your shift and your day off are assigned to you, and they stay as they are unless a change is approved.

> **Rule:** You cannot swap, move, or cover someone else's day off on your own. A change to anyone's day off happens only when both the Manager and HR approve it. Until you have that approval in writing, the schedule stands.

If you need a different day off, even once, raise it early with your Team Leader, who will take it to the Manager and HR. Never arrange a swap quietly between yourselves.
$BODY$,
  array['csr','asr','hr','pm','manager','office_boy']::user_role[], true, 1
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='attendance'),
  'Leave Policy', 'leave-policy',
  $BODY$
This covers every type of leave and how to ask for it. All leave is applied for in advance through the company's system, and unapproved absence is treated as misconduct.

```stats
14 | Annual (days)
3 | Medical (days)
7 | Marriage (days)
2 | Half days a year
```

## How the leave types work together
Each kind of leave is its own separate allowance. Using one does not eat into another. Your 14 annual days stay yours no matter how many casual or medical days you have taken in the same year.

- Casual leave is a monthly allowance, 1 a month. It is separate from your annual leave and never comes out of it. Unused casual leave does not roll into your annual balance either.
- Medical, marriage, and emergency leave are their own separate allowances too. Taking them does not reduce your annual leave.
- Annual leave is the yearly allowance you plan ahead for. It is the one you give the long notice for.

> **Example:** Say you take your 1 casual leave in June, then 2 medical days later in the year. Your annual leave is untouched. You still have all 14 annual days to apply for, on their own.

> **Rule:** Leave is only unpaid or deducted when it is unapproved, when a second casual leave in a month is not specially approved, when it falls under the sandwich rule, or during your notice period. Approved leave inside each allowance is paid, and it does not reduce any other allowance.

## Annual leave
You get 14 working days of paid annual leave each calendar year. Apply at least 3 to 4 weeks in advance. Scheduling is at the company's discretion so work is never left uncovered.

- Apply to HR 15 to 30 days in advance, with approval from Operations and HR.
- Annual leave cannot be taken during your notice period, and it is not cashable.
- The leave cycle ends in September. Unused annual leave does not carry forward and lapses, unless the company decides otherwise in writing.

## Casual leave
- 1 casual leave per month, with prior notice.
- It cannot be more than 1 day in a row.
- Apply through the HRM system 48 hours in advance, with Project Manager approval.
- More than 1 casual leave in a month is unpaid, unless management approves it specially.
- For an emergency, call HR or your Team Lead before your shift starts.

## Medical leave
3 working days of paid medical leave per calendar year. Tell the company in good time and, where asked, give a medical certificate from a registered doctor. The company may check that certificates are genuine, and misuse is treated as misconduct.

## Marriage leave
7 working days in a row, with pay, once during your whole time with us. Give reasonable notice and proof if asked.

## Emergency leave
Paid emergency leave may be granted for genuine, urgent situations such as family emergencies, accidents, or unexpected medical needs. It is subject to checking, and you should provide supporting documents where you can. The company decides whether to grant it.

## Half day leave
Up to 2 half days per calendar year, together equal to 1 full day, with prior approval.

## Compensatory leave
Earned for weekend or public holiday work that a Team Lead and Management approved in advance. It needs its own application and approval, and cannot be combined with casual, sick, or annual leave.

## Leave during the notice period
All benefits and earned leave are forfeited during the notice period. Any leave taken then is unpaid, and no annual leave can be taken.

## Sandwich leave
Unapproved leave taken next to a weekend or public holiday is treated as Sandwich Leave, and salary is deducted for all the days, including the holidays in between.

## Working on a holiday
If you are asked to work on an approved company holiday, you get either an equal day of compensatory leave or an extra day's salary, with management approval.

> **Rule:** Apply for every leave in advance. Absence without proper notice is misconduct and can lead to a wage deduction or termination.
$BODY$,
  array['csr','asr','hr','pm','manager','office_boy']::user_role[], false, 3
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;
