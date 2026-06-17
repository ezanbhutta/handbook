-- =============================================================================
-- HaseebMadeit Handbook, 0014 content (batch 7): visual design pass
-- Applies the new visual widgets (stats, steps, checklist, keyvalue, dodont)
-- across the key sections so the whole book reads like a design product.
-- Content is preserved; only the presentation is upgraded. Idempotent upsert.
-- =============================================================================

-- ===== Leave: stat tiles =====================================================
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

-- ===== Compensation: spec list ==============================================
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

## Final settlement
When you resign, all final dues, including pending bonuses and any earned leave, are settled within 4 to 6 weeks of your official release date, once all company assets are returned and accounts are clear.
$BODY$,
  array['csr','asr','hr','pm','manager','office_boy']::user_role[], false, 2
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

-- ===== Termination: disciplinary step flow ==================================
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

-- ===== Who to contact: step flow ============================================
insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='escalation'),
  'Who to Contact and How to Escalate', 'who-to-contact',
  $BODY$
When something is past what you can handle, go to your shift Team Leader first. They take it up the chain. Never sit on a problem.

## Your line of contact

```steps
Your shift Team Leader or Senior | The first stop for anything you cannot sort yourself. Morning is Ezan, Evening is Zubair and Ezan, Night is Zubair.
The Project Manager | Order flow, designer assignments, and anything blocking the work.
The CEO, Abdul Haseeb | The final say. You reach him through your Senior, or directly when a Senior says it is a priority.
```

See the [Project Manager role](/section/role-pm) for what the PM owns.

## Escalate right away when
- A client is upset, angry, or asking to cancel or refund. Pass it on at once and promise nothing.
- A case is sensitive, risky, or unclear. Check before you act.
- Anything could touch a client's experience or the company's name.

> **Rule:** Asking for help is never a weakness. It is the right move when something is bigger than your call. Never take a sensitive case on alone.

### For CSRs
The full steps are in the playbook: [SOP 10, Sensitive or Confusing Cases](/section/sop-10-sensitive-cases) and [SOP 13, Cancellations and Upset Clients](/section/sop-13-cancellations).

> **Tip:** When you escalate, give a clear, factual summary, what happened, the order and client, and the history, so your Senior can move fast.
$BODY$,
  array['csr','asr','hr','pm','manager','office_boy']::user_role[], true, 1
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

-- ===== Quarterly bonus: headline stat tiles =================================
insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='hr-payroll'),
  'Quarterly Performance Bonus Policy', 'quarterly-bonus-policy',
  $BODY$
Every three months, the customer support team earns a bonus based on performance, not on sales. You are scored out of 100 on the things you actually control: how you show up, how you talk to clients, and how well you do the work.

```stats
100 | Points
6 | Areas scored
Quarterly | Reviewed and paid
```

> **Tip:** Your bonus is not tied to sales numbers. It is tied to how steady, professional, and careful you are.

## When it is reviewed
| Quarter | Period | Reviewed | Paid |
| --- | --- | --- | --- |
| Q1 | January to March | Last week of March | First week of April |
| Q2 | April to June | Last week of June | First week of July |
| Q3 | July to September | Last week of September | First week of October |
| Q4 | October to December | Last week of December | First week of January |

## The scorecard, out of 100
| Area | Points | What we look at |
| --- | --- | --- |
| Punctuality and attendance | 20 | On time sign in, breaks managed well, no unexplained absences, there through the shift. |
| Behaviour and professionalism | 15 | Respect for the team and Seniors, dress, a positive attitude, no disciplinary notes. |
| Work quality | 20 | Accurate ClickUp and sheet entries, correct file names, clear reports, checked before delivery. |
| Work execution | 15 | The right steps every time, orders and revisions assigned on time, proper escalation, nothing missed. |
| Client communication | 20 | Replies in five minutes, a warm and clear tone, understanding the brief, building real relationships. |
| Cancellation handling | 10 | Escalating cancellations quickly, not handling hard cases alone, following up on them. |

## How each area is scored
Your Senior scores each area on what they can actually see, not on opinion, using the same five levels:

| Rating | Score | What it means |
| --- | --- | --- |
| Excellent | 100% | Went above what we expected, all quarter. Set the example. |
| Good | 80% | Met it well, with only small slips that did not repeat. |
| Average | 60% | Met most of it. Clear places to improve. |
| Below average | 40% | Fell short often. Several issues over the quarter. |
| Poor | 0% | Did not meet it. Serious or repeated problems. |

## The bonus tiers
| Tier | Score | Bonus | Extra |
| --- | --- | --- | --- |
| Elite performer | 90 to 100 | Full bonus plus 10% | Written recognition and first in line for promotion |
| High performer | 75 to 89 | Full bonus | A word of recognition in the team meeting |
| Meets standard | 60 to 74 | Half bonus | A casual feedback session with your Senior |
| Below standard | 40 to 59 | No bonus | An improvement plan for next quarter |
| Unsatisfactory | Below 40 | No bonus | A formal review with HR |

## Who is eligible
- At least 2 full months with us inside the quarter.
- No active written warning at review time. A formal warning takes 10 points off your total.
- No unexcused, unpaid absences during the quarter.
- Daily reports sent steadily, without big gaps.

## Our promise on fairness
- You get your full scorecard every quarter, area by area.
- You can talk your scores over with your Senior before they are final.
- Your Senior gives you feedback monthly, so the quarterly review never surprises you.
- The CEO reviews every score before any bonus is confirmed.
- If you think a score is wrong, you can raise it in writing within 5 working days.
$BODY$,
  array['csr','hr','pm','manager']::user_role[], false, 1
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

-- ===== SOP 07: visual checklist =============================================
insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='fiverr-ops'),
  'SOP 07: Quality Check Before Delivery', 'sop-07-quality-check',
  $BODY$
No design goes to a client, first draft or revision, until you have checked it yourself. This step is not optional.

## The checklist

```checklist
The design matches the brief in style, colour, size, and format.
Every bit of text is right. No spelling mistakes, no wrong names, no wrong numbers on the concepts.
The brand colours, fonts, and assets are what the client asked for. If not, send it back for a revision.
The file is saved in the format the client wanted, whether PNG, PDF, AI, or PSD.
For a revision, every single point the client raised is done and checked by you.
The file name follows our naming convention.
The Google Drive link is live, open, and tidy.
The ZIP opens cleanly. Send both the Drive link and the ZIP, and always upload the open files. Never upload the ZIP itself onto the Drive.
No watermarks, guides, crop marks, or stray bits in the files you send.
The work looks professional, not rushed.
```

Naming follows [SOP 09](/section/sop-09-file-naming).

> **Rule:** If even one of these fails, the file goes back to the designer before it leaves. No exceptions, not for a tight deadline, not for anything. The brand image is everything.
$BODY$,
  array['csr','hr','pm','manager']::user_role[], false, 8
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

-- ===== SOP 08: delivery step flow ===========================================
insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='fiverr-ops'),
  'SOP 08: Delivering to the Client', 'sop-08-delivery',
  $BODY$
Delivery is the moment the client sees the most, so handle it with care and finish every detail.

## Steps, in order

```steps
Finish the quality check first | Never deliver before you have done the full quality check. Delivery always comes after.
Name the files | Follow the naming guide.
Prepare the package | Organise everything into a clear folder, with all the formats, the Drive link, and a ZIP if it suits.
Upload to Google Drive | Use the client's folder and set the sharing so they can open it without any trouble.
Send the delivery message | Keep it professional and on brand. Confirm what you are sending, add the Drive link and the ZIP, and let them know the Drive link works if the ZIP does not open.
Update ClickUp | Move it to Delivered and leave a remark with the date and what went out.
Add a delivery remark | Note the date, the time, what you sent, and the Drive link for the record.
```

Quality check is [SOP 07](/section/sop-07-quality-check); naming is [SOP 09](/section/sop-09-file-naming).

> **Standard:** Every delivery message includes the Google Drive link and the ZIP, with this line: "If the ZIP file does not open, please use the Google Drive link, it is the same in both places."
$BODY$,
  array['csr','hr','pm','manager']::user_role[], false, 9
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

-- ===== SOP 06: good vs poor as do/don't =====================================
insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='fiverr-ops'),
  'SOP 06: Remarks on Every Order', 'sop-06-remarks',
  $BODY$
Every order needs a running set of remarks, so anyone, including a Senior, can understand the whole story by reading them alone. A good remark says what happened, who is involved, and what comes next, in one clear entry.

## Good vs poor

```dodont
The client asked for 3 logo variations on a dark background. Brief shared with the designer. Deadline 28 June, 5:00 PM. Client prefers a minimalist style, noted in the brief. ClickUp updated. | Assigned to designer. Will update soon.
Revision received, 4 points: font to bold, darker background, remove the tagline, centre the logo. Assigned to the designer. Deadline 27 June, 3:00 PM. ClickUp set to Revision In Progress. | Client wants changes. Told designer.
```

## Real examples
Here is how to log the different situations you will run into.

**Frustrated client**
> The client was strongly dissatisfied at 3:15 PM, saying the logo colours do not match what was discussed at onboarding. Their tone was very firm. Escalated to the Senior straight away. No promises made. Awaiting the Senior's direction before replying. ClickUp flagged as Escalated.

**Unclear or incomplete brief**
> The client sent a brief but did not give a colour palette, target audience, or brand tone. Not assigned to a designer yet. Sent a clarification message at 11:30 AM asking for these details. On hold pending the client's reply. ClickUp set to Pending Client Info.

**Cancellation request**
> The client asked to cancel at 2:00 PM, citing a change in business direction. Acknowledged it professionally. No cancellation processed and no refund discussed. Escalated to the Senior at 2:05 PM with a full summary. Designer work paused. ClickUp set to Cancellation, Pending Senior Review.

**Dispute or quality complaint**
> The client disputed the delivered design at 5:45 PM, saying the banner size is wrong (delivered 1080x1080, requested 1920x1080). Reviewing the brief now. The first check confirms the client is right, the dimension was missed. Escalated to the Senior. The designer is preparing a corrected version. Will not deliver again until QC and the Senior sign off.

## How to write them
- Add a remark every time something meaningful happens, such as an assignment, a revision, a delivery, or client feedback.
- Each one says what happened, who is responsible, and the next step.
- Write in clear, simple English. No slang, short forms, or vague lines.
- A Senior who has never touched this client should get the full picture from your remarks alone.
- Always note the time of important events, such as escalations, complaints, and deliveries.
$BODY$,
  array['csr','hr','pm','manager']::user_role[], false, 7
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

-- ===== SOP 12: message scripts as do/don't cards ============================
insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='fiverr-ops'),
  'SOP 12: Looking After the Client Relationship', 'sop-12-client-relationships',
  $BODY$
Our relationships with clients are the most valuable thing we have, and you are the face of the company to them. Every chat should build trust.

## How we talk to clients
- Use the name they prefer.
- Be warm and professional. Never cold, rude, blunt, or too casual.
- Keep your word. If you say you will get back shortly, actually do, not the next day.
- Keep them posted without being asked. If a client has to chase you for an update, that is on the CSR who has their profile.
- If a deadline slips, tell them right away and apologise properly. Never let a deadline pass in silence, and never make us look careless. If a designer or anyone else made a mistake, that stays inside. You never put it on the client.

## Example messages

```dodont
First reply to a new client | Hi [Name], thank you for reaching out to HaseebMadeit. I have your message and am reviewing your requirements right now. I will come back to you with a full response shortly. | ok noted. will check and reply.
A progress update while work is on | Hi [Name], a quick update. Your project is with our design team and on track for delivery by [date and time]. We will send it over as soon as it is ready. | Still working on it.
Delivering finished work | Hi [Name], great news, your [project name] is ready. The files are in the Google Drive link below and as a ZIP. If the ZIP does not open, the Drive link works perfectly. Please review and let us know your thoughts. | Here are your files.
When a deadline cannot be met | Hi [Name], I want to be open with you. Because of [brief reason], we need an extra [time] to make sure your work meets our quality standard. We are sorry for this and appreciate your patience. Your updated delivery time is [new time]. | Sorry for the delay, we will send it soon.
When a client checks in and there is no news yet | Hi [Name], thank you for checking in. Your project is with our design team and progressing well. I will send an update as soon as I have a confirmed timeline. Thank you for your patience. | Not ready yet. Will let you know.
Closing message when a project is done | Hi [Name], it has been a pleasure working on your project. I hope you are delighted with the result. If you ever need anything in future, new designs, revisions, or new projects, we are always here. Thank you for choosing HaseebMadeit. | Done. Let us know if you need anything else.
```

> **Standard:** Every message is a direct reflection of the brand. Write each one as if the CEO will read it. Be warm, clear, and professional, always.

## Building relationships that last
- Put the client's success ahead of the single sale. People who feel looked after come back, every time.
- Remember the little things from past chats and bring them up when it fits.
- When a project wraps up, thank them genuinely and invite them back, with no selling tone.
- Never pressure a client to leave a review or place a new order before they are ready. Understand their problem, guide them well, and ask a Senior if you are stuck. Do not sell. Help. Show them value and you will see the difference.
$BODY$,
  array['csr','hr','pm','manager']::user_role[], false, 13
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;
