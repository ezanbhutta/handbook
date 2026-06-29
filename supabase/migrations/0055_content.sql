-- =============================================================================
-- HaseebMadeit Handbook — 0055 content (batch 45): designer leave policy, official text
-- Replace the designer leave page with the official Leave Policy text supplied by
-- the company, verbatim in substance and de-duplicated: entitlement numbers live
-- only in the stat tiles (not repeated in prose), no separate "how they work
-- together" explainer, no duplicate "working on a holiday" section, and the new
-- Off-Day Work Arrangement section added. Full re-upsert, idempotent by slug.
-- =============================================================================

insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='designers'),
  'Designer Leave Policy', 'designer-leave',
  $BODY$
Every type of leave, and how to ask for it, is set out below. All leave must be applied for in advance through the HRM system, and unapproved absence is treated as misconduct that may lead to a salary deduction or termination.

```stats
14 | Annual (days)
3 | Medical (days)
7 | Marriage (days)
2 | Half days a year
```

## Casual leave
Each employee is entitled to one casual leave per month, automatically deducted from the annual leave balance, and not exceeding one consecutive day. Requests must be submitted at least 48 hours in advance via the HRM system, and are subject to Project Manager approval.

> **Note:** Casual leave is granted strictly on verified and authentic grounds. Applications lacking genuine justification, or submitted solely to use the monthly entitlement, will not be entertained. Leave is a professional benefit and will be treated as such.

## Annual leave
Annual leave requires 15 to 30 days advance notice, with approval from Operations and HR. Additional casual leave beyond the monthly allocation is unpaid unless management approves it. Unused annual leave lapses at the end of the September cycle and is non-cashable.

## Medical leave
Three paid medical days are available per calendar year, and they do not affect the annual or casual leave balance. A medical certificate from a registered doctor may be required. Misuse of medical leave is treated as misconduct.

## Marriage leave
Seven consecutive paid working days, granted once during your tenure. Reasonable advance notice and supporting documentation may be requested.

## Emergency leave
Emergency leave is granted at the company's discretion for genuine, urgent situations. It falls under casual leave and is deducted from the annual leave balance accordingly. Supporting documents must be provided where possible.

## Half day leave
Up to two half days per calendar year, collectively equivalent to one full day, subject to prior approval.

## Compensatory leave
Earned only for weekend or public holiday work that was pre-approved by a Manager and Management. It requires a separate application and cannot be combined with other leave types.

## Sandwich leave
Any unapproved leave taken adjacent to a weekend or public holiday is classified as Sandwich Leave. Salary is deducted for all intervening days, including the holidays.

## Notice period
No leave of any kind may be taken during the notice period. Any absence during this time is unpaid, and all accumulated leave benefits are forfeited.

## Off-day work arrangement
This policy does not apply to employees who choose to work on their designated off day in exchange for a leave day during the working week. Such arrangements are outside the scope of this leave policy and are managed separately.
$BODY$,
  array['designer','pm','manager','hr']::user_role[], false, 3
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;
