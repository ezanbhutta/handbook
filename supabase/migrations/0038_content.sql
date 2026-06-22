-- =============================================================================
-- HaseebMadeit Handbook — 0038 content (batch 30): order lifecycle, real statuses
-- Rewrite the order lifecycle to use the agency's actual ClickUp statuses
-- (Pickup Your Projects, In Progress, Deliver to Client, Client Response,
-- Revision, Revision Complete, Final Files, Complete, plus Cancelled) and the
-- real ownership of each transition: the designer sets In Progress and
-- Revision Complete; the CSR sets Client Response and moves it back to Revision.
-- Also: the task is named for the project (not the client) and the client name
-- is not stored on ClickUp. Keeps the corrected deliverable format set.
-- Full re-upsert of the order-lifecycle section, idempotent by slug.
-- =============================================================================

insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='fiverr-ops'),
  'The Order Lifecycle: From Placed to Completed', 'order-lifecycle',
  $BODY$
This is the whole journey of an order in one place: from the moment it lands on Fiverr to the moment it is marked complete. Each stage shows what to do on Fiverr and what to do in ClickUp, including the exact ClickUp status to set. The individual SOPs cover each step in depth. This page is how they fit together.

```steps
Order Placed | The order arrives and the brief comes in. Confirm it is complete before any work starts.
Project Assigning | Put the task in the pickup queue and hand it to a designer with a complete brief and a clear deadline.
Project Delivery | The designer finishes, you quality-check, and the first design goes to the client.
Revision | The client sends changes. You read them, clarify anything unclear, and log them.
Revision Assigning | Hand the revision to the designer, quality-check the result, and send it back to the client.
Final Files | Once approved, prepare the final, correctly-named files in every format.
Final Delivery | Deliver on Fiverr with the Drive link and ZIP, then mark the order Complete and close it well.
```

## ClickUp status at each stage
These are the real ClickUp statuses. Keep the task moving through them so anyone can see where the order stands at a glance.

```keyvalue
Order placed and queued | Pickup Your Projects
Designer working on it | In Progress
First design ready for the client | Deliver to Client
Waiting on the client | Client Response
Client asked for changes | Revision
Designer finished the revision | Revision Complete
Client approved, finals going out | Final Files
Order accepted and closed | Complete
```

> **Note:** If an order is ever cancelled, the task goes to **Cancelled** in ClickUp. Never do that on your own, see stage 7.

## 1. Order Placed
The order lands on Fiverr and the buyer shares the brief. Nothing goes to a designer until the brief is complete.

**On Fiverr**
- Reply to the buyer within five minutes, even if it is just to say you are on it. See [SOP 02](/section/sop-02-query-5-min).
- Read the full profile and order history before you respond. See [SOP 01](/section/sop-01-profile-review).
- Confirm the brief is complete: size, file formats, brand colours, references, copy, and any special notes. If anything is missing, sort it out with the buyer first.

**On ClickUp**
- Create the task for this order. Name it for the project, not the client.
- Set the status to **Pickup Your Projects** so a designer can pick it up.
- Add the order number, the deadline, and the brief. We do not put the client's name on ClickUp.
- Leave a first remark with the order details. See [SOP 06](/section/sop-06-remarks).

## 2. Project Assigning
Hand the order to the right designer with everything they need.

**On Fiverr**
- Let the buyer know the work is underway and when to expect the first design.

**On ClickUp**
- Confirm the brief is complete before you assign. See [SOP 04](/section/sop-04-assign-designers).
- Add the designer as the assignee, with the order number, deadline, brief file, and any notes on what the client is particular about.
- Leave the task in **Pickup Your Projects**. The designer moves it to **In Progress** when they start working.
- Our designers are on monthly contracts with fixed daily projects, delivered inside their shift, so the work is already committed. You do not need to chase a per-task agreement.
- Leave a remark noting who it went to and when it is due.

## 3. Project Delivery
The designer finishes, you check the work, and the first design goes to the client.

**On ClickUp**
- When the designer is done, they set the status to **Deliver to Client**.
- Run the full quality check before anything leaves. See [SOP 07](/section/sop-07-quality-check).
- Once you have delivered the initial draft on the order page, set the status to **Client Response** while you wait for their feedback.
- Leave a remark with what was shared and when.

**On Fiverr**
- Deliver the initial draft on the order page, then ask the buyer for their feedback in one consolidated message.
- Never send a design you have not checked yourself.

## 4. Revision
The client sends changes. Treat a revision with the same care as a new order.

**On Fiverr**
- Read every point the buyer raised before you do anything. See [SOP 05](/section/sop-05-revisions).
- If a point is unclear, check with the buyer first. Never let a designer start on guesswork.

**On ClickUp**
- Set the status to **Revision** and log it: the revision number, the deadline, and a short line on what is changing.

## 5. Revision Assigning
Hand the revision to the designer, then check it and send it back.

**On ClickUp**
- Assign the revision to the designer with a clean, numbered list of exactly what is changing, and a deadline. The task stays in **Revision** while they work.
- When the designer finishes, they set the status to **Revision Complete**.
- Quality-check that every single point the client raised is done. See [SOP 07](/section/sop-07-quality-check).
- Send the revised design to the buyer, then set the status to **Client Response** and leave a remark.
- If the client asks for more changes, move it back to **Revision** and repeat, within the agreed revisions.

**On Fiverr**
- Send the revised design to the buyer and confirm the changes you made.

## 6. Final Files
Once the client approves, prepare the final package properly.

**On Fiverr**
- Get the buyer's clear approval before you prepare the final files.

**On ClickUp**
- Set the status to **Final Files**.
- Prepare every format the client asked for — AI, EPS, SVG, PNG, JPEG, and PDF — including the with-background and without-background versions of SVG and PDF.
- Name every file the right way. See [SOP 09](/section/sop-09-file-naming).
- Upload the open files to the client's Google Drive folder, set so they can open it. Do not upload the ZIP itself to the Drive.
- Leave a remark that the final files are ready.

## 7. Final Delivery
Deliver the final work, mark it done, and close the order well.

**On Fiverr**
- Deliver the order with the final files, the Google Drive link, and the ZIP.
- Use the standard delivery message and include this line: "If the ZIP file does not open, please use the Google Drive link, it is the same in both places." See [SOP 08](/section/sop-08-delivery).
- Once the buyer accepts, the order is marked complete. Thank them warmly and invite them back, with no pushy review ask. See [SOP 12](/section/sop-12-client-relationships).

**On ClickUp**
- Once the buyer accepts, set the status to **Complete**.
- Leave a final remark with the date, the time, what you sent, and the Drive link.
- Include the delivery in your daily report. See [SOP 14](/section/sop-14-daily-report).

> **Rule:** Throughout every order, keep ClickUp updated at least once an hour, leave a remark on every change, and never let a task sit in the wrong status. See [SOP 03](/section/sop-03-clickup-updates).

> **Important:** A cancellation or an upset client goes to a Senior or your Manager straight away, and the task moves to **Cancelled**. Do not cancel, refund, or promise anything on your own. See [SOP 10](/section/sop-10-sensitive-cases) and [SOP 13](/section/sop-13-cancellations).
$BODY$,
  array['csr','asr','hr','pm','manager']::user_role[], false, 16
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;
