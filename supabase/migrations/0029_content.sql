-- =============================================================================
-- HaseebMadeit Handbook — 0029 content (batch 21): company foundations
-- Adds the genuinely-new material from the CEO's policy document that the book
-- did not yet cover, rewritten in the house voice with widgets:
--   • Welcome    → Mission, Vision & Values
--   • Welcome    → What We Do & Where We Work (services + office operations)
--   • HR/Payroll → Probation Period
--   • HR/Payroll → HR Manager: Role & Responsibilities
--   • Conduct    → The Disciplinary Process (warning ladder + appeal)
-- Topics already covered elsewhere (Code of Conduct, Termination/Resignation,
-- Social Media, the Designers chapter, Increments) are intentionally NOT
-- duplicated here. Visible to all roles, designers included. Idempotent.
-- =============================================================================

-- 1) Welcome & Company — Mission, Vision & Values ----------------------------
insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='welcome'),
  'Mission, Vision & Values', 'mission-vision-values',
  $BODY$
Everything we do at HaseebMadeit comes back to a few simple ideas. They are not slogans for a wall. They are how we choose what to work on, how we treat each other, and how we show up for the clients who trust us with their brands.

## Our mission

> **Key principle:** To deliver outstanding creative solutions that turn our clients' visions into powerful, memorable brand identities — on time, every time.

## Our vision
To be recognised as a world-class design agency known for creativity, reliability, and excellence — building long-term relationships with our clients, and nurturing a team that takes real pride in its craft.

## Our core values
These five values guide every decision, every deliverable, and every conversation.

```keyvalue
Excellence | We hold ourselves to the highest standard on every single deliverable.
Integrity | Honest, straight communication with clients and with each other, always.
Creativity | We make room for fresh thinking and new perspectives.
Accountability | Every one of us owns our work and meets our commitments.
Teamwork | We grow together, back each other up, and celebrate wins as a team.
```

> **Tip:** When you are unsure how to handle something, hold it up against these five. The right call almost always lines up with at least one of them.
$BODY$,
  array['csr','asr','hr','pm','manager','office_boy','designer']::user_role[], false, 5
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

-- 2) Welcome & Company — What We Do & Where We Work --------------------------
insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='welcome'),
  'What We Do & Where We Work', 'what-we-do',
  $BODY$
HaseebMadeit is a design and branding studio based in Multan, working with clients all over the world. Here is what we make, and how the studio runs day to day.

## Services we offer
- Brand identity and logo design
- Social media graphics and marketing material
- UI/UX and web design
- Business stationery and print design
- Product and packaging design
- Video thumbnails and digital creatives

## The studio at a glance

```keyvalue
Location | Crystal Arcade Plaza, 2nd floor, Office 20, Katchery Road, Multan, Pakistan
Hours | Open 24 hours a day, 7 days a week, across three rotating shifts
Sales platforms | Fiverr and Upwork
Task management | ClickUp
```

> **Note:** Our work comes in through Fiverr and Upwork, and every order lives in ClickUp from the first message to final delivery. If it is not in ClickUp, it did not happen.
$BODY$,
  array['csr','asr','hr','pm','manager','office_boy','designer']::user_role[], false, 6
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

-- 3) HR & Payroll — Probation Period -----------------------------------------
insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='hr-payroll'),
  'Probation Period', 'probation-period',
  $BODY$
Every new team member, onsite or remote, starts on a 60-day probation. It is a settling-in period for both sides — a chance for you to find your feet, and for us to see how you work.

## How probation works

```keyvalue
Length | 60 days from your start date
Check-ins | A review at day 30, and again at day 60
Notice during probation | Either side can end things with 7 days' written notice
Leave and benefits | Limited during probation, as set out in each policy
On success | You receive a written confirmation letter
```

## What the reviews look at
The check-ins at day 30 and day 60 are simple, honest conversations about how it is going — your work quality, your reliability, how you fit with the team, and anything you need from us to do your best work.

> **Tip:** Probation is a two-way street. If something is unclear or you are not getting what you need, say so early. The whole point of the reviews is to fix small things before they grow.

> **Important:** Passing probation is not automatic. Your confirmation comes in writing once you have completed the 60 days and met the standard for your role.
$BODY$,
  array['csr','asr','hr','pm','manager','office_boy','designer']::user_role[], false, 9
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

-- 4) HR & Payroll — HR Manager: Role & Responsibilities ----------------------
insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='hr-payroll'),
  'HR Manager: Role & Responsibilities', 'hr-manager-role',
  $BODY$
This section sets out what the HR Manager is responsible for at HaseebMadeit. It is here so everyone knows what HR owns, and who to go to for what.

## Recruitment and onboarding
- Plan and run hiring for every role — designers, CSR/ASR, team leaders, and support staff.
- Screen CVs, arrange interviews, and make hiring decisions together with the CEO.
- Issue offer letters, employment contracts, and joining documents.
- Run a proper onboarding so new hires understand our policies, tools, and culture.
- Set up each new joiner in ClickUp and the attendance system.
- Make sure every employee record is complete and filed within the first week.

## HR documentation and policies
- Keep the Employee Handbook, HR policy manual, and all SOPs up to date.
- Issue employment, confirmation, warning, and experience letters.
- Manage the company asset issuance form for any equipment we hand out.
- Keep confidential employee files — physical and digital — properly version-controlled.
- Draft, circulate, and archive internal HR notices and memos.
- Make sure our documentation meets Pakistani labour-law requirements.

## Attendance, leave and payroll
- Track daily attendance across all three shifts.
- Review and approve or decline leave in line with the Leave Policy.
- Keep monthly leave logs and flag any attendance issues to the CEO.
- Prepare payroll inputs with management — deductions, overtime, and bonuses.
- Keep every remote staff payment detail (Payoneer, bank transfer) accurate and current.

## Performance management
- Schedule the 30, 60, and 90-day reviews for people on probation.
- Run the bi-annual performance review cycle for confirmed staff.
- Keep performance records and share outcomes with the relevant team leaders.
- Help managers write Performance Improvement Plans where they are needed.
- Escalate performance concerns to the CEO, with the evidence to back them up.

## Employee relations and discipline
- Be the first point of contact for concerns, complaints, and grievances.
- Investigate complaints fairly, confidentially, and quickly.
- Issue verbal, written, and final warnings as set out in the Disciplinary Process.
- Handle suspension or termination steps with the CEO, documenting each one.
- Keep the workplace respectful, and uphold our anti-harassment and anti-discrimination policies at all times.

## Supporting remote staff
- Keep records for every remote employee — location, payment method, hours, and timezone.
- Work with team leaders to keep an eye on remote availability and attendance.
- Onboard remote hires digitally and make sure they sign every required policy.
- Help team leaders with remote issues like lateness, availability, or quality.
- Issue remote warnings or notices when needed, and record what was done.

## Compliance and legal
- Keep our HR practices in line with Pakistan labour law and our own policies.
- Hold the records the law needs — contracts, NOCs, and experience letters.
- Advise management on employment-law questions around hiring, exits, and leave.
- Update the handbook and policy manual whenever the law or our policies change.

## Office and operations
- Manage the office boy and keep day-to-day office operations running smoothly.
- Oversee supplies, maintenance, and vendor contact when needed.
- Keep the HR office and filing system clean and organised.
- Organise team events, celebrations, and internal announcements.
- Support the CEO with people-and-operations admin.
$BODY$,
  array['csr','asr','hr','pm','manager','office_boy','designer']::user_role[], false, 10
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

-- 5) Conduct & Culture — The Disciplinary Process ----------------------------
insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='conduct'),
  'The Disciplinary Process', 'disciplinary-process',
  $BODY$
Most issues at work are small and get sorted with a quick, honest conversation. When something is more serious, or it keeps happening, we follow a clear and fair process so everyone knows where they stand. Read this alongside the Code of Conduct and Discipline — the two go together.

## The warning ladder
Discipline is meant to correct, not to punish. We start at the lowest level that fits the situation, and only move up if things do not improve.

```steps
Verbal warning | An informal chat with your Team Leader or HR, noted down internally.
Written warning 1 | A formal warning letter, with a clear plan to put things right.
Written warning 2 | A final warning. A suspension may apply at this stage.
Termination | Employment ends, after a full inquiry into what happened.
```

## When dismissal can be immediate
Some things are serious enough to end employment straight away, after an internal inquiry. These include:

- Sharing client data or files with anyone unauthorised.
- Fraud, theft, or forging company documents.
- Physical assault or threatening behaviour at work.
- Repeated no-shows with no communication.
- Gross insubordination, or deliberately sabotaging our work.

> **Rule:** In cases of serious misconduct, the company may end employment immediately, without notice, based on the findings of an internal inquiry.

## If you want to appeal
If you receive a warning or a termination notice and you believe it is unfair, you have the right to appeal.

```steps
Appeal in writing | Send your appeal to the HR Manager within 5 working days.
Review meeting | HR holds a review meeting within 7 working days of your appeal.
Final decision | The CEO's decision after that review is final.
```

> **Tip:** Put your side in writing clearly and calmly, with any dates or details that help. A fair hearing works best when everyone has the facts.
$BODY$,
  array['csr','asr','hr','pm','manager','office_boy','designer']::user_role[], false, 5
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;
