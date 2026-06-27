-- =============================================================================
-- HaseebMadeit Handbook — 0046 content (batch 38): ASR Playbook, foundation
-- Create a dedicated ASR Playbook chapter (mirroring how the designer content
-- has its own chapter) and the ASR Role overview page, drawn from the ASR role
-- documentation. SOPs, KPIs, report templates, and policies follow in later
-- batches. Visible to ASRs and their leads. Idempotent upserts by slug.
-- =============================================================================

insert into chapters (title, slug, order_index, description, icon) values
  ('ASR Playbook', 'asr-playbook', 14, 'The ASR role: account setup, orders, payments, reporting, security, and escalation.', 'briefcase')
on conflict (slug) do update set
  title=excluded.title, order_index=excluded.order_index, description=excluded.description, icon=excluded.icon;

insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='asr-playbook'),
  'The ASR Role', 'asr-role',
  $BODY$
The ASR, our Artificial Sales Representative, sets up and looks after the accounts we work on, places and manages orders, and keeps every account in good standing. You are careful, organised, and steady, and you treat every account and every order as something that carries the company's name.

## Position overview
```keyvalue
Job title | Artificial Sales Representative (ASR)
Department | Client Services and Operations
Reports to | Team Leader or HR Manager
Employment type | Full-time
Working hours | Shift-based; the company runs 24/7
Location | Onsite, Multan, Punjab, Pakistan
```

## Key responsibilities
- Create and manage the accounts and profiles we work on, and keep them all up to date.
- Communicate with sellers in line with company guidelines.
- Place, answer, and manage orders on time.
- Track every order and work with the team so the process stays smooth.
- Monitor each account's performance, ratings, and feedback.
- Follow platform rules and company policies at all times.
- Manage multiple accounts carefully, within the company's terms.
- Read daily progress and performance reports, and plan the next steps accordingly.
- Keep clean records of accounts, orders, and the daily workflow.
- Submit daily, weekly, biweekly, and monthly reports on time.
- Keep all data secure and confidential.
- Handle everyday tasks properly, from start to finish.

## What it takes
- Organised and detail-oriented, able to manage multiple accounts without dropping the ball.
- Reliable and consistent: you show up, follow through, and meet deadlines.
- A clear communicator who can write professional messages in English.
- Comfortable with technology: online platforms, spreadsheets, and the basic tools.
- Trustworthy with sensitive account and client data, in full confidence.
- A team player who coordinates smoothly with designers, the CSR team, and Team Leaders.

## How the role runs
Your work runs on seven SOPs, backed by a clear set of policies. Follow them from day one. Any deviation must be approved in advance by a Senior or Team Leader.

```steps
Account Setup and Maintenance | Create and look after the accounts, and keep them healthy.
Order Placement and Management | Place, track, and complete orders on time.
Client and Seller Communication | Reply professionally and on time, and escalate anything sensitive.
Payment Handling | Check balances, record every transaction, and report problems fast.
Records and Reporting | Keep the sheets live and send every report on time.
Data Security and Confidentiality | Protect every credential and every piece of client data.
Escalation | Know when to stop and ask a Senior.
```

> **Rule:** When in doubt, stop and ask. Acting without guidance costs more than a short delay.
$BODY$,
  array['asr','hr','pm','manager']::user_role[], true, 1
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;
