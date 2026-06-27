-- =============================================================================
-- HaseebMadeit Handbook — 0049 content (batch 39): ASR KPIs, report templates, policies
-- Three reference sections for the ASR Playbook, drawn from the ASR documentation:
-- the KPI set and review schedule, the daily/weekly/monthly report templates, and
-- the ASR policies (confidentiality, platform compliance, escalation, account
-- management, communication). Visible to ASRs and their leads. Idempotent by slug.
-- =============================================================================

-- ===== ASR KPIs & Performance ================================================
insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='asr-playbook'),
  'ASR KPIs and Performance', 'asr-kpis',
  $BODY$
Your performance is reviewed daily, weekly, and formally at the 30-day, 60-day, and 90-day marks. Every KPI here is tracked by the Team Leader, so you always know where you stand.

## The KPIs
| KPI | How it is measured | Target | Review |
| --- | --- | --- | --- |
| Order accuracy | Share of orders placed correctly: right account, right amount, right brief | 98% or higher | Weekly |
| Order timeliness | Share of orders placed within the agreed timeframe | 95% or higher | Daily |
| Account health | No warnings, flags, or policy violations on managed accounts | Zero violations | Weekly |
| Report submission | Daily, weekly, biweekly, and monthly reports submitted on time | 100% on time | Per cycle |
| Response time | Time to reply to messages within the shift | Within 15 minutes | Daily |
| Record accuracy | Tracker sheets complete and accurate at shift end | 100% | Daily |
| Escalation compliance | Sensitive issues escalated rather than handled without approval | 100% escalated | As needed |
| Data security | Security incidents or breaches caused by ASR actions | Zero incidents | Monthly |

## The review schedule
| Review | Who conducts it | Outcome |
| --- | --- | --- |
| 30-day review | Team Leader and HR Manager | Identify gaps, update the training plan |
| 60-day review | Team Leader | Mid-probation check and a performance score |
| 90-day review | HR Manager | Probation decision: confirm, or extend or exit |
| Monthly, ongoing | Team Leader | KPI score, feedback, and next-month targets |

> **Tip:** None of these are a surprise. Keep your sheets current and your reports honest, escalate what should be escalated, and the scores follow.
$BODY$,
  array['asr','hr','pm','manager']::user_role[], false, 9
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

-- ===== ASR Report Templates ==================================================
insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='asr-playbook'),
  'ASR Report Templates', 'asr-report-templates',
  $BODY$
Use these templates exactly. Do not abbreviate or skip sections, and send every report on time. Late reports count against your KPI score. This is the reporting in [ASR SOP 5: Records and Reporting](/section/asr-sop-records-reporting).

## Daily report
```keyvalue
ASR name | Your full name.
Date | The date, as DD/MM/YYYY.
Shift | Morning, afternoon, or night.
Accounts checked | The account names or IDs you checked today.
Orders placed | The number and a brief description, for example three logo orders on Account A.
Messages handled | The number of messages you replied to or accepted.
Issues flagged | Any problems, warnings, or unusual activity. Be specific.
Escalations | What you escalated and to whom.
Pending items | What is still open and needs action tomorrow.
Tomorrow plan | The top three things you will do first next shift.
Notes | Anything else the Team Leader should know.
```

## Weekly report
```keyvalue
ASR name | Your full name.
Week | For example, Week 2, 9 June to 15 June 2025.
Accounts managed | Every account you handled this week.
Total orders placed | The number.
Total orders completed | The number.
Pending or delayed orders | The order IDs and the reason for the delay.
Account health | Any ratings changes, warnings, or flags this week.
Issues encountered | What went wrong and how it was handled.
Communication summary | The volume and quality of the messages you handled.
KPI self-score | Rate yourself on order accuracy, timeliness, and record keeping, from 1 to 5.
Next-week goals | Two or three specific things you will focus on improving.
Support needed | Anything you need from the Team Leader or HR to do your job better.
```

## Monthly report
```keyvalue
ASR name | Your full name.
Month | For example, June 2025.
Accounts under management | The full list with current status: active, flagged, or paused.
Total orders placed | The count for the month.
Total orders completed | The count and the completion rate.
Account health summary | Ratings, reviews received, and any warnings or suspensions.
Key wins this month | Specific achievements, such as accounts improved or orders completed cleanly.
Key challenges | What was hard and how you handled it.
KPI performance | A self-assessment against all eight KPIs, with a score.
Training and growth | Anything you learned or want to learn.
Recommendations | Suggestions for improving the process or the tools.
Next-month targets | Three to five specific, measurable goals for the coming month.
```

> **Rule:** Reports must be honest and specific. "All good" is not an acceptable report.
$BODY$,
  array['asr','hr','pm','manager']::user_role[], false, 10
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

-- ===== ASR Policies ==========================================================
insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='asr-playbook'),
  'ASR Policies', 'asr-policies',
  $BODY$
These policies sit behind every ASR SOP. They are not optional, and the rules on confidentiality and platform compliance are non-negotiable.

## 1. Data confidentiality
You handle sensitive data: account credentials, client identities, order details, and payment information. Protect all of it.
- Never share account usernames, passwords, or access codes with anyone outside the approved team.
- Never discuss client names, orders, or account details outside of work channels.
- Do not access accounts on personal devices unless explicitly authorised in writing.
- Do not screenshot sensitive screens and share them on personal phones or social media.
- Lock your screen every time you step away from your workstation, even briefly.
- Log out of all accounts at the end of every shift.
- Report any suspected breach, unusual login, or unauthorised access within five minutes.

> **Rule:** A breach of data confidentiality is subject to immediate disciplinary action, up to and including termination.

## 2. Platform compliance
We operate across platforms, primarily Fiverr, that have strict terms of service.
- Read and follow the platform's terms of service. Not knowing them is not an excuse.
- Never try to bypass a platform rule, not even for a shortcut that looks harmless.
- Never use fake reviews, manipulation, or any grey-area method without Senior approval.
- Report any platform warning, policy notice, or flag to the Team Leader immediately. Never dismiss or ignore it.
- An account ban caused by ASR non-compliance is treated as a serious disciplinary matter.

## 3. Escalation
The rule is simple: when in doubt, stop and ask. Do not guess on anything sensitive. The full flow is in [ASR SOP 7: Escalation](/section/asr-sop-escalation). Always escalate to the Team Leader or a Senior when:
- An account receives any kind of warning or flag.
- A client or seller behaves unusually or makes demands outside the normal scope.
- A payment fails, shows the wrong amount, or behaves unexpectedly.
- You are unsure how to respond to a sensitive message.
- A dispute, refund request, or complaint is raised.
- You notice anything that feels wrong, unusual, or that you have not seen before.

## 4. Account management
- Every account is logged in the Account Register Sheet from day one.
- No account is used for any purpose outside what the company has assigned.
- Account credentials are never stored on personal phones, notes apps, or unsecured files.
- Any account you stop managing is formally handed over to the Team Leader.
- Do not create new accounts or profiles on your own without prior written instruction.

## 5. Communication standards
- All written communication on accounts is professional, polite, and in clear English.
- No informal language, slang, or abbreviations in client or seller messages.
- Do not make promises, offer discounts, or commit to timelines without Team Leader approval.
- A disputed or unclear message is reviewed by the Team Leader before you reply.
- Feedback on completed orders follows the approved templates. Do not improvise.
$BODY$,
  array['asr','hr','pm','manager']::user_role[], false, 11
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;
