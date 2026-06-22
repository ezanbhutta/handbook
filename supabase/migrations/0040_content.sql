-- =============================================================================
-- HaseebMadeit Handbook — 0040 content (batch 32): the Order Management Sheet
-- A dedicated Tools & Systems section documenting the Order Management Sheet,
-- placed right after "How We Use ClickUp". Columns drafted from the live sheet
-- and the user's answers: DOC = date of completion (or the cancellation date if
-- cancelled); the CSR owns the whole row. The "E" and "Order Type" columns are
-- deliberately omitted (E is unused; nothing about organic/inorganic orders is
-- to appear in the handbook). Bumps the two later Tools sections down by one.
-- Idempotent: section upserts by slug; the order_index bumps set fixed values.
-- =============================================================================

-- Make room directly after clickup-basics (order 1).
update sections set order_index = 3 where slug = 'technology-equipment';
update sections set order_index = 4 where slug = 'shift-logger';

insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='tools'),
  'The Order Management Sheet', 'order-management-sheet',
  $BODY$
ClickUp tracks the live workflow of an order. The Order Management Sheet, our shared Google Sheet, is the lasting business record: who the client is, what the project was, who worked on it, what it earned, and how it ended. Every order gets one row, and the CSR who handles the order owns that row from the day it lands to the day it closes.

> **Rule:** The client's name lives here, and only here. It never goes on ClickUp.

## What goes in each column
The CSR fills every column and keeps it current.

```keyvalue
Date of Order | The date the order was placed.
Client Name | The client's name or Fiverr username. This is the only place we keep it.
Project Name | The project name, the same one used on the ClickUp task.
CSR | The CSR handling the order, who owns this row.
Status | Where the order stands, kept in step with the ClickUp status.
Logo Designer | The designer assigned to the work.
Order Amount | The value of the order, in dollars.
Note | Any extra context worth recording for the order.
TIP | Any tip the client added, in dollars.
Review | The star rating the client left, out of five.
DOC | The date of completion. If the order was cancelled, put the cancellation date here instead.
Public Review | Tick this once the client leaves a public review.
Private Feedback | Tick this once the client leaves private feedback.
```

## How it works with ClickUp
The two tools do different jobs, and you keep both current:

- **ClickUp** carries the live status as the order moves through the stages. See [How We Use ClickUp](/section/clickup-basics).
- **The Order Management Sheet** is the record of the order itself and how it ended.

Keep the Status column in step with ClickUp, and never let a completed or cancelled order go unrecorded.

> **Rule:** Log every order in the sheet as it comes in, and keep your row current right through to completion. If it is not in the sheet, it did not happen.
$BODY$,
  array['csr','asr','hr','pm','manager']::user_role[], false, 2
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;
