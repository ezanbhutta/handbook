-- =============================================================================
-- HaseebMadeit Handbook — 0048 content: ASR Playbook SOPs 5–7
-- Adds three SOP sections to the existing 'asr-playbook' chapter:
--   SOP 5 Records and Reporting, SOP 6 Data Security and Confidentiality
--   (both standard five-part shape), and SOP 7 Escalation (adapted shape).
-- Idempotent full re-upserts keyed by slug.
-- =============================================================================

insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='asr-playbook'),
  'ASR SOP 5: Records and Reporting', 'asr-sop-records-reporting',
  $BODY$
## Why it matters
Your sheets and reports are the only window the rest of the team has into your accounts. When they are current and honest, the Team Leader can plan the next move with confidence; when they are behind or vague, the company plans on guesswork. Clean records and on-time reports are how you carry your share of the work in plain sight.

## Tools and access you need
```keyvalue
Daily Activity Sheet | Where you log communications and daily work in real time.
Report templates | The set formats for each report (see ASR Report Templates).
Reporting channel | The designated WhatsApp or Email channel to the Team Leader.
```

> **Tip:** The [ASR Report Templates](/section/asr-report-templates) give you the exact shape for each report, so you are not starting from a blank page.

## Steps
```steps
Update the sheet in real time | Update the Daily Activity Sheet as the work happens, not at the end of the shift.
Send the daily report | Submit it before the shift ends: accounts checked, orders placed, issues flagged.
Send the weekly report | Every Sunday or the last day of the work week, with a summary and the next-week plan.
Send the biweekly report | On the 15th and the last day of each month.
Send the monthly report | On the last working day, with a full account-health summary.
Use the designated channel | Send all reports to the Team Leader via WhatsApp or Email, as directed.
Keep it honest and specific | An entry like "all good" is not an acceptable daily report.
```

## If something goes wrong

| If this happens | What to do |
| --- | --- |
| You are running short on time | Still send the report complete and on time; do not skip parts to save minutes. |
| A sheet has fallen behind | Update it in real time from now on; never leave it to the end of the shift. |
| You have nothing to report on a metric | Still be specific about it; never fall back on "all good". |

## Done right when
```checklist
The Daily Activity Sheet is current, updated as the work happens.
Every due report, daily, weekly, biweekly and monthly, went out on time.
Every report is honest and specific, with no "all good" stand-ins.
```
$BODY$,
  array['asr','hr','pm','manager']::user_role[], false, 6
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='asr-playbook'),
  'ASR SOP 6: Data Security and Confidentiality', 'asr-sop-data-security',
  $BODY$
## Why it matters
You hold credentials, client names, and order details that the company is trusted to keep private. One careless screenshot, one unlocked screen, or one login from the wrong device can expose all of it. Guarding this data is part of the job, not an extra, and the standard here is strict for good reason.

> **Rule:** Breaches of data confidentiality are subject to immediate disciplinary action, up to and including termination.

## Tools and access you need
```keyvalue
Approved devices | The work devices you are cleared to access accounts on.
Company channels | The approved channels for any account or client information.
Senior | Your point of contact for any incident or security report.
```

## Steps
```steps
Keep data inside the team | Never share account credentials, client names, or order details outside the team.
Lock your screen | Lock it every time you leave your workstation, even for a minute.
No personal devices | Do not access accounts on personal devices unless specifically approved in writing.
No loose screenshots | Do not screenshot accounts or order data and share it on personal phones or chats.
Report security alerts | Report any suspicious access, login issue, or security alert to a Senior immediately.
Close down at shift end | Log out of all accounts and close all browser tabs.
Report breaches within 5 minutes | Report any breach or suspected breach within 5 minutes, no exceptions.
```

## If something goes wrong

| If this happens | What to do |
| --- | --- |
| You see a suspected breach or an unusual login | Report it to a Senior within 5 minutes, no exceptions. |
| You need account access on a personal device | Stop, and get written approval before you go any further. |
| You are about to step away from your workstation | Lock the screen first, even if it is only for a minute. |

## Done right when
```checklist
Every credential and client detail stayed inside the team.
The screen was locked whenever you stepped away.
All accounts were logged out and every browser tab closed at shift end.
Any incident was reported within 5 minutes.
```
$BODY$,
  array['asr','hr','pm','manager']::user_role[], false, 7
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='asr-playbook'),
  'ASR SOP 7: Escalation', 'asr-sop-escalation',
  $BODY$
## Why it matters
You are expected to know when to act and when to ask. On a sensitive matter, a quick wrong move can cost far more than a short pause to get guidance. Never carry a sensitive case alone; bringing it to someone is the right call, not a failure.

## When to escalate
```checklist
A client or seller behaves unusually or makes demands outside the normal scope.
An account receives a warning, flag, or suspension notice of any kind.
You are unsure how to respond to a message; never guess on sensitive matters.
A payment fails, is delayed, or shows an unexpected amount.
You discover a policy violation, even if you did not cause it.
A client requests a refund or a revision, or escalates a dispute.
Anything that feels wrong, unusual, or that you have never seen before.
```

## How to escalate
```steps
Stop and hold | Do not reply or act on the sensitive matter yet.
Bring it to the Team Leader or a Senior | Give the full, factual picture: the account, the order, the message, the history.
Follow their direction | Do exactly what they tell you, nothing more or less.
Log it | Record what you escalated, when, to whom, and what was agreed, in the Daily Activity Sheet.
```

## Done right when
```checklist
You held off acting until you were guided.
The Team Leader or Senior had the full picture.
You followed their direction.
The escalation is logged in the Daily Activity Sheet.
```

> **Rule:** When in doubt, stop and ask. Acting without guidance costs more than a short delay.
$BODY$,
  array['asr','hr','pm','manager']::user_role[], false, 8
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;
