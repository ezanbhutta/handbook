-- =============================================================================
-- HaseebMadeit Handbook, 0018 content (batch 11): the CSR Shift Logger
-- Explains the company shift logging system: what it is, how a shift flows
-- through it, what can be logged, and how it improves the CSR workflow.
-- No names, profiles, or passwords appear (no confidential data). Human voice,
-- with widgets. Visible to CSR, HR, PM, Manager. Idempotent upsert by slug.
-- =============================================================================

insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='tools'),
  'The CSR Shift Logger', 'shift-logger',
  $BODY$
The Shift Logger is where you record what you do on a profile while you are on shift. You tap an action, fill in a few details, and submit. The app keeps the running count for you, so there is no report to write by hand at the end. You log as you go, and the summary writes itself.

> **Key principle:** You are the sensor, the app is the record. If it happens on the profile, it goes in the log, the moment it happens.

## What it is
- It stands on its own. It does not pull from ClickUp or any sheet. Your entries are the record.
- Every action is a proper entry with set fields, so it can be counted and rolled up. You never type a total.
- You can fix an entry later. An inquiry that turns into an order is updated, not typed again.

## How a shift works

```steps
Start your shift | Open the app, pick your name, your shift, and the profile you are covering. Your sign in time and the date are stamped for you. One report covers one profile, so if you hold two profiles you file two reports.
Read the handover note | If the last person on this profile left a note, it shows up the moment you sign in. Read it and tap Noted, so nothing from the shift before is lost.
Log each action as it happens | Tap the action on your Shift Home, fill the short form that opens, and submit. The counter for that action goes up on its own.
Watch the live summary | Your counts add up at the top of the screen as you work. No tallying, no guessing.
Run the wrap up checklist | Before you close, tick the end of shift checks, like CRM updated, ClickUp cleared, portfolio updated, briefs created, analytics checked, and orders checked one by one.
Check out and submit | Your check out time is stamped and the report locks. Leave a short note for the next person on this profile, and you are done.
```

> **Standard:** Once you submit, the report locks. Nothing can be changed after that, so the record stays honest. Log it carefully the first time.

## What you can log
The buttons are grouped so the right one is easy to find:

- **Inquiries.** A new inquiry, or a lead follow up.
- **Orders and projects.** A new order, an order assigned to a designer, an order completed.
- **Revisions.** A revision assigned to a designer.
- **Sharing and deliveries.** A project delivered, and anything you shared to the client in chat.
- **Follow ups and sales.** A follow up with a client, a follow up with a designer, an upsell, an offer.
- **Meetings.** New or existing client meetings, with the agenda.
- **Problems and other.** A frustrated client, a disputed client, an extension sent, or spam.

## Two views
- **Your app.** Open, with no password. You pick your name and start. This is where you log.
- **The leadership console.** A separate view, protected by a password, for the CEO and managers. It shows live totals and a row for every CSR, and it can be filtered by shift, profile, and date.

> **Note:** Managers keep the team roster current inside the app, and may choose to allow logging only from the office.

## Why it makes your shift easier

```checklist
No report to write at the end. You log as you go, and the summary is ready when you check out.
Your work is visible and counted, so reviews rest on what you actually did, not on memory.
Nothing slips through. Every action carries the time, so a Senior can follow the whole shift.
Handovers are clean. The next person on the profile gets your note the moment they sign in.
Real numbers fall out of it, like how many inquiries turned into orders, with no extra work.
The record is honest, because it locks the moment you submit.
```

> **Tip:** Log the action the moment it happens, not at the end of the shift. It takes a few seconds, and it keeps both your counts and your memory accurate.
$BODY$,
  array['csr','hr','pm','manager']::user_role[], false, 3
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;
