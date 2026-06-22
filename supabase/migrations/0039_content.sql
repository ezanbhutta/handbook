-- =============================================================================
-- HaseebMadeit Handbook — 0039 content (batch 31)
-- Three things, all targeted and idempotent replace() updates scoped by slug:
--   msg 9  Final files include EVERY format AND every colour variation
--          (colour-background variations and monochrome black-and-white versions).
--   msg 10 Clients do not share a Drive. Default delivery is a ZIP; if a Drive
--          link is needed the CSR uploads to the COMPANY Google Drive and shares
--          that link. Removes all "client's Google Drive" wording.
--   Q2     Align the remaining SOPs to the real ClickUp statuses
--          (Pickup Your Projects, In Progress, Deliver to Client, Client Response,
--          Revision, Revision Complete, Final Files, Complete, Cancelled).
-- Dollar-quoted literals ($o$ old, $n$ new) so apostrophes/quotes need no escaping.
-- =============================================================================

-- ---- order-lifecycle: Final Files now lists all formats + colour variations (msg 9)
update sections set body = replace(body,
$o$- Prepare every format the client asked for — AI, EPS, SVG, PNG, JPEG, and PDF — including the with-background and without-background versions of SVG and PDF.$o$,
$n$- Include every format: AI, EPS, SVG, PNG, JPEG, and PDF, with SVG and PDF both with and without a background.
- Include every colour variation too: the full-colour version, the colour-background variations, and the monochrome (black and white) versions.$n$)
where slug = 'order-lifecycle';

-- ---- order-lifecycle: Final Files delivery is a ZIP; company Drive only if needed (msg 10)
update sections set body = replace(body,
$o$- Upload the open files to the client's Google Drive folder, set so they can open it. Do not upload the ZIP itself to the Drive.$o$,
$n$- Package everything into a ZIP to share with the client. The client does not give us a Drive of their own.
- If the files need to sit on a Drive, the CSR uploads them to the company Google Drive and shares that link with the client.$n$)
where slug = 'order-lifecycle';

-- ---- order-lifecycle: Stage 7 delivery line, ZIP first, company Drive if needed (msg 10)
update sections set body = replace(body,
$o$- Deliver the order with the final files, the Google Drive link, and the ZIP.$o$,
$n$- Deliver the order with all the final files as a ZIP. If a Drive link is needed, the CSR shares it from the company Google Drive, not from the client.$n$)
where slug = 'order-lifecycle';

-- ---- order-lifecycle: make the ZIP/Drive message line conditional on a Drive link (msg 10)
update sections set body = replace(body,
$o$- Use the standard delivery message and include this line: "If the ZIP file does not open, please use the Google Drive link, it is the same in both places." See [SOP 08](/section/sop-08-delivery).$o$,
$n$- Use the standard delivery message. When you include a Drive link, add this line: "If the ZIP file does not open, please use the Google Drive link, it is the same in both places." See [SOP 08](/section/sop-08-delivery).$n$)
where slug = 'order-lifecycle';

-- ---- clickup-basics: replace the status labels with the real board (Q2)
update sections set body = replace(body,
$o$- **In Progress.** You are actively working on it.
- **Assigned to Designer.** Handed off, with the designer and the deadline.
- **Pending Client Feedback.** Waiting on the client.
- **Revision Sent.** A revision has gone out and you are waiting to hear back.
- **Delivered.** The final work is done.$o$,
$n$- **Pickup Your Projects.** The order is queued for a designer to pick up.
- **In Progress.** The designer is actively working on it.
- **Deliver to Client.** The work is ready to go to the client.
- **Client Response.** Waiting on the client to respond.
- **Revision.** The client asked for changes and the designer is working on them.
- **Revision Complete.** The designer has finished the changes.
- **Final Files.** The client approved and the final files are going out.
- **Complete.** The order is finished.
- **Cancelled.** The order was cancelled. Escalate first, never cancel on your own.$n$)
where slug = 'clickup-basics';

-- ---- sop-03: inline status list (Q2)
update sections set body = replace(body,
$o$Use the right status | Pick the correct label, like In Progress, Pending Client Feedback, Assigned to Designer, Revision Sent, or Delivered.$o$,
$n$Use the right status | Pick the correct label: Pickup Your Projects, In Progress, Deliver to Client, Client Response, Revision, Revision Complete, Final Files, Complete, or Cancelled.$n$)
where slug = 'sop-03-clickup-updates';

-- ---- sop-04: assigning a designer, real status flow (Q2)
update sections set body = replace(body,
$o$Put it in ClickUp | Move the status to Assigned to Designer with the designer's name and the deadline.$o$,
$n$Put it in ClickUp | Add the designer as the assignee and leave it in Pickup Your Projects. The designer sets In Progress when they start.$n$)
where slug = 'sop-04-assign-designers';

-- ---- sop-06: remark example uses the real status (Q2)
update sections set body = replace(body,
$o$ClickUp set to Revision In Progress.$o$,
$n$ClickUp set to Revision.$n$)
where slug = 'sop-06-remarks';

-- ---- sop-08: delivery steps and standard, ZIP/company-drive (msg 10) + statuses (Q2)
update sections set body = replace(body,
$o$Prepare the package | Organise everything into a clear folder, with all the formats, the Drive link, and a ZIP if it suits.$o$,
$n$Prepare the package | Gather every format and colour variation, packaged as a ZIP. Add a Drive link only if one is needed.$n$)
where slug = 'sop-08-delivery';

update sections set body = replace(body,
$o$Upload to Google Drive | Use the client's folder and set the sharing so they can open it without any trouble.$o$,
$n$Share a Drive link only if needed | The client does not share a Drive, so the CSR uploads to the company Google Drive and shares that link with the client.$n$)
where slug = 'sop-08-delivery';

update sections set body = replace(body,
$o$Send the delivery message | Keep it professional and on brand. Confirm what you are sending, add the Drive link and the ZIP, and let them know the Drive link works if the ZIP does not open.$o$,
$n$Send the delivery message | Keep it professional and on brand. Confirm what you are sending, attach the ZIP, add a Drive link if you used one, and let them know the Drive link works if the ZIP does not open.$n$)
where slug = 'sop-08-delivery';

update sections set body = replace(body,
$o$Update ClickUp | Move it to Delivered and leave a remark with the date and what went out.$o$,
$n$Update ClickUp | Move it to Final Files, then Complete once the buyer accepts, and leave a remark with the date and what went out.$n$)
where slug = 'sop-08-delivery';

update sections set body = replace(body,
$o$Add a delivery remark | Note the date, the time, what you sent, and the Drive link for the record.$o$,
$n$Add a delivery remark | Note the date, the time, what you sent, and any Drive link, for the record.$n$)
where slug = 'sop-08-delivery';

update sections set body = replace(body,
$o$> **Standard:** Every delivery message includes the Google Drive link and the ZIP, with this line: "If the ZIP file does not open, please use the Google Drive link, it is the same in both places."$o$,
$n$> **Standard:** Every delivery includes the ZIP. When a Drive link is needed, it is from the company Google Drive, shared by the CSR, and the message adds this line: "If the ZIP file does not open, please use the Google Drive link, it is the same in both places."$n$)
where slug = 'sop-08-delivery';

-- ---- order-lifecycle: client name and order details live in the Order Management Sheet (msg 11)
update sections set body = replace(body,
$o$- Add the order number, the deadline, and the brief. We do not put the client's name on ClickUp.$o$,
$n$- Add the order number, the deadline, and the brief. The client name and the order details go in our Order Management Sheet, not on ClickUp.$n$)
where slug = 'order-lifecycle';

-- ---- clickup-basics: name the Order Management Sheet where it was just "the sheet" (msg 11)
update sections set body = replace(body,
$o$Match the incoming order numbers against the sheet and ClickUp.$o$,
$n$Match the incoming order numbers against the Order Management Sheet and ClickUp.$n$)
where slug = 'clickup-basics';
