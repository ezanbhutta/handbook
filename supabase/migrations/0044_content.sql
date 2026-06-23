-- =============================================================================
-- HaseebMadeit Handbook — 0044 content (batch 36): five-part SOP shape, part 2
-- Restructure SOP 05-09 into the standard shape so the whole playbook reads the
-- same way and can be followed without questions:
--   Why it matters · Tools and access · Steps · If something goes wrong · Done right.
-- Wording is preserved where it was already good; corrections are folded in:
-- SOP 05 keeps the unlimited-revisions standard and the real status flow (designer
-- sets Revision Complete; CSR sets Client Response and moves it back to Revision);
-- SOP 06 keeps the good-vs-poor block (ClickUp set to Revision) and the escalation
-- example; SOP 07 wraps the existing quality checklist; SOP 08 uses the corrected
-- delivery process (ZIP by default, company Drive link only if needed, Final Files
-- then Complete); SOP 09 keeps the naming format and rules. Full re-upserts,
-- idempotent by slug.
-- =============================================================================

-- ===== SOP 05 ================================================================
insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='fiverr-ops'),
  'SOP 05: Revisions and Tracking Them', 'sop-05-revisions',
  $BODY$
## Why it matters
Treat a revision with the same care as a new order. Log it clearly, assign it fast, and follow it until it is done. A revision that slips through unchecked or untracked costs us the trust the rest of the order earned.

> **Standard:** Every package includes unlimited revisions. We keep refining until the client is genuinely happy. This is about quality and a lasting relationship, not the sale. A revision adjusts work we already agreed on. A brand new concept or a change of scope is a paid add on.

## Tools and access you need
```keyvalue
Fiverr | The order page, where the revision request comes in and the revised design goes back out.
ClickUp | The live status: you set Revision, the designer sets Revision Complete, you set Client Response.
Order Management Sheet | Where you log the revision number, the designer, the deadline, and what changed.
```

## Steps
```steps
Read every point first | Go through every point the client raised before you do anything else.
Clear up anything unclear | If a point is fuzzy, check with the client before the designer starts. Never let a designer work on guesswork.
Pass it to the designer | Send it straight away with a clean, numbered list of exactly what is changing, and set the status to Revision.
Let the designer finish | The designer makes the changes and sets the status to Revision Complete when they are done.
Quality-check every point | Go through the revised design yourself and confirm every single point is done. This is the full check in SOP 07.
Send it and update the status | Send the revised design on the order page, then set the status to Client Response.
Log the revision | Note the revision number, the designer, the deadline, and a short line on what changed in the Order Management Sheet.
Go round again if needed | If the client asks for more, move the status back to Revision and start the loop again.
```

## If something goes wrong
| If this happens | What to do |
| --- | --- |
| A revision point is unclear | Confirm it with the client before the designer starts. Never guess. |
| The client keeps asking for the same change | Check your remarks, confirm exactly what they want, and brief the designer again clearly. See [SOP 06](/section/sop-06-remarks). |
| The request is really a new concept or a change of scope | This is a paid add on, not a revision. Escalate before you promise anything. See [SOP 10](/section/sop-10-sensitive-cases). |

## Done right when
```checklist
Every point the client raised was read and confirmed before the designer started.
The revised design was checked by you before it left.
The revision is logged in the Order Management Sheet with the number, designer, deadline, and what changed.
The status is Client Response after delivery, or back to Revision if more changes are coming.
```

> **Rule:** Never send a revised design to a client before you have looked at it yourself and confirmed every change was made. See [SOP 07](/section/sop-07-quality-check).
$BODY$,
  array['csr','hr','pm','manager']::user_role[], false, 6
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

-- ===== SOP 06 ================================================================
insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='fiverr-ops'),
  'SOP 06: Remarks on Every Order', 'sop-06-remarks',
  $BODY$
## Why it matters
Every order carries a running set of remarks, so anyone, including a Senior, can understand the whole story by reading them alone. A good remark says what happened, who is involved, and what comes next, in one clear entry.

## Tools and access you need
```keyvalue
ClickUp | Where the remark goes, on every meaningful change to the order.
Order Management Sheet | The client record and the order details that back up what you write.
```

## Steps
```steps
Write on every change | Add a remark every time something meaningful happens, such as an assignment, a revision, a delivery, or client feedback.
Cover the three parts | Each remark says what happened, who is responsible, and the next step.
Keep it plain | Write in clear, simple English. No slang, short forms, or vague lines.
Tell the whole story | A Senior who has never touched this client should get the full picture from your remarks alone.
Note the time | Always record the time of important events, such as escalations, complaints, and deliveries.
```

## Good vs poor
```dodont
The client asked for 3 logo variations on a dark background. Brief shared with the designer. Deadline 28 June, 5:00 PM. Client prefers a minimalist style, noted in the brief. ClickUp updated. | Assigned to designer. Will update soon.
Revision received, 4 points: font to bold, darker background, remove the tagline, centre the logo. Assigned to the designer. Deadline 27 June, 3:00 PM. ClickUp set to Revision. | Client wants changes. Told designer.
```

## Real examples
Here is how to log a hard situation, so a Senior can pick it up cold.

> The client was strongly dissatisfied at 3:15 PM, saying the logo colours do not match what was discussed at onboarding. Their tone was very firm. Escalated to the Senior straight away. No promises made. Awaiting the Senior's direction before replying. ClickUp flagged as Escalated.

## If something goes wrong
| If this happens | What to do |
| --- | --- |
| You are not sure a change is worth a remark | Write it anyway. A short remark is always better than a gap in the story. |
| The situation is sensitive, such as a complaint or a cancellation | Log it with the time, promise nothing, and escalate. See [SOP 10](/section/sop-10-sensitive-cases). |
| An older remark turns out to be wrong | Do not delete it. Add a new remark that corrects the record and explains what changed. |

## Done right when
```checklist
Every meaningful change on the order has a remark.
Each remark says what happened, who is responsible, and the next step.
The times of escalations, complaints, and deliveries are recorded.
A Senior could read the remarks alone and understand the whole order.
```

> **Standard:** A Senior who has never touched this client should be able to read your remarks alone and know exactly where the order stands.
$BODY$,
  array['csr','hr','pm','manager']::user_role[], false, 7
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

-- ===== SOP 07 ================================================================
insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='fiverr-ops'),
  'SOP 07: Quality Check Before Delivery', 'sop-07-quality-check',
  $BODY$
## Why it matters
No design goes to a client, first draft or revision, until you have checked it yourself. This step is not optional. It is the last gate before our name is on the work.

## Tools and access you need
```keyvalue
Fiverr | The order page and the brief you are checking the work against.
The brief | What the client asked for, in style, colour, size, and format.
The deliverables | Every format and every colour variation, ready to check as a set.
```

## The checklist
```checklist
The design matches the brief in style, colour, size, and format.
Every bit of text is right. No spelling mistakes, no wrong names, no wrong numbers on the concepts.
The brand colours, fonts, and assets are what the client asked for. If not, send it back for a revision.
Every format is present: AI, EPS, SVG, PNG, JPEG, and PDF, with SVG and PDF both with and without a background.
Every colour variation is present: the full-colour version, the colour-background variations, and the monochrome black and white versions.
For a revision, every single point the client raised is done and checked by you.
The file name follows our naming convention.
The ZIP opens cleanly and holds the complete set.
A Drive link is included only if it is needed, and then it is from the company Drive, live and open. The client does not share a Drive.
No watermarks, guides, crop marks, or stray bits in the files you send.
The work looks professional, not rushed.
```

Naming follows [SOP 09](/section/sop-09-file-naming); the full set is the deliverables standard the designers work to.

## If something goes wrong
| If this happens | What to do |
| --- | --- |
| A format or a colour variation is missing | Send it back to the designer. The package is not ready until the full set is there. |
| The text or the brand assets are wrong | Send it back for a revision. Never fix it quietly and hope nobody notices. |
| The deadline is tight and the check is not done | The check still comes first. A late, correct delivery beats an early, wrong one. |

## Done right when
```checklist
Every item on the checklist passed before the file left.
The full set of formats and colour variations is confirmed present.
The check is logged in a remark so the team can see it was done.
```

> **Rule:** If even one of these fails, the file goes back to the designer before it leaves. No exceptions, not for a tight deadline, not for anything. The brand image is everything.
$BODY$,
  array['csr','hr','pm','manager']::user_role[], false, 8
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

-- ===== SOP 08 ================================================================
insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='fiverr-ops'),
  'SOP 08: Delivering to the Client', 'sop-08-delivery',
  $BODY$
## Why it matters
Delivery is the moment the client sees the most, so handle it with care and finish every detail. A clean delivery is what they remember, and what brings them back.

## Tools and access you need
```keyvalue
Fiverr | The order page, where you deliver the drafts and the finals.
Company Google Drive | The CSR uploads here and shares a link when one is needed. The client does not share a Drive.
ClickUp | Where you set Final Files, then Complete once the buyer accepts.
Order Management Sheet | The client record and the order details to update on delivery.
```

## Steps
```steps
Finish the quality check first | Never deliver before you have done the full quality check. Delivery always comes after. This is SOP 07.
Name the files | Follow the naming guide so nothing gets lost or mixed up. This is SOP 09.
Package as a ZIP | Gather every format and colour variation, and package it as a ZIP. This is the default delivery.
Share a Drive link only if needed | The client does not share a Drive, so the CSR uploads to the company Google Drive and shares that link.
Deliver on the order page | Send the delivery on the Fiverr order page with the standard message. Confirm what you are sending, attach the ZIP, and add the Drive link if you used one.
Set the status | Move it to Final Files, then Complete once the buyer accepts.
Leave a delivery remark | Note the date, the time, what went out, and any Drive link, for the record.
Update the sheet | Record the delivery against the order in the Order Management Sheet.
```

Quality check is [SOP 07](/section/sop-07-quality-check); naming is [SOP 09](/section/sop-09-file-naming).

## If something goes wrong
| If this happens | What to do |
| --- | --- |
| The ZIP is too large for the order page | Upload it to the company Google Drive and share that link. The client does not share a Drive. |
| The buyer says a file will not open | Point them to the Google Drive link; it is the same files in both places. |
| The buyer raises a problem after delivery | Treat it as a revision and log it. Do not deliver again until it passes the quality check. See [SOP 05](/section/sop-05-revisions). |

## Done right when
```checklist
The quality check passed before anything was sent.
The files are named the right way and packaged as a ZIP with the full set.
The delivery went out on the order page with the standard message.
The status is Final Files, then Complete once the buyer accepts.
A delivery remark is logged and the Order Management Sheet is updated.
```

> **Standard:** Every delivery includes the ZIP. When a Drive link is needed, it is from the company Google Drive, shared by the CSR, and the message adds this line: "If the ZIP file does not open, please use the Google Drive link, it is the same in both places."
$BODY$,
  array['csr','hr','pm','manager']::user_role[], false, 9
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

-- ===== SOP 09 ================================================================
insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='fiverr-ops'),
  'SOP 09: Naming Your Files', 'sop-09-file-naming',
  $BODY$
## Why it matters
Naming files the same way every time keeps things from getting lost or mixed up. Every file you send or store follows this, so anyone can find the right version at a glance.

## Tools and access you need
```keyvalue
The naming format | One consistent pattern, used on every file.
Company Google Drive | Where final source files are stored, named the same way.
```

## The format
```
ClientName_ProjectName_ProfileExtension_Date.ext
```
Final file the client has approved, for example: `SampleClient_LogoPack_AH2_25Jun2026.png`

## Steps
```steps
Use the pattern every time | Name the file ClientName_ProjectName_ProfileExtension_Date.ext, with no exceptions.
Use underscores, not spaces | Join the parts with underscores so the name stays clean across systems.
Write the date the set way | Use the form 25Jun2026 so dates sort and read the same way every time.
Add the version on revisions | Put v1, v2, v3, and so on in the name, and never write over an old version.
Match the extension to the file | The extension always matches the real file type of what you are saving.
```

## The rules
```checklist
No spaces in a file name. Use underscores instead.
For revisions, put the version in: v1, v2, v3, and so on.
Write the date like 25Jun2026.
The extension always matches the real file type.
Never write over an old version. Make a new file with the next version number.
```

## If something goes wrong
| If this happens | What to do |
| --- | --- |
| You are about to overwrite an old version | Stop. Save a new file with the next version number instead. |
| A file name has spaces or odd characters | Rename it to the pattern before you send or store it. |
| You are unsure which version is the latest | Check the version number and the date in the name, and confirm against the Order Management Sheet. |

## Done right when
```checklist
Every file follows the ClientName_ProjectName_ProfileExtension_Date.ext pattern.
There are no spaces in any file name.
Revisions carry a version number, and no old version was overwritten.
The date and the extension are correct on every file.
```

> **Tip:** A file named the right way is one nobody has to hunt for. Name it correctly the first time and the whole order stays tidy.
$BODY$,
  array['csr','hr','pm','manager']::user_role[], false, 10
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;
