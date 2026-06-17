-- =============================================================================
-- HaseebMadeit Handbook, 0017 content (batch 10): the ASR role
-- Adds "The ASR Role" to the Your Role chapter, written in the plain human
-- voice. General responsibilities only: no individual names, no per-person
-- quotas, and no sensitive operational detail (per the no-confidential-data
-- rule). Visible to ASR, HR, PM, and Manager. Idempotent upsert by slug.
-- =============================================================================

insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='your-role'),
  'The ASR Role', 'role-asr',
  $BODY$
An ASR sets up and looks after the accounts we work on, places and manages orders, and keeps every account in good standing. You are careful, organised, and steady, and you treat every account and every order as something that carries the company's name.

## What you are responsible for

```checklist
Create and manage the accounts and profiles we work on, and keep them all up to date.
Communicate with sellers and clients the way the company guidelines ask you to.
Place, answer, and manage orders on time.
Track every order and work with the team so the process stays smooth.
Watch each account's performance, ratings, and feedback.
Follow the platform rules and the company policies at all times.
Manage several accounts carefully, within the company's terms.
Read the daily progress and performance, and plan your next move from it.
Keep clean records of the accounts, the orders, and your daily workflow.
Send your daily, weekly, every two weeks, and monthly reports.
Keep every kind of data secure and confidential.
Handle your everyday tasks properly, from start to finish.
```

## How the day runs
Most days move through the same few areas of work:

- **Set up and upkeep.** Prepare and secure the accounts and payment profiles we use, and keep them healthy and ready.
- **Orders and briefs.** Place orders, write clear briefs, and keep them moving for the clients we serve, mainly in the United States and Canada.
- **Communication.** Reply on the accounts, accept orders, and leave proper feedback.
- **Payments.** Keep the payment accounts ready and the balances in order, so nothing holds up an order.
- **Records and reports.** Keep your sheets current, and send your reports on time.

> **Rule:** Every account and every order carries the company's name. Keep all data secure and confidential, follow the platform rules, and check with a Senior before you act on anything sensitive or unclear.
$BODY$,
  array['asr','hr','pm','manager']::user_role[], true, 2
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

-- Place the ASR role right after the CSR role, shifting the seniors down one.
update sections set order_index = 3 where slug = 'role-senior-csr';
update sections set order_index = 4 where slug = 'role-pm';
