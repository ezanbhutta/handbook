-- =============================================================================
-- HaseebMadeit Handbook — 0036 content (batch 28): the full order lifecycle
-- One comprehensive section in the Fiverr Operations Playbook that walks an
-- order from placed to completed, with the Fiverr steps and the ClickUp steps
-- side by side at each stage: Order Placed, Project Assigning, Project Delivery,
-- Revision, Revision Assigning, Final Files, Final Delivery. Drafted from the
-- existing SOPs (statuses, naming, QC, delivery) plus the standard Fiverr order
-- flow, and cross-linked to each SOP. Visible to csr, asr, hr, pm, manager.
-- Placed at the end of the chapter as the capstone. Idempotent upsert by slug.
-- =============================================================================

insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='fiverr-ops'),
  'The Order Lifecycle: From Placed to Completed', 'order-lifecycle',
  $BODY$
This is the whole journey of an order in one place: from the moment it lands on Fiverr to the moment it is delivered and marked complete. Each stage shows what to do on Fiverr and what to do in ClickUp. The individual SOPs cover each step in depth. This page is how they fit together.

```steps
Order Placed | The order arrives and the brief comes in. Confirm it is complete before any work starts.
Project Assigning | Hand the order to a designer with a complete brief and a clear deadline.
Project Delivery | The designer finishes, you quality-check, and the first design goes to the client for feedback.
Revision | The client sends changes. You read them, clarify anything unclear, and log them.
Revision Assigning | Hand the revision to the designer, quality-check the result, and send it back to the client.
Final Files | Once approved, prepare the final, correctly-named files in every format.
Final Delivery | Deliver on Fiverr with the Drive link and ZIP, mark it delivered, and close the order well.
```

## ClickUp status at each stage
Keep the task status moving so anyone can see where the order stands at a glance.

```keyvalue
Order placed | In Progress
Assigned to a designer | Assigned to Designer
First design shared | Pending Client Feedback
Revision in progress | Assigned to Designer
Revision sent | Revision Sent
Final files delivered | Delivered
```

## 1. Order Placed
The order lands on Fiverr and the buyer shares the brief. Nothing goes to a designer until the brief is complete.

**On Fiverr**
- Reply to the buyer within five minutes, even if it is just to say you are on it. See [SOP 02](/section/sop-02-query-5-min).
- Read the full profile and order history before you respond. See [SOP 01](/section/sop-01-profile-review).
- Confirm the brief is complete: size, file formats, brand colours, references, copy, and any special notes. If anything is missing, sort it out with the buyer first.

**On ClickUp**
- Create or open the task for this order.
- Set the status to **In Progress**.
- Add the client name, the order number, the deadline, and the brief.
- Leave a first remark with the order details. See [SOP 06](/section/sop-06-remarks).

## 2. Project Assigning
Hand the order to the right designer with everything they need.

**On Fiverr**
- Let the buyer know the work is underway and when to expect the first design.

**On ClickUp**
- Confirm the brief is complete before you assign. See [SOP 04](/section/sop-04-assign-designers).
- Assign the task to the designer, with the client name, order number, deadline, brief file, and any notes on what the client is particular about.
- Set the status to **Assigned to Designer** with the designer's name and the due date.
- Make sure the designer has seen and agreed to the deadline.
- Leave a remark noting who it went to and when it is due.

## 3. Project Delivery
The designer finishes, you check the work, and the first design goes to the client.

**On ClickUp**
- When the designer is done, run the full quality check before anything leaves. See [SOP 07](/section/sop-07-quality-check).
- Set the status to **Pending Client Feedback**.
- Leave a remark with what was shared and when.

**On Fiverr**
- Share the first design with the buyer in the order chat and ask for their feedback in one consolidated message.
- Never send a design you have not checked yourself.

## 4. Revision
The client sends changes. Treat a revision with the same care as a new order.

**On Fiverr**
- Read every point the buyer raised before you do anything. See [SOP 05](/section/sop-05-revisions).
- If a point is unclear, check with the buyer first. Never let a designer start on guesswork.

**On ClickUp**
- Log the revision: the revision number, the deadline, and a short line on what is changing.

## 5. Revision Assigning
Hand the revision to the designer, then check it and send it back.

**On ClickUp**
- Assign the revision to the designer with a clean, numbered list of exactly what is changing, and a deadline.
- Set the status to **Assigned to Designer** for the revision.
- When it comes back, quality-check that every single point the client raised is done. See [SOP 07](/section/sop-07-quality-check).
- Set the status to **Revision Sent** and leave a remark.

**On Fiverr**
- Send the revised design to the buyer and confirm the changes you made.
- Repeat stages 4 and 5 until the client approves, within the agreed revisions.

## 6. Final Files
Once the client approves, prepare the final package properly.

**On Fiverr**
- Get the buyer's clear approval before you prepare the final files.

**On ClickUp**
- Prepare every format the client asked for: PNG, PDF, AI, PSD, and so on.
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
- Set the status to **Delivered**.
- Leave a final remark with the date, the time, what you sent, and the Drive link.
- Include the delivery in your daily report. See [SOP 14](/section/sop-14-daily-report).

> **Rule:** Throughout every order, keep ClickUp updated at least once an hour, leave a remark on every change, and never let a task sit in the wrong status. See [SOP 03](/section/sop-03-clickup-updates).

> **Important:** A cancellation or an upset client goes to a Senior or your Manager straight away. Do not cancel, refund, or promise anything on your own. See [SOP 10](/section/sop-10-sensitive-cases) and [SOP 13](/section/sop-13-cancellations).
$BODY$,
  array['csr','asr','hr','pm','manager']::user_role[], false, 16
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;
