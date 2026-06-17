-- =============================================================================
-- HaseebMadeit Handbook, 0011 content (batch 4): the official Employee Handbook
-- Sourced from the Employee Handbook & Agency Policy. Content kept faithful to
-- the policies (numbers and rules unchanged); only reformatted and written in a
-- plain human voice. No individual/confidential data is included.
-- Visibility: everyone (the handbook applies to all employees). Idempotent.
-- =============================================================================

-- ===== CHAPTER 1 · Welcome & Company ========================================

insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='welcome'),
  'About These Policies', 'about-these-policies',
  $BODY$
These policies apply to everyone at HaseebMadeit and replace any earlier verbal instructions. By being part of the team, you agree to follow them, including any updates we make later.

## What we expect from you
As a member of the team, you are responsible for:

- Delivering work that meets our quality standard before it reaches a client.
- Following the project pipeline without shortcuts.
- Keeping client information and brand security confidential.
- Meeting the deadlines we commit to clients.
- Contributing to the team's workflow and accountability.
- Staying professional in every client interaction.

## Changes to these policies
Management and the HR Department may update, revise, or remove any policy at any time, for operational, legal, or business reasons. Changes are shared with everyone in writing, and continuing to work here after a change means you accept it.

> **Note:** Only Management and HR can authorise changes to these policies.
$BODY$,
  array['csr','asr','hr','pm','manager','office_boy']::user_role[], false, 4
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

-- ===== CHAPTER 2 · Conduct & Culture ========================================

insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='conduct'),
  'Code of Conduct and Discipline', 'code-of-conduct',
  $BODY$
How we behave protects our clients, our work, and each other. These standards apply to everyone.

## No outside work
We do not allow any freelance or side work while you are employed here, paid or unpaid, whatever the timing, platform, or scope. Your full focus stays on HaseebMadeit.

Strictly not allowed:

- Any freelance or side work, paid or unpaid.
- Work that competes with, overlaps, or resembles what we do.
- Using our methods, systems, equipment, or intellectual property for outside work.
- Taking outside clients, even outside office hours.
- Helping or working with any competitor.

> **Rule:** Outside work is not permitted under any circumstances. This protects our quality, avoids conflicts of interest, and keeps everyone focused.

## Professional standards
- Communicate respectfully with the team and clients at all times.
- No abusive language, shouting, discrimination, or threats.
- Give constructive feedback only. No insulting remarks about the company, management, or colleagues.
- Act ethically in everything you do.
- Do not share your salary information with other staff.

## Serious violations
These can lead to immediate disciplinary action or termination:

- Copying or transferring company data or client information.
- Theft of documents, sheets, designs, mockups, code, or any confidential material we create.
- Sharing confidential client or business information.
- Competing, directly or indirectly, with current or past clients.
- Freelancing during or outside office hours.
- Poor performance or repeated lateness.
- Refusing to follow directions.
- Serious carelessness in delivery.
- Dishonesty, fraud, or theft.
- Bringing weapons, drugs, vapes, pods, cigarettes, or alcohol to the workplace.
- Being absent without notice for a week or more.
- Harassment or discrimination of any kind.
- Spreading negativity about the company or management.
- Damaging the company's reputation with clients or the public.
- Putting teammates or clients at risk.

> **Important:** How violations are handled is set out in [Termination and Resignation](/section/termination-resignation).
$BODY$,
  array['csr','asr','hr','pm','manager','office_boy']::user_role[], false, 1
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='conduct'),
  'Mobile Phone Policy', 'mobile-phone-policy',
  $BODY$
These rules apply to everyone on site during working hours.

- You may not keep your personal mobile phone at your workstation during working hours.
- All personal phones go in the designated Mobile Rack Area before you start work.
- This applies to all CSR, ASR, and support staff.

> **Rule:** Not following this can lead to a formal warning.

This is in place to protect client data, keep everyone focused, and hold a professional standard during shifts.
$BODY$,
  array['csr','asr','hr','pm','manager','office_boy']::user_role[], false, 2
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='conduct'),
  'Communication and Social Media', 'communication-social-media',
  $BODY$
- Keep communication professional and respectful at all times.
- No inappropriate material on company group IDs or official social media.
- Give constructive feedback only, and send complaints to management.
- Share suggestions through the proper channels, your Team Lead or HR.
- Do not post company information online without permission.
$BODY$,
  array['csr','asr','hr','pm','manager','office_boy']::user_role[], false, 3
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

-- ===== CHAPTER 3 · Attendance, Shifts & Leave ===============================

insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='attendance'),
  'Work Schedule and Shifts', 'work-schedule',
  $BODY$
We run three shifts. Each one is 8 hours with a 45 minute break.

| Shift | Hours | Break |
| --- | --- | --- |
| Morning | 9:00 AM to 5:00 PM | 45 minutes |
| Evening | 5:00 PM to 1:00 AM | 45 minutes |
| Night | 1:00 AM to 9:00 AM | 45 minutes |

Working days are Monday through Sunday, with 1 day off each week, assigned by your supervisor based on the shift schedule.
$BODY$,
  array['csr','asr','hr','pm','manager','office_boy']::user_role[], true, 1
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='attendance'),
  'Punctuality and Time Tracking', 'punctuality-tracking',
  $BODY$
## Being on time
Be at your workstation, ready to work, at the start of your shift.

- Arriving 30 minutes late or more, 3 times in a month, means a zero punctuality grade for that month.
- An exception is granted only if you stayed past your normal hours the previous working day, at your supervisor's request.
- You are expected to complete 8 hours for each working day in the month. A shortfall leads to a salary deduction.

> **Important:** A written warning is issued after 3 punctuality violations in a month.

## Tracking your time
- Time tracking is required daily. Log all your project hours in the designated system.
- You are expected to complete the full 8 hour tracker. Anything incomplete must be made up by the end of the week.
- For short breaks away from the office, email your Project Manager or Team Lead for approval, then notify HR with the subject line "Movement Sheet, Short Leave Request", including your time out, time in, and the reason.

Repeated lateness, absence, or attendance issues can affect your performance and salary reviews.
$BODY$,
  array['csr','asr','hr','pm','manager','office_boy']::user_role[], false, 2
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='attendance'),
  'Leave Policy', 'leave-policy',
  $BODY$
This covers every type of leave and how to ask for it. All leave is applied for in advance through the company's system, and unapproved absence is treated as misconduct.

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
7 working days in a row, with pay, once during your whole time with us. Give reasonable notice and proof (such as an invitation or nikkah certificate) if asked.

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

-- ===== CHAPTER 6 · Design Delivery & QA =====================================

insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='delivery-qa'),
  'Performance and Quality Standards', 'performance-quality',
  $BODY$
Every project meets these standards before it reaches a client.

## Before delivery
- Proper spacing, alignment, and visual consistency.
- Correct colour profiles and export quality.
- All source files, fonts, and colour codes included.
- Brand strategy documentation provided.
- The QA checklist completed and signed off.

## Quality assurance
- No half ready or incomplete files are delivered.
- A final QA review is required before any client handover.
- The design logic is documented clearly.
- Revisions cover adjustments within scope. Out of scope items are marked as paid add ons.

## Your monthly review
Your standing is judged on:

- Delivering on time, consistently.
- Client satisfaction and how many revisions were needed.
- Design quality and strategic thinking.
- Working well with the team.
- Attendance and punctuality.
- Following company policies.

> **Tip:** Strong performers may earn faster increments or promotions, at management's discretion.
$BODY$,
  array['csr','asr','hr','pm','manager','office_boy']::user_role[], false, 2
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='delivery-qa'),
  'Working With Clients', 'client-facing-policies',
  $BODY$
## Talking to clients
- Reply within 5 to 10 minutes, depending on the service tier.
- Use approved channels only (ClickUp, WhatsApp).
- Do not send progress updates without management approval.
- Revision requests must be clear, doable, and within scope. Vague feedback is not accepted, so ask the client to clarify.

## Scope and add ons
- A package includes only the items listed in the package or proposal.
- Extra concepts, layouts, versions, or formats are paid add ons.
- Revisions are adjustments, not new concepts.
- Add ons are charged before the work begins.

## Revisions
- Each package has a set number of revisions. Extra ones are add ons.
- The revision window is 3 to 6 hours per cycle.

## Portfolio
- Only high quality, strategy backed projects go in the portfolio.
- Weak, client directed designs are left out by default.
- Written client approval is needed before adding their work.
- Strategy documents stay HaseebMadeit property unless the client buys them.
$BODY$,
  array['csr','asr','hr','pm','manager','office_boy']::user_role[], false, 3
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

-- ===== CHAPTER 7 · Tools & Systems ==========================================

insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='tools'),
  'Technology, Equipment and Internet', 'technology-equipment',
  $BODY$
## Company equipment
All laptops, software, and equipment belong to HaseebMadeit. You are responsible for handling them safely and returning them in good condition. Damage caused by carelessness may be charged to you.

## Internet and email
Use them for:

- Work communication and research.
- Client project work.
- Learning and professional development.

Do not use them for:

- Downloading non work material or unapproved software.
- Viewing, sending, or storing sexually explicit content.
- File sharing, media streaming, or unauthorised downloads.
- Breaking copyright.
- Getting around the company's security or filters.
- Sending client data without permission.
- Promoting discrimination of any kind.
- Personal commercial activity or product promotion.

> **Note:** All internet activity is monitored and logged, and senior management may review the logs at any time. Violations can lead to disciplinary action up to termination.

## Recording
- No recording of conversations, clients, or teammates without permission.
- Any audio or video recording needs written consent from everyone involved.
- Send recording requests to HR in advance.

## Software and files
- Use only licensed, company approved design software.
- Do not install personal software.
- Do not bring in files from unknown sources.
- USB drives are restricted. Cloud uploads are required.
- Keep all project files in the designated company folder.
- Upload your files to the shared cloud backup every day.
$BODY$,
  array['csr','asr','hr','pm','manager','office_boy']::user_role[], false, 2
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

-- ===== CHAPTER 8 · HR & Payroll =============================================

insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='hr-payroll'),
  'Compensation and Benefits', 'compensation-benefits',
  $BODY$
## How you are paid
- **Method.** Monthly salary by bank transfer.
- **Date.** Between the 5th and 10th of each calendar month.
- **Components.** Base salary plus performance bonuses.
- **Structure.** All inclusive, during and after probation.
- **Increment review.** Once a calendar year, January to December.

## Bonuses
Performance bonuses are paid monthly from agency profit, and depend on:

- Delivering on time.
- Client satisfaction.
- Project quality and how many revisions were needed.
- Working well with the team.

> **Note:** Bonus eligibility depends mostly on how long and how consistently you have been with us. Monthly output matters, but tenure carries the real weight.

## Increments
Increments are based on performance and are not automatic. They consider performance, attendance, discipline, work quality, targets met, and overall contribution. Management may delay or hold an increment if expectations are not met. Reviews happen from time to time based on business needs, and consider tenure, inflation, and annual performance.

## Final settlement
When you resign, all final dues, including pending bonuses and any earned leave, are settled within 4 to 6 weeks of your official release date, once all company assets are returned and accounts are clear.
$BODY$,
  array['csr','asr','hr','pm','manager','office_boy']::user_role[], false, 2
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='hr-payroll'),
  'Salary Rules and Commission', 'salary-commission',
  $BODY$
## General salary rules
- Salaries are paid according to your agreed employment terms.
- Deductions may apply for unauthorised absence, excessive lateness, or policy violations.
- Complete your responsibilities and stay professional to keep your full salary.

## Sales commission
- Sales team members may earn commission when they hit approved sales targets.
- Commission structures may be revised by management based on business needs.
- Not meeting targets does not create any right to commission.
$BODY$,
  array['csr','asr','hr','pm','manager','office_boy']::user_role[], false, 3
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='hr-payroll'),
  'Annual Service Bonus', 'annual-service-bonus',
  $BODY$
- Employees who complete 1 full year of continuous service may be considered for an annual service bonus.
- It depends on performance, attendance, discipline, and how the company did overall.
- Amounts are decided by management and are not guaranteed.

> **Note:** This is a discretionary benefit, not part of your contractual salary. If you are serving notice when it is paid, you are not entitled to it.
$BODY$,
  array['csr','asr','hr','pm','manager','office_boy']::user_role[], false, 4
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='hr-payroll'),
  'Festival and Team Events', 'festival-engagement',
  $BODY$
## Eid and festivals
- The company gives Eidi on Eid ul Fitr to all eligible employees.
- There is no guaranteed separate Eid ul Adha bonus.

## Team events
We may organise:

- Birthday celebrations in the office.
- Office ceremonies and team events.
- Ramadan iftar gatherings.
- Annual dinners.

Everyone local and on site is encouraged to join in.
$BODY$,
  array['csr','asr','hr','pm','manager','office_boy']::user_role[], false, 5
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='hr-payroll'),
  'Termination and Resignation', 'termination-resignation',
  $BODY$
## How discipline works
| Step | What happens |
| --- | --- |
| 1. Counseling | Your Team Lead or Project Manager talks the issue through, sets expectations, and asks for your commitment to fix it. |
| 2. HR counseling | If it continues, HR holds a formal session and notes it in your file. |
| 3. Verbal warning | A formal verbal warning for repeated issues, documented in your file. |
| 4. Written warning | A written warning with clear expectations. You respond in writing within 1 week, and both are filed. |
| 5. Disciplinary action | Management's final decision, which may be holding an increment, a demotion, or termination. |

> **Important:** Serious violations such as theft, gross negligence, harassment, or data theft may skip steps and lead to immediate termination.

## If you resign
- Give at least 1 month of notice.
- Your final settlement is processed 4 to 6 weeks after your official release.
- Return all company equipment, files, and materials.
- An experience letter is issued once you have served notice and returned assets.

During your notice period, all leave benefits are forfeited, any leave taken is unpaid, and no annual leave can be taken.

## If the company ends employment
HaseebMadeit may end employment immediately, without notice, if you:

- Are charged with or commit a crime.
- Commit fraud or dishonesty.
- Fail to do your job properly or ignore directions.
- Break confidentiality, non compete, or non solicitation rules.
- Are absent without notice for 7 days or more in a row.
- Become permanently unable to work (30 days in a row, or 2 months on and off).
- Take a job with a competitor.
- Do something that damages the company's reputation.
- Break this agreement.

If the company ends your employment without cause, you receive your full notice period salary and final dues.
$BODY$,
  array['csr','asr','hr','pm','manager','office_boy']::user_role[], false, 6
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='hr-payroll'),
  'Joining Documents and Your Information', 'joining-documents',
  $BODY$
## What to bring when you join
- 2 copies of your CNIC.
- 1 copy of a reference CNIC.
- A passport size photograph.
- Your original degree or diploma.
- A signed blank cheque (1 signature on the front, 2 on the back).
- A copy of your previous experience letter, if you have one.
- Your last 2 salary slips or bank statements, if applicable.

## Keep your details current
Tell HR straight away if any of these change:

- Address.
- Email.
- Postal code.
- Phone number.
- Marital status.
- Emergency contacts.
- Banking information.
$BODY$,
  array['csr','asr','hr','pm','manager','office_boy']::user_role[], false, 7
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='hr-payroll'),
  'Raising a Concern', 'raising-a-concern',
  $BODY$
If something is not right, here is how to raise it.

| Step | What to do |
| --- | --- |
| 1. Talk to your PM (within 7 working days) | Raise your concern with your immediate Project Manager. |
| 2. Write to HR (within 7 working days) | If it is not resolved, send a written grievance to the HR Head. |
| 3. Final decision | Management makes the final call, and may settle it or take it further. |

All disputes fall under the courts of Multan, Punjab, Pakistan, and the laws of Pakistan.
$BODY$,
  array['csr','asr','hr','pm','manager','office_boy']::user_role[], false, 8
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

-- ===== CHAPTER 9 · Security & Confidentiality ===============================

insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='security'),
  'Confidentiality and Intellectual Property', 'confidentiality-ip',
  $BODY$
You will see information that must stay inside the company.

## What is confidential
- Client lists and contact details.
- Design strategy and brand thinking.
- Technical processes and methods.
- Business projections and financial data.
- Unpublished design concepts and mockups.
- Client project details and deliverables.

## What you agree to
- Keep all confidential information private, during and after your employment.
- Do not share, copy, or distribute any of it without written permission from management.
- Do not use it for your own benefit or for anyone outside.
- Return all materials when you leave.

Information that is already public, or commonly known in the design industry, is not confidential.

## Who owns the work
- Everything created during your employment belongs to HaseebMadeit or the client, as set by the project agreement.
- Design concepts, strategies, and processes stay HaseebMadeit property unless a client specifically buys them.
- Every deliverable made on company time is company or client property.

> **Rule:** A designer may not use any project in their portfolio without written approval from HaseebMadeit. There are no exceptions.
$BODY$,
  array['csr','asr','hr','pm','manager','office_boy']::user_role[], false, 1
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='security'),
  'Competing and Recruiting', 'non-compete',
  $BODY$
During your employment, and for 1 year after it ends, you agree that you will not:

- Work for, partner with, or advise any competitor of HaseebMadeit.
- Start a competing design or branding agency.
- Approach HaseebMadeit clients to take business away from us.
- Approach HaseebMadeit team members to recruit them.

> **Important:** Breaking this can mean immediate termination, legal action, and a claim for damages.
$BODY$,
  array['csr','asr','hr','pm','manager','office_boy']::user_role[], false, 2
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;
