-- =============================================================================
-- HaseebMadeIt Handbook — 0007 content (batch 1)
-- Sourced from: Company Hierarchy & JDs, CSR SOPs, Quarterly Bonus Policy.
-- Reformatted for scannability (action-first steps, callouts, cross-links) and
-- enriched with "In short" summaries + helping points.
--
-- Visibility model:
--   "Everyone"  = all six roles (welcome, company/org).
--   CSR content = csr + hr + pm + manager. CSR and ASR are SEPARATE roles, so
--                 ASR is not included here — it gets its own content later.
--   Manager has full data access (it appears in every section's allowed_roles).
-- Idempotent: re-running upserts each section by slug (edit + re-run to update).
-- =============================================================================

-- ===== CHAPTER 1 · Welcome & Company ========================================

insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='welcome'),
  'Welcome to HaseebMadeit', 'welcome-to-haseebmadeit',
  $BODY$
**In short:** We are a design & branding agency based in Multan, Pakistan. Our reputation is built on quality work and a great client experience — and every role here protects that.

## Who we are
HaseebMadeit is a design & branding agency. Most of our orders come through online platforms (like Fiverr), and our teams work across three shifts to keep clients supported around the clock.

## What this handbook is
This is the **single source of truth** for how we work. Whenever you're unsure how to do something, search here first. It's always up to date — when a rule changes, you'll see it in **[What's New](/whats-new)**.

> **Our standard:** The brand image is everything, and the experience is what matters. Whatever your role, the goal is the same — protect the client experience and the company's name.

**New here? Start with these:**
- [Company Hierarchy & Shifts](/section/company-hierarchy) — who's who and who to ask.
- Your role page under **Your Role**.
- If you're a CSR: the [CSR Playbook](/section/csr-playbook-start-here).
$BODY$,
  array['csr','asr','hr','pm','manager','office_boy']::user_role[], true, 1
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='welcome'),
  'Company Hierarchy & Shifts', 'company-hierarchy',
  $BODY$
**In short:** We run three shifts. Each shift has a **Team Leader** you report to, and a CSR team. When something is outside your scope, your Team Leader / Senior is your first contact.

## Shifts & Team Leaders
| Shift | Team Leader(s) |
| --- | --- |
| Morning | Ezan |
| Evening | Zubair, Ezan |
| Night | Zubair |

## Who reports to whom
- **CEO & Founder** — Abdul Haseeb. Final approvals, scores, and major decisions.
- **Team Leaders / Seniors** — run each shift, handle escalations, cancellations, and coaching.
- **Project Manager** — coordinates designers and order flow (see [PM role](/section/role-pm)).
- **CSRs** — own client communication and order management (see [CSR role](/section/role-csr)).

## Current CSR team (by shift)
| Morning | Evening | Night |
| --- | --- | --- |
| Iqra Qaiser | Abdul Basit | Salman Malik |
| Tanzeel Bibi | Tayyab | Ahmed Bibrash |
| Hassan Mehdi | Husnain Gillani | Swaid Khan |
| Amrah Shoaib | Abdul Hadi | Saad Khan |
|  | Ali Shakeel | Nadir Ali |
|  |  | Samama |

> **Helping point:** Not sure who to ask? Always go to your **shift Team Leader / Senior** first. They'll escalate to the PM or CEO if needed. This roster is kept current by HR / Seniors.
$BODY$,
  array['csr','asr','hr','pm','manager','office_boy']::user_role[], true, 2
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

-- ===== CHAPTER 4 · Your Role ================================================

insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='your-role'),
  'CSR — Role & Responsibilities', 'role-csr',
  $BODY$
**In short:** As a CSR you own the client relationship and the order from first message to final delivery. Speed, accuracy, and care are your job. This page is the overview — the **how-to** lives in the [CSR Playbook](/section/csr-playbook-start-here).

## What a CSR is responsible for
- Treat every client profile as a unique case — review it order by order and deliver the best possible experience.
- **Respond to new queries within 5 minutes** ([SOP 02](/section/sop-02-query-5-min)).
- Keep **ClickUp** updated hourly — it's our single source of truth ([SOP 03](/section/sop-03-clickup-updates)).
- Assign orders and revisions to designers on time, with a complete brief ([SOP 04](/section/sop-04-assign-designers), [SOP 05](/section/sop-05-revisions)).
- Write clear remarks on every order so anyone can pick it up ([SOP 06](/section/sop-06-remarks)).
- **Quality-check every delivery** before it reaches the client ([SOP 07](/section/sop-07-quality-check)).
- Name and deliver files correctly — Google Drive link **and** ZIP ([SOP 08](/section/sop-08-delivery), [SOP 09](/section/sop-09-file-naming)).
- Escalate sensitive cases, cancellations, and frustrated clients to a Senior immediately ([SOP 10](/section/sop-10-sensitive-cases), [SOP 13](/section/sop-13-cancellations)).
- Build long-term relationships — **always help, never beg for a sale** ([SOP 11](/section/sop-11-upselling), [SOP 12](/section/sop-12-client-relationships)).
- Submit your Daily Activity Report every shift ([SOP 14](/section/sop-14-daily-report)).

> **Rule:** If something is confusing or sensitive, discuss it with a Senior. Never tackle a difficult case alone.
$BODY$,
  array['csr','hr','pm','manager']::user_role[], true, 1
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='your-role'),
  'Senior CSR — Role & Responsibilities', 'role-senior-csr',
  $BODY$
**In short:** A Senior CSR runs the team's day-to-day: monitors the environment, coaches CSRs, handles cancellations and retention, and reports to the CEO.

## Core responsibilities
- Monitor the team daily — punctuality, breaks, dress code, engagement, and performance.
- Review all team cases daily; be available for questions, then delegate sales, negotiation, and relationship tasks.
- Cross-check incoming order numbers against the sheet **and** ClickUp assignments.
- Coach each CSR to their strengths; run training/skill exercises when workload allows.
- **Handle all profile cancellations** with strategy — meetings, discounts, tailored negotiation ([SOP 13](/section/sop-13-cancellations)).
- Track query and order patterns (volume, timing) and act on growth opportunities.
- Set weekly performance benchmarks and hold the team accountable.
- Engage with **HR** every 2–3 days on team issues and hiring (profiling ideal candidates).
- Run competitor research and drive platform diversification beyond Fiverr.
- Submit a structured **daily team report to the CEO**, and flag all major/minor issues same-day.

> **Helping point:** Seniors score CSRs each quarter on observable evidence — see the [Quarterly Bonus Policy](/section/quarterly-bonus-policy). Give monthly feedback so the quarterly review holds no surprises.
$BODY$,
  array['csr','hr','pm','manager']::user_role[], false, 2
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='your-role'),
  'Project Manager — Role & Responsibilities', 'role-pm',
  $BODY$
**In short:** The PM keeps work flowing between CSRs and designers — daily check-ins, ClickUp hygiene, brief allocation, and reporting to the CEO.

## Core responsibilities
- Run **daily check-ins**; follow up on the previous day's tasks and updates.
- Gather designer updates daily; ensure tasks are assigned or reviewed.
- Maintain the **progress sheet** daily; prepare and submit reports to the CEO.
- Submit **weekly reports** with notes and reasoning for each team member.
- Coordinate with the CSR team on organic order assignments to designers.
- Keep **ClickUp clear** day-to-day so no one is blocked on organic or in-organic orders.
- Allocate briefs and assign practice/"fake" projects when CSRs confirm no organic orders remain.
- Run **onboarding** for new designers (ClickUp, infrastructure, work culture, policies).
- Attend meetings, resolve problems, and follow through. If something is outside your control, contact the CEO on priority.
- Surface team-wide problems and bring solutions to the CEO meeting.

> **Helping point:** The PM is the bridge between sales (CSRs) and production (designers). When in doubt, protect the **delivery deadline** and the **brief quality** — both directly affect the client experience.
$BODY$,
  array['csr','hr','pm','manager']::user_role[], false, 3
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

-- ===== CHAPTER 5 · Fiverr Operations Playbook (CSR SOPs) ====================

insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='fiverr-ops'),
  'CSR Playbook — Start Here', 'csr-playbook-start-here',
  $BODY$
**In short:** These are the Standard Operating Procedures (SOPs) for Customer Support Representatives. Every CSR is expected to know and follow them at all times.

> **Important:** Failure to follow these SOPs may result in formal disciplinary action. **When in doubt, consult your Senior immediately** rather than proceeding on your own.

## The 14 SOPs
1. [Client Profile Review & Order Management](/section/sop-01-profile-review)
2. [Query Response — the 5-Minute Rule](/section/sop-02-query-5-min)
3. [ClickUp Updates — Hourly Logging](/section/sop-03-clickup-updates)
4. [Task & Order Assignment to Designers](/section/sop-04-assign-designers)
5. [Revision Assignment & Status Tracking](/section/sop-05-revisions)
6. [Remarks & Reporting on Every Order](/section/sop-06-remarks)
7. [Quality Check Before Delivery](/section/sop-07-quality-check)
8. [Client Delivery Procedure](/section/sop-08-delivery)
9. [File Naming Convention](/section/sop-09-file-naming)
10. [Handling Sensitive or Confusing Cases](/section/sop-10-sensitive-cases)
11. [Upselling & Cross-Selling](/section/sop-11-upselling)
12. [Client Relationship Management](/section/sop-12-client-relationships)
13. [Cancellation & Frustrated-Client Protocol](/section/sop-13-cancellations)
14. [Daily Activity Report](/section/sop-14-daily-report)

> **Helping point:** The three rules that protect us most: **5-minute replies**, **everything in ClickUp**, and **QC before every delivery**.
$BODY$,
  array['csr','hr','pm','manager']::user_role[], true, 1
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='fiverr-ops'),
  'SOP 01 — Client Profile Review & Order Management', 'sop-01-profile-review',
  $BODY$
**In short:** Before you respond to a client or touch an order, fully review the profile and history. Every client is a unique case.

## Steps
1. **Open the client profile** — review order history, previous remarks, design briefs, and any senior notes before any communication.
2. **Read all remarks** — understand the client's preferences, past issues, and the status of every active order.
3. **Review active orders** — confirm each order's stage (brief received, in design, revision, delivery pending, delivered).
4. **Identify priorities** — flag what's urgent, near deadline, stalled, or overdue for escalation.
5. **Verify the brief** — make sure it's complete and clear. If anything is missing, clarify with the client *before* assigning to a designer.

> **Rule:** Never assume a client's requirements. Always verify the brief is complete before assigning any work.

**Helping point:** A two-minute profile read prevents most mistakes — wrong style, missed revision, repeated questions. Start every interaction here.
$BODY$,
  array['csr','hr','pm','manager']::user_role[], false, 2
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='fiverr-ops'),
  'SOP 02 — Query Response: the 5-Minute Rule', 'sop-02-query-5-min',
  $BODY$
**In short:** Every new client query gets an acknowledgment within **5 minutes** — no exceptions.

## Steps
1. **Monitor all channels** — email, chat, ClickUp, and any assigned channels throughout your shift.
2. **Acknowledge within 5 minutes** — even if you don't have the full answer yet, let the client know you're reviewing their case.
3. **Gather information** — pull the profile and order details; understand the full context before responding substantively.
4. **Respond professionally** — clear, polite, brand-appropriate language at all times.
5. **Log the interaction** — add a concise remark so any teammate can see the status at a glance.

> **Important:** Delayed responses reflect directly on our professionalism. Busy with another task? Still send a brief acknowledgment within 5 minutes, then follow up as soon as you can.

**Helping point:** Keep 2–3 polite holding messages ready (e.g., "Thanks for your message — I'm reviewing your case and will update you shortly.") so you never miss the 5-minute mark.
$BODY$,
  array['csr','hr','pm','manager']::user_role[], false, 3
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='fiverr-ops'),
  'SOP 03 — ClickUp Updates: Hourly Logging', 'sop-03-clickup-updates',
  $BODY$
**In short:** ClickUp is our single source of truth. Keep it updated at all times so Seniors, PMs, and teammates always have accurate, real-time information.

## Steps
1. **Update hourly** — log into ClickUp at least once an hour and update every task you're managing. Don't wait until end of shift.
2. **Update before new tasks** — never carry a backlog of unlogged updates.
3. **Update before desk breaks** — no gaps when you step away.
4. **Use accurate status labels** — e.g., *In Progress, Pending Client Feedback, Assigned to Designer, Revision Sent, Delivered*. Never leave a task in the wrong status.
5. **Add remarks** — each update explains what happened and the next action. Entries without context are not acceptable.

> **Rule:** If it's not in ClickUp, it didn't happen. A task that isn't logged can't be tracked, managed, or supported by your team.

**Helping point:** See [Tools → ClickUp basics](/section/clickup-basics) for the status labels we use.
$BODY$,
  array['csr','hr','pm','manager']::user_role[], false, 4
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='fiverr-ops'),
  'SOP 04 — Task & Order Assignment to Designers', 'sop-04-assign-designers',
  $BODY$
**In short:** Assigning work well is one of your most critical jobs. A poor or late brief directly hurts delivery quality and client satisfaction.

## Steps
1. **Verify brief completeness** — dimensions, file formats, brand colors, style references, copy/text, and special instructions all present.
2. **Assign promptly** — as soon as the brief is confirmed. Don't hold assignments for unnecessary confirmations.
3. **Provide full context** — client name, order ID, deadline, brief file, and any client preferences or sensitivities.
4. **Set a clear deadline** — and confirm the designer has acknowledged and accepted it.
5. **Log in ClickUp** — status to *Assigned to Designer* with the designer's name and deadline.
6. **Before leaving the desk** — cross-check that every pending order is assigned. Nothing left unassigned when you step away.

> **Rule:** Never assign an incomplete brief. It wastes the designer's time, delays delivery, and damages the client relationship.

**Helping point:** A 30-second brief checklist (size · format · colors · references · copy · deadline) prevents most back-and-forth.
$BODY$,
  array['csr','hr','pm','manager']::user_role[], false, 5
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='fiverr-ops'),
  'SOP 05 — Revision Assignment & Status Tracking', 'sop-05-revisions',
  $BODY$
**In short:** Treat revisions with the same urgency and precision as new orders. Log clearly, assign promptly, track to completion.

## Steps
1. **Receive & review the revision** — read it thoroughly; understand every point before acting.
2. **Clarify if needed** — if anything is unclear, confirm with the client before assigning. Never let a designer work on unclear instructions.
3. **Assign to the designer** — immediately, with a clear, itemized list of all requested changes (bullets or numbers).
4. **Set a deadline** — aligned with the client's expectations and project timeline; confirm the designer acknowledges it.
5. **Update the status sheet** — revision number, designer, deadline, and a short summary of what's being revised.
6. **Monitor progress** — check in before the deadline; escalate to a Senior if there are blockers.

> **Rule:** Never deliver a revised design before reviewing it yourself and confirming every requested change is addressed (see [SOP 07](/section/sop-07-quality-check)).
$BODY$,
  array['csr','hr','pm','manager']::user_role[], false, 6
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='fiverr-ops'),
  'SOP 06 — Remarks & Reporting on Every Order', 'sop-06-remarks',
  $BODY$
**In short:** Every order needs a running log of remarks so any teammate — including a Senior who's never seen the client — can understand the full history by reading the remarks alone.

## What a good remark looks like
| ✓ Good | ✗ Poor |
| --- | --- |
| "Client requested 3 logo variations on a dark background. Brief shared with Ali (designer). Deadline 28 June 5pm. Client prefers minimalist style — noted in brief." | "Assigned to designer. Will update soon." |

## Rules for remarks
- Add a remark every time something meaningful happens (assignment, revision received, delivery sent, client feedback).
- Each remark says: **what happened**, **who's responsible**, and **the next step**.
- Write in clear, professional English — no slang, abbreviations, or vague entries.
- A Senior who's never worked the client should get the complete picture from the remarks.
$BODY$,
  array['csr','hr','pm','manager']::user_role[], false, 7
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='fiverr-ops'),
  'SOP 07 — Quality Check Before Delivery', 'sop-07-quality-check',
  $BODY$
**In short:** No design — first delivery or revision — goes to a client until you've completed this quality review. Non-negotiable.

## Quality review checklist
1. Design matches the brief in **style, color, dimensions, and format**.
2. All text is correct — no spelling errors, wrong names, wrong info, or mis-numbered concepts.
3. Brand colors, fonts, and assets match what the client specified (if not, reassign the revision).
4. File is exported in the correct format(s) requested (PNG, PDF, AI, PSD, …).
5. For revisions: **every** requested point is addressed and checked by you.
6. File name follows our convention ([SOP 09](/section/sop-09-file-naming)).
7. Google Drive link is active, unrestricted, accessible, and organized.
8. ZIP (if used) is properly compressed and opens without errors. Deliver **both** the Drive link and ZIP; always upload the open-source files so the client never gets stuck. Never upload the ZIP itself onto Google Drive.
9. No watermarks, guides, crop marks, or unintended elements in the delivery files.
10. Design meets professional quality — not rushed or incomplete.

> **Rule:** If even one item fails, return the file to the designer before delivery. No exceptions — not for tight deadlines, not for any reason. The brand image is everything.
$BODY$,
  array['csr','hr','pm','manager']::user_role[], false, 8
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='fiverr-ops'),
  'SOP 08 — Client Delivery Procedure', 'sop-08-delivery',
  $BODY$
**In short:** Delivery is the most visible moment of the client experience. Handle it professionally and completely.

## Steps (in order)
1. **Complete QC first** — never deliver before finishing the full [Quality Review](/section/sop-07-quality-check). Delivery comes after QC, always.
2. **Name the files** — follow the [naming convention](/section/sop-09-file-naming).
3. **Prepare the delivery package** — organize all files into a clear folder; include all required formats (Google Drive + a ZIP if applicable).
4. **Upload to Google Drive** — to the designated client folder, with sharing set so the client has unrestricted access.
5. **Send the delivery message** — a professional, brand-appropriate message confirming what's delivered, the Drive link, the ZIP (if any), and a note that the Drive link works if the ZIP doesn't open.
6. **Update ClickUp** — set status to *Delivered* and log a remark with the delivery date and what was delivered.
7. **Add a delivery remark** — date, time, what was delivered, and the Drive link for reference.

> **Standard:** Delivery messages always include the **Google Drive link + ZIP**, with the line: *"If the ZIP file does not open, please use the Google Drive link — it's the same in both places."*
$BODY$,
  array['csr','hr','pm','manager']::user_role[], false, 9
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='fiverr-ops'),
  'SOP 09 — File Naming Convention', 'sop-09-file-naming',
  $BODY$
**In short:** Consistent file names prevent confusion, lost files, and delivery errors. Every file sent or stored follows the same standard.

## Standard format
```
[Client Name]_[Project Name]_[Profile extension]_[Date].[ext]
```
**Example (client-approved final):** `Ashyervanny_Cropmedia_AH2_25Jun2026.png`

## Rules
- **No spaces** — use underscores (`_`) only.
- **Version numbers on revisions** — `v1`, `v2`, `v3`, …
- **Date format** — `DDMMMYYYY` (e.g., `25Jun2026`).
- The file extension must match the actual file format.
- **Never overwrite** a previous version — always create a new file with the updated version number.
$BODY$,
  array['csr','hr','pm','manager']::user_role[], false, 10
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='fiverr-ops'),
  'SOP 10 — Handling Sensitive or Confusing Cases', 'sop-10-sensitive-cases',
  $BODY$
**In short:** When a case is sensitive, complex, or unclear, consult your Senior **before** acting — don't guess or handle it alone.

## When to escalate to a Senior
- The client is frustrated, angry, or dissatisfied.
- The client requests a cancellation or refund.
- The brief is extremely complex or conflicts with previous instructions.
- The request involves legal, ethical, or reputational risk.
- You're unsure how to respond without making it worse.
- It's outside your scope or experience.

## Escalation steps
1. **Don't respond first** — send nothing to the client until you've consulted a Senior. A premature reply can worsen things.
2. **Brief your Senior** — a clear, factual summary: the client's message, order details, and case history.
3. **Get guidance** — wait for direction and follow it precisely.
4. **Document it** — add a remark noting the escalation, date/time, which Senior, and the agreed action.

> **Rule:** Escalating is never a sign of weakness — it's the professional move when a situation exceeds your scope. Never tackle sensitive cases alone.
$BODY$,
  array['csr','hr','pm','manager']::user_role[], false, 11
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='fiverr-ops'),
  'SOP 11 — Upselling & Cross-Selling', 'sop-11-upselling',
  $BODY$
**In short:** Suggest extra services only when they genuinely help the client — with value, never pressure. **Never beg for a sale.**

## Core principles
- Only suggest services genuinely relevant to the client's current project or goals.
- **Lead with value** — explain what it does for *them*, not what it earns for us.
- One professional suggestion is fine; repeating it after a "no" is not.
- Timing: suggest when the client is **satisfied** with current work, never during a problem.

## Approved approach
1. **Spot the opportunity** — e.g., a logo client may benefit from a brand identity kit or business cards.
2. **Frame around value** — e.g., *"Since we've designed your logo, a matching business card would help customers remember your brand — would that be helpful?"*
3. **Accept the answer** — if they decline, thank them and refocus on delivering their current order with quality. Don't bring it up again unless they do.
4. **Log it** — note in remarks whether an upsell was discussed and the client's response.

> **Important:** The goal is long-term relationships, not short-term sales. A client who trusts us returns and spends far more over time than any single upsell.
$BODY$,
  array['csr','hr','pm','manager']::user_role[], false, 12
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='fiverr-ops'),
  'SOP 12 — Client Relationship Management', 'sop-12-client-relationships',
  $BODY$
**In short:** Our most valuable asset is client relationships, and CSRs are the company's ambassadors. Every interaction should reinforce trust and professionalism.

## Communication standards
- Address the client by their preferred name.
- Be professional **and** warm — never cold, rude, robotic, or overly casual.
- **Deliver on every commitment.** If you say "shortly," get back ASAP — not the next day.
- Keep the client informed proactively — don't wait to be asked for updates.
- If a deadline changes, tell the client immediately and apologize professionally. Never let a deadline pass silently, and never blame a designer or teammate to the client — it reflects on the whole company.

## Building long-term relationships
- Prioritize the client's success over the immediate transaction — valued clients return.
- Reference relevant details from past interactions where appropriate.
- When a project completes, thank them genuinely and invite future contact — without a selling tone.
- Never pressure a client to leave a review or place a new order. **Always help, never sell** — show value and you'll see the results.
$BODY$,
  array['csr','hr','pm','manager']::user_role[], false, 13
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='fiverr-ops'),
  'SOP 13 — Cancellation & Frustrated-Client Protocol', 'sop-13-cancellations',
  $BODY$
**In short:** Cancellations and highly frustrated clients are escalated to a Senior **immediately**. CSRs are not authorized to cancel, refund, or make commitments here without Senior approval.

## Immediate steps
1. **Acknowledge the client** — brief, empathetic, and immediate. Example: *"Thank you for letting us know. I completely understand your concern and want to make sure this is resolved. I'm escalating this right now to our senior management so they can review your case and get back to you shortly."*
2. **Don't make promises** — no refunds, discounts, or free revisions without Senior approval. Just reassure them it's being taken seriously.
3. **Escalate immediately** — contact your Senior via the escalation channel with the full case summary: client name, order ID, the complaint, and history.
4. **Follow Senior guidance** — don't deviate without further consultation.
5. **Document as a case study** — after resolution, record what happened, how it was handled, and the outcome to build your skill for similar cases.

> **Rule:** No CSR may process a cancellation or issue a refund independently. Always escalate. Always.
$BODY$,
  array['csr','hr','pm','manager']::user_role[], false, 14
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='fiverr-ops'),
  'SOP 14 — Daily Activity Report (DAR)', 'sop-14-daily-report',
  $BODY$
**In short:** Every CSR submits a Daily Activity Report to their Senior at the end of each shift — accurate, complete, and on time.

## What the DAR must include
| Section | What to include |
| --- | --- |
| Queries handled | Total received and responded to; note any still pending. |
| Orders assigned | Orders given to designers — with designer name and deadline. |
| Revisions assigned | Revision number and turnaround deadline. |
| Deliveries made | All deliveries sent — order ID / client name and time. |
| ClickUp status | Confirm ClickUp is fully updated for all tasks managed. |
| Escalations | Any cases escalated to Seniors — brief description and outcome. |
| Pending items | Anything carrying over to the next shift, with the reason. |
| Personal notes | Honest assessment of the shift — challenges, skills practiced, improvements. |

> **Rule:** The DAR is submitted to your Senior by the end of every shift, without exception. Inconsistent or incomplete reporting is a performance issue.
$BODY$,
  array['csr','hr','pm','manager']::user_role[], false, 15
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

-- ===== CHAPTER 7 · Tools & Systems ==========================================

insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='tools'),
  'ClickUp — Our Single Source of Truth', 'clickup-basics',
  $BODY$
**In short:** ClickUp holds the real status of every order and task. Keep it accurate and current so everyone can rely on it.

## The golden rule
> If it's not in ClickUp, it didn't happen.

## Status labels we use
- **In Progress** — you're actively working it.
- **Assigned to Designer** — handed off, with designer name + deadline.
- **Pending Client Feedback** — waiting on the client.
- **Revision Sent** — revision delivered, awaiting response.
- **Delivered** — final delivery completed.

## Habits that keep ClickUp clean
- Update at least **once an hour** and before any desk break ([SOP 03](/section/sop-03-clickup-updates)).
- Every status change gets a **remark** — what happened and the next step ([SOP 06](/section/sop-06-remarks)).
- Cross-check incoming order numbers against the sheet and ClickUp.

**Helping point:** Before you leave your desk, do a 60-second sweep — every task in the right status with a current remark.
$BODY$,
  array['csr','hr','pm','manager']::user_role[], false, 1
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

-- ===== CHAPTER 8 · HR & Payroll =============================================

insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='hr-payroll'),
  'Quarterly Performance Bonus Policy', 'quarterly-bonus-policy',
  $BODY$
**In short:** Every 3 months, Customer Support team members earn a bonus based on **performance — not sales**. You're scored out of 100 on things you control: how you show up, communicate, handle clients, and execute.

> **Key principle:** Your bonus is **not** tied to sales numbers. It's tied to your professionalism, consistency, and quality of work.

## Review cycle
| Quarter | Period | Review | Bonus paid |
| --- | --- | --- | --- |
| Q1 | Jan – Mar | Last week of March | 1st week of April |
| Q2 | Apr – Jun | Last week of June | 1st week of July |
| Q3 | Jul – Sep | Last week of September | 1st week of October |
| Q4 | Oct – Dec | Last week of December | 1st week of January |

## Scorecard — 100 points
| Category | Points | What's evaluated |
| --- | --- | --- |
| Punctuality & Attendance | 20 | On-time sign-in, break management, no unexplained absences, consistent availability. |
| Behavior & Professionalism | 15 | Respect for teammates/Seniors, dress code, positive engagement, no disciplinary notes. |
| Work Quality | 20 | Accurate ClickUp/sheet entries, correct file naming, clear reports/remarks, QC before delivery. |
| Work Execution | 15 | Correct workflow, on-time assignment of orders/revisions, proper escalation, nothing missed before leaving. |
| Client Communication | 20 | 5-minute replies, professional warm tone, understanding requirements, long-term relationships. |
| Cancellation Handling | 10 | Escalating cancellations immediately, not handling emotional cases alone, following up as case studies. |

## How each category is scored
Your Senior scores each category on observable evidence — not opinion — using one 5-level scale:

| Rating | % | Meaning |
| --- | --- | --- |
| Excellent | 100% | Consistently exceeded expectations. Set an example. |
| Good | 80% | Met expectations well. Minor, rare lapses. |
| Average | 60% | Met most expectations. Clear areas to improve. |
| Below Average | 40% | Frequently fell short. Multiple issues. |
| Poor | 0% | Did not meet expectations. Serious or repeated issues. |

## Bonus tiers
| Tier | Score | Bonus | Extra |
| --- | --- | --- | --- |
| Elite Performer | 90–100 | Full bonus + 10% | Written recognition + promotion priority |
| High Performer | 75–89 | Full bonus | Verbal recognition in team meeting |
| Meets Standard | 60–74 | Partial (50%) | Informal feedback session |
| Below Standard | 40–59 | No bonus | Mandatory improvement plan |
| Unsatisfactory | < 40 | No bonus | Formal review with HR |

## Worked example — "Sarah"
| Category | Max | Rating | Score | Senior's note |
| --- | --- | --- | --- | --- |
| Punctuality | 20 | Good | 16 | Late twice; otherwise consistent. |
| Behavior | 15 | Excellent | 15 | Perfect attitude. |
| Work Quality | 20 | Good | 18 | Minor early file-naming errors. |
| Work Execution | 15 | Excellent | 15 | Always followed process. |
| Client Communication | 20 | Good | 18 | Strong relationships; missed 5-min reply 3×. |
| Cancellation Handling | 10 | Average | 8 | Handled one case alone instead of escalating. |
| **Total** | **100** | | **90** | **High Performer — Full Bonus** |

Sarah's focus for next quarter: **always escalate** complex cancellations instead of solving them alone.

## Eligibility
- Minimum **2 full months** employed within the quarter.
- **No active written warning** at review time (a formal warning reduces your total by 10 points).
- No unexcused, unpaid absences during the quarter.
- Daily reports submitted consistently, without major gaps.

## Our commitment to fairness
- You get your **full scorecard breakdown** every quarter.
- You may discuss your scores with your Senior before they're finalized.
- Seniors give **monthly** feedback, so the quarterly review holds no surprises.
- All scores are reviewed by the **CEO** before bonuses are confirmed.
- If you believe a score is inaccurate, raise it **in writing within 5 business days**.
$BODY$,
  array['csr','hr','pm','manager']::user_role[], false, 1
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;
