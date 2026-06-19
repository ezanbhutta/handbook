-- =============================================================================
-- HaseebMadeit Handbook — 0030 content (batch 22): merge + de-duplicate
-- Follow-up to 0029. The CEO confirmed: add new material AND update existing
-- sections where the source document is more complete, with no duplicate
-- sections, all in the house voice.
--
-- Key fix: 0029 added a standalone "The Disciplinary Process" section, but the
-- existing "Termination and Resignation" already carries a (richer, company-
-- specific) disciplinary ladder. To avoid two competing ladders we DROP the new
-- section and instead fold its one genuinely-new piece — the appeal process —
-- into "Termination and Resignation", plus the missing "assault" ground.
--
-- Other merges fold document specifics into the sections that already own the
-- topic: harassment reporting route (Code of Conduct), social-media rules
-- (Communication & Social Media), promotions (Compensation), and the concrete
-- file-naming convention (Designer SOPs). Universal policies are also opened up
-- to the designer role. Idempotent.
-- =============================================================================

-- Drop the duplicate disciplinary section added in 0029 -----------------------
delete from sections where slug = 'disciplinary-process';

-- Repoint the HR role's cross-reference now that discipline lives in T&R ------
update sections
   set body = replace(body, 'as set out in the Disciplinary Process.', 'as set out in Termination and Resignation.')
 where slug = 'hr-manager-role';

-- Conduct & Culture — Code of Conduct (+ harassment reporting route) ----------
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

## Zero tolerance for harassment
Everyone here has the right to work free from harassment of any kind — verbal, physical, or digital. We do not tolerate bullying, intimidation, or discrimination from anyone, at any level.

- If you experience or witness harassment, report it to the HR Manager straight away.
- Every report is handled in strict confidence, and investigated promptly and fairly.
- Raising a genuine concern in good faith will never be held against you.

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
  array['csr','asr','hr','pm','manager','office_boy','designer']::user_role[], false, 1
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

-- Conduct & Culture — Communication and Social Media (+ social-media rules) ---
insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='conduct'),
  'Communication and Social Media', 'communication-social-media',
  $BODY$
## Everyday communication
- Keep communication professional and respectful at all times.
- Give constructive feedback only, and take complaints to management.
- Share suggestions through the proper channels — your Team Lead or HR.
- Keep nothing inappropriate on company group chats or official accounts.

## Social media
What you post in public reflects on the company, so a few firm rules:

- Do not post negative remarks about the company, your colleagues, or our clients on any platform.
- Never share client work, orders, or anything about how we work internally on personal social media.
- If you want to mention HaseebMadeit on a professional platform like LinkedIn, get HR's approval first.
- Do not post any company information online without permission.

> **Rule:** Client work and internal processes are confidential. They do not belong on personal feeds or portfolios.
$BODY$,
  array['csr','asr','hr','pm','manager','office_boy','designer']::user_role[], false, 3
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

-- HR & Payroll — Compensation and Benefits (+ promotions) ---------------------
insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='hr-payroll'),
  'Compensation and Benefits', 'compensation-benefits',
  $BODY$
## How you are paid

```keyvalue
Method | Bank transfer, monthly
Pay date | Between the 5th and 10th
Components | Base salary plus performance bonuses
Structure | All inclusive, during and after probation
Increment review | Once a year, Jan to Dec
```

## Bonuses
Performance bonuses are paid monthly from agency profit, and depend on:

- Delivering on time.
- Client satisfaction.
- Project quality and how many revisions were needed.
- Working well with the team.

> **Note:** Bonus eligibility depends mostly on how long and how consistently you have been with us. Monthly output matters, but tenure carries the real weight.

## Increments
Increments are based on performance and are not automatic. They consider performance, attendance, discipline, work quality, targets met, and overall contribution. Management may delay or hold an increment if expectations are not met. Reviews happen from time to time based on business needs, and consider tenure, inflation, and annual performance.

## Promotions
Promotions follow real growth, not just time served. We look at:

- How much your skills have grown.
- How consistent and reliable you have been.
- Whether a suitable role is open.

All promotion decisions are made by the CEO, in consultation with HR.

## Final settlement
When you resign, all final dues, including pending bonuses and any earned leave, are settled within 4 to 6 weeks of your official release date, once all company assets are returned and accounts are clear.
$BODY$,
  array['csr','asr','hr','pm','manager','office_boy','designer']::user_role[], false, 2
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

-- HR & Payroll — Termination and Resignation (+ assault ground + appeal) ------
insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='hr-payroll'),
  'Termination and Resignation', 'termination-resignation',
  $BODY$
## How discipline works

```steps
Counseling | Your Team Lead or Project Manager talks the issue through, sets expectations, and asks for your commitment to fix it.
HR counseling | If it continues, HR holds a formal session and notes it in your file.
Verbal warning | A formal verbal warning for repeated issues, documented in your file.
Written warning | A written warning with clear expectations. You respond in writing within 1 week, and both are filed.
Disciplinary action | Management's final decision, which may be holding an increment, a demotion, or termination.
```

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
- Physically assault someone, or behave in a threatening way at work.
- Are absent without notice for 7 days or more in a row.
- Become permanently unable to work (30 days in a row, or 2 months on and off).
- Take a job with a competitor.
- Do something that damages the company's reputation.
- Break this agreement.

If the company ends your employment without cause, you receive your full notice period salary and final dues.

## If you want to appeal
If you receive a warning or a termination notice and you believe it is unfair, you have the right to appeal.

```steps
Appeal in writing | Send your appeal to the HR Manager within 5 working days.
Review meeting | HR holds a review meeting within 7 working days of your appeal.
Final decision | The CEO's decision after that review is final.
```

> **Tip:** Put your side in writing clearly and calmly, with any dates or details that help. A fair hearing works best when everyone has the facts.
$BODY$,
  array['csr','asr','hr','pm','manager','office_boy','designer']::user_role[], false, 6
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

-- Designers — Designer SOPs (+ concrete file-naming convention) ---------------
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

## File naming and formats
"Proper naming" means one consistent pattern, every single time:

```keyvalue
Pattern | ClientName_ProjectType_Version_Date
Example | AhmadBrand_Logo_v2_2024-01-15
Formats | Deliver in the agreed formats — AI, PSD, PDF, PNG — at the right resolution
Storage | Keep every final source file in the company drive, never only on your own machine
```

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
