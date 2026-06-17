-- =============================================================================
-- HaseebMadeit Handbook, 0008 content (batch 2)
-- Drawn only from already-provided material (no new policy invented).
-- Plain human voice (no em dashes, no hyphens, no AI phrasing).
-- =============================================================================

-- ===== CHAPTER 1 · Welcome & Company ========================================

insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='welcome'),
  'How to Use This Handbook', 'how-to-use',
  $BODY$
Read your own role's pages first, then use search whenever you get stuck. This book is always the latest word, so when a rule changes you will see it on the What's New page.

## How it is laid out
The book is split into chapters on the left. Each chapter holds short sections, one topic to a page. On every page, look for:

- A short summary at the very top.
- Coloured boxes for the things that matter most:

> **Rule:** Something you must do.

> **Important:** Something to be careful about.

> **Tip:** Something that makes the job easier.

## Finding things fast
- Search sits at the top of every screen and understands typos and everyday words. Try "chutti", "refund", or "clickup".
- What's New shows the most recent change, and the full history is in Chapter 12.

## What you can see
You are reading your own role's edition. Everyone shares the common chapters, and your role also sees the pages meant for you. If a link says a page is not available, it simply sits outside your role, and that is normal.

## Acknowledgment
By using this book in your role, you confirm that you have read and understood the parts that apply to you, and you agree to follow them. If anything is unclear, ask your Senior. That is always the right move.
$BODY$,
  array['csr','asr','hr','pm','manager','office_boy']::user_role[], true, 3
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

-- ===== CHAPTER 6 · Design Delivery & QA =====================================

insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='delivery-qa'),
  'Our Quality Bar', 'our-quality-bar',
  $BODY$
Nothing reaches a client until it has been checked. The brand image is everything, and the experience is what brings people back.

## The standard
Every delivery, whether it is a first draft or a revision, goes through a full check before it leaves. We would rather hold something for an hour than send it out rushed.

> **Rule:** If even one quality point fails, the work goes back to the designer before it leaves. No exceptions, not even for a tight deadline.

## How we protect quality, start to finish
1. A complete brief before any work begins. See [SOP 01](/section/sop-01-profile-review) and [SOP 04](/section/sop-04-assign-designers).
2. A quality check against the brief and the full list. See [SOP 07](/section/sop-07-quality-check).
3. Correct file names, so nothing gets lost. See [SOP 09](/section/sop-09-file-naming).
4. A clean delivery, the Drive link and the ZIP, with a professional message. See [SOP 08](/section/sop-08-delivery).

> **Tip:** Quality is not only the design. It is the brief, the file names, the message, and the follow up. The client feels all of it.
$BODY$,
  array['csr','hr','pm','manager']::user_role[], false, 1
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

-- ===== CHAPTER 10 · Emergencies & Escalation ================================

insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='escalation'),
  'Who to Contact and How to Escalate', 'who-to-contact',
  $BODY$
When something is past what you can handle, go to your shift Team Leader first. They take it up the chain. Never sit on a problem.

## Your line of contact
1. **Your shift Team Leader or Senior.** The first stop for anything you cannot sort yourself. Morning is Ezan, Evening is Zubair and Ezan, Night is Zubair.
2. **The Project Manager.** Order flow, designer assignments, and anything blocking the work. See the [Project Manager role](/section/role-pm).
3. **The CEO, Abdul Haseeb.** The final say. You reach him through your Senior, or directly when a Senior says it is a priority.

## Escalate right away when
- A client is upset, angry, or asking to cancel or refund. Pass it on at once and promise nothing.
- A case is sensitive, risky, or unclear. Check before you act.
- Anything could touch a client's experience or the company's name.

> **Rule:** Asking for help is never a weakness. It is the right move when something is bigger than your call. Never take a sensitive case on alone.

### For CSRs
The full steps are in the playbook: [SOP 10, Sensitive or Confusing Cases](/section/sop-10-sensitive-cases) and [SOP 13, Cancellations and Upset Clients](/section/sop-13-cancellations).

> **Tip:** When you escalate, give a clear, factual summary, what happened, the order and client, and the history, so your Senior can move fast.
$BODY$,
  array['csr','asr','hr','pm','manager','office_boy']::user_role[], true, 1
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

-- ===== CHAPTER 11 · Glossary & FAQ ==========================================

insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='faq'),
  'Glossary', 'glossary',
  $BODY$
Quick meanings for the words you will see around the handbook.

| Word | What it means |
| --- | --- |
| **CSR** | Customer Support Representative. Owns the client conversation and the order. |
| **ASR** | After Sales Representative. A separate role focused on after sales support. |
| **Senior CSR** | A senior who runs the CSR team, coaching them and taking on cancellations. |
| **PM** | Project Manager. Keeps orders moving between CSRs and designers. |
| **SOP** | Standard Operating Procedure. The set way we do a task. |
| **DAR** | Daily Activity Report. The end of shift summary every CSR sends. See [SOP 14](/section/sop-14-daily-report). |
| **QC** | Quality Check. The review we do before any delivery. See [SOP 07](/section/sop-07-quality-check). |
| **ClickUp** | Our task tool, and the one place we trust for order status. See [How We Use ClickUp](/section/clickup-basics). |
| **Organic order** | A real, paid client order. |
| **Practice project** | A practice brief we give designers when there are no real orders left. |
| **Brief** | The client's full requirements: size, format, colours, references, and copy. |
| **Revision** | A change the client asks for after a delivery. See [SOP 05](/section/sop-05-revisions). |
| **Remark** | A note on an order so anyone can follow its story. See [SOP 06](/section/sop-06-remarks). |
| **Delivery package** | The organised files we send the client, the Drive link and the ZIP. See [SOP 08](/section/sop-08-delivery). |
| **Escalation** | Passing a case up to a Senior for guidance. See [SOP 10](/section/sop-10-sensitive-cases). |

> **Tip:** See a word that is missing? Tell your Senior and we will add it.
$BODY$,
  array['csr','asr','hr','pm','manager','office_boy']::user_role[], false, 1
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;
