-- =============================================================================
-- HaseebMadeit Handbook — 0042 content (batch 34): order lifecycle as a complete SOP
-- Rebuild the order-lifecycle section so it can be followed end to end without a
-- single question: why it matters, the tools and access you need, numbered steps
-- (with Fiverr / ClickUp / Order Management Sheet actions and the exact status to
-- set), what to do if something goes wrong, and a completion checklist. Carries
-- every prior correction forward verbatim (real statuses and ownership, drafts on
-- the order page, monthly designers, client name in the Order Management Sheet,
-- all formats + colour variations, ZIP default with company Drive only if needed).
-- Full re-upsert of the order-lifecycle section, idempotent by slug.
-- =============================================================================

insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='fiverr-ops'),
  'The Order Lifecycle: From Placed to Completed', 'order-lifecycle',
  $BODY$
This is the whole journey of an order, start to finish: what to do on Fiverr, in ClickUp, and in the Order Management Sheet at every stage, including the exact ClickUp status to set. Follow it top to bottom and you will never need to ask what comes next.

## Why this matters
Every order runs the same way so that nothing slips, the client always knows where things stand, and the work that leaves us looks professional every time. Following these steps protects three things at once: the client relationship, the review at the end, and your own accountability.

> **Note:** ClickUp and the Order Management Sheet are the shared record. If a step is not logged, as far as the team is concerned it did not happen.

## Tools and access you need
Have all of these open before you start.

```keyvalue
Fiverr | Read the brief and order history, message the buyer, and deliver on the order page.
ClickUp | Create the task and move it through the statuses. The live workflow lives here.
Order Management Sheet | Our shared Google Sheet. Log the client name and every order detail here, never on ClickUp.
Company Google Drive | Share a Drive link from here when one is needed. The client does not share a Drive.
WhatsApp or your team channel | Reach the designer, a Senior, or the Manager fast.
The client brief | The full instructions: size, formats, colours, references, and copy.
```

## The journey at a glance
```steps
Order Placed | The order arrives and the brief comes in. Confirm it is complete before any work starts.
Project Assigning | Put the task in the pickup queue and hand it to a designer with a complete brief and a clear deadline.
Project Delivery | The designer finishes, you quality-check, and the first design goes to the client.
Revision | The client sends changes. You read them, clarify anything unclear, and log them.
Revision Assigning | Hand the revision to the designer, quality-check the result, and send it back to the client.
Final Files | Once approved, prepare the final, correctly-named files in every format and colour variation.
Final Delivery | Deliver on Fiverr as a ZIP, mark the order Complete, update the sheet, and close it well.
```

## ClickUp status at each stage
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

> **Note:** If an order is ever cancelled, the task goes to **Cancelled** in ClickUp. Never do that on your own, see "If something goes wrong" below.

## The steps, in order

### 1. Order Placed
The order lands on Fiverr and the buyer shares the brief. Nothing goes to a designer until the brief is complete.

**On Fiverr**
- Reply to the buyer within five minutes, even if it is just to say you are on it. See [SOP 02](/section/sop-02-query-5-min).
- Read the full profile and order history before you respond. See [SOP 01](/section/sop-01-profile-review).
- Confirm the brief is complete: size, file formats, brand colours, references, copy, and any special notes. If anything is missing, sort it out with the buyer first.

**On ClickUp**
- Create the task for this order. Name it for the project, not the client.
- Set the status to **Pickup Your Projects** so a designer can pick it up.
- Add the order number, the deadline, and the brief. The client name and the order details go in our Order Management Sheet, not on ClickUp.
- Leave a first remark with the order details. See [SOP 06](/section/sop-06-remarks).

**In the Order Management Sheet**
- Log the order: the date, the client name, the project name, the order type, the CSR, and the order amount.

### 2. Project Assigning
Hand the order to the right designer with everything they need.

**On Fiverr**
- Let the buyer know the work is underway and when to expect the first design.

**On ClickUp**
- Confirm the brief is complete before you assign. See [SOP 04](/section/sop-04-assign-designers).
- Add the designer as the assignee, with the order number, deadline, brief file, and any notes on what the client is particular about.
- Leave the task in **Pickup Your Projects**. The designer moves it to **In Progress** when they start working.
- Our designers are on monthly contracts with fixed daily projects, delivered inside their shift, so the work is already committed. You do not need to chase a per-task agreement.
- Leave a remark noting who it went to and when it is due.

**In the Order Management Sheet**
- Record the assigned designer against the order.

### 3. Project Delivery
The designer finishes, you check the work, and the first design goes to the client.

**On ClickUp**
- When the designer is done, they set the status to **Deliver to Client**.
- Run the full quality check before anything leaves. See [SOP 07](/section/sop-07-quality-check).
- Once you have delivered the initial draft on the order page, set the status to **Client Response** while you wait for their feedback.
- Leave a remark with what was shared and when.

**On Fiverr**
- Deliver the initial draft on the order page, then ask the buyer for their feedback in one consolidated message.
- Never send a design you have not checked yourself.

### 4. Revision
The client sends changes. Treat a revision with the same care as a new order.

**On Fiverr**
- Read every point the buyer raised before you do anything. See [SOP 05](/section/sop-05-revisions).
- If a point is unclear, check with the buyer first. Never let a designer start on guesswork.

**On ClickUp**
- Set the status to **Revision** and log it: the revision number, the deadline, and a short line on what is changing.

### 5. Revision Assigning
Hand the revision to the designer, then check it and send it back.

**On ClickUp**
- Assign the revision to the designer with a clean, numbered list of exactly what is changing, and a deadline. The task stays in **Revision** while they work.
- When the designer finishes, they set the status to **Revision Complete**.
- Quality-check that every single point the client raised is done. See [SOP 07](/section/sop-07-quality-check).
- Send the revised design to the buyer, then set the status to **Client Response** and leave a remark.
- If the client asks for more changes, move it back to **Revision** and repeat, within the agreed revisions.

**On Fiverr**
- Send the revised design to the buyer and confirm the changes you made.

### 6. Final Files
Once the client approves, prepare the final package properly.

**On Fiverr**
- Get the buyer's clear approval before you prepare the final files.

**On ClickUp**
- Set the status to **Final Files**.
- Include every format: AI, EPS, SVG, PNG, JPEG, and PDF, with SVG and PDF both with and without a background.
- Include every colour variation too: the full-colour version, the colour-background variations, and the monochrome (black and white) versions.
- Name every file the right way. See [SOP 09](/section/sop-09-file-naming).
- Package everything into a ZIP to share with the client. The client does not give us a Drive of their own.
- If the files need to sit on a Drive, the CSR uploads them to the company Google Drive and shares that link with the client.
- Leave a remark that the final files are ready.

### 7. Final Delivery
Deliver the final work, mark it done, update the sheet, and close the order well.

**On Fiverr**
- Deliver the order with all the final files as a ZIP. If a Drive link is needed, the CSR shares it from the company Google Drive, not from the client.
- Use the standard delivery message. When you include a Drive link, add this line: "If the ZIP file does not open, please use the Google Drive link, it is the same in both places." See [SOP 08](/section/sop-08-delivery).
- Once the buyer accepts, the order is marked complete. Thank them warmly and invite them back, with no pushy review ask. See [SOP 12](/section/sop-12-client-relationships).

**On ClickUp**
- Once the buyer accepts, set the status to **Complete**.
- Leave a final remark with the date, the time, what you sent, and any Drive link.
- Include the delivery in your daily report. See [SOP 14](/section/sop-14-daily-report).

**In the Order Management Sheet**
- Set the Status to Completed and fill the DOC with the date of completion. Add any tip, and the review once the client leaves one.

## If something goes wrong
Do not improvise on the things that affect the client or the money. Use this table.

| If this happens | What to do |
| --- | --- |
| The brief is incomplete or unclear | Stop. Get the missing details from the buyer before you assign. Never let a designer start on guesswork. |
| The designer is late or goes quiet | Tell the Project Manager straight away, on any channel. Do not let a deadline slip in silence. |
| The client's feedback is unclear | Ask the buyer to clarify before you assign the revision. |
| The client is upset or angry | Do not argue or promise anything. Escalate to a Senior or the Manager at once and log it. See [SOP 10](/section/sop-10-sensitive-cases). |
| The client asks to cancel | Do not cancel, refund, or agree to anything yourself. Escalate, and the task goes to **Cancelled**. See [SOP 13](/section/sop-13-cancellations). |
| The ZIP will not open for the client | Share the files from the company Google Drive and send that link. |
| You are going to miss the deadline | Flag it early to the Project Manager. A silent delay is the worst outcome. |

## Completion checklist
The order is done only when every one of these is true.

```checklist
The initial draft and every revision were quality-checked before they were sent. See SOP 07.
The final files went out on the order page as a ZIP, with every format and every colour variation.
A company Drive link was shared if one was needed.
ClickUp is set to Complete, with a final remark: date, time, and what was sent.
The Order Management Sheet row is done: Status Completed, DOC filled, amount, designer, and any tip.
The client was thanked, with no pushy review ask.
The delivery is recorded in your daily report. See SOP 14.
```

> **Rule:** Throughout every order, keep ClickUp updated at least once an hour, leave a remark on every change, and never let a task sit in the wrong status. See [SOP 03](/section/sop-03-clickup-updates).
$BODY$,
  array['csr','asr','hr','pm','manager']::user_role[], false, 16
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;
