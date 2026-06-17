-- =============================================================================
-- HaseebMadeit Handbook, 0015 content (batch 8): visual SOP pass
-- Turns the remaining playbook SOPs (01, 02, 03, 04, 05, 10, 11, 13) into
-- step flows, checklists, and stat tiles using the markdown widgets, so the
-- whole CSR playbook reads like a designed product. Wording is preserved.
-- SOP 09 keeps its shape; only the sample file name is genericised so no
-- real client name appears in the book. Idempotent upsert by slug.
-- =============================================================================

-- ===== SOP 01: profile review as a step flow ================================
insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='fiverr-ops'),
  'SOP 01: Client Profile Review and Order Management', 'sop-01-profile-review',
  $BODY$
Before you reply to a client or touch an order, read their profile and their history. Every client is a case of their own.

## Before you reply

```steps
Open the profile | Look at the full profile before you say a word: their order history, past remarks, the briefs, and any notes a Senior left.
Read every remark | Get a real sense of what they like, what went wrong before, and where each of their orders stands today.
Check the active orders | For each one, know the stage it is at, whether that is brief received, in design, in revision, waiting to deliver, or delivered.
Spot what is urgent | Notice what is close to a deadline, and flag anything stuck or overdue so it gets attention.
Check the brief | Make sure it is complete and clear. If anything is missing, sort it out with the client before you hand it to a designer.
```

> **Rule:** Never guess what a client wants. Confirm the brief is complete before any work starts.

> **Tip:** Two minutes on the profile saves you most of the mistakes, like the wrong style, a missed revision, or asking something they already told you. Start here every time.
$BODY$,
  array['csr','hr','pm','manager']::user_role[], false, 2
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

-- ===== SOP 02: five minute rule, stats + steps ==============================
insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='fiverr-ops'),
  'SOP 02: Reply Within Five Minutes', 'sop-02-query-5-min',
  $BODY$
Every new client message gets a reply within five minutes. There is no exception to this.

```stats
5 min | Maximum reply time
0 | Exceptions
```

## The five minute rule

```steps
Watch every channel | Keep an eye on email, chat, ClickUp, and anything else you have been given, the whole shift.
Answer within five minutes | Even if you do not have the full answer yet, let them know you have their message and you are looking into it.
Get the context | Pull up their profile and the order details so you understand the whole picture before you give a real answer.
Reply properly | Keep it clear, polite, and in the tone the brand expects.
Log it | Drop a short remark so anyone on the team can see what was asked and what you said.
```

> **Important:** A slow reply makes us look unprofessional. If you are busy with something else, still send a quick line within five minutes and come back to them as soon as you can.

> **Tip:** Keep two or three friendly holding lines ready, something like, "Thanks for your message, I am looking into your case and will update you shortly," so you never miss the five minute mark.
$BODY$,
  array['csr','hr','pm','manager']::user_role[], false, 3
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

-- ===== SOP 03: hourly ClickUp updates as a step flow ========================
insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='fiverr-ops'),
  'SOP 03: Keep ClickUp Updated Every Hour', 'sop-03-clickup-updates',
  $BODY$
ClickUp is the one place we all trust for the status of every order. Keep it current so Seniors, the Project Manager, and your teammates always know where things stand.

## Every hour, do this

```steps
Update every hour | Log in at least once an hour and update everything you are working on. Do not save it all for the end of the shift.
Update before you take on more | Never let unlogged updates pile up before you pick up the next task.
Update before a break | When you step away from the desk for any reason, leave nothing missing.
Use the right status | Pick the correct label, like In Progress, Pending Client Feedback, Assigned to Designer, Revision Sent, or Delivered.
Add a remark | Each update should say what happened and what comes next. An update with no context is not enough.
```

> **Rule:** If it is not in ClickUp, it did not happen. A task nobody can see is a task nobody can help you with.

> **Tip:** The labels we use are listed in [How We Use ClickUp](/section/clickup-basics).
$BODY$,
  array['csr','hr','pm','manager']::user_role[], false, 4
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

-- ===== SOP 04: brief checklist + assign step flow ===========================
insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='fiverr-ops'),
  'SOP 04: Giving Orders to Designers', 'sop-04-assign-designers',
  $BODY$
Handing work to the design team is one of the most important things you do. A weak or late brief shows up straight away in the quality and in how the client feels.

## A complete brief has

```checklist
The size and dimensions.
The file formats the client needs.
The brand colours, fonts, and assets.
The references and examples.
The copy and all the text.
Any special notes on what the client is particular about.
```

## Steps

```steps
Check the brief is complete | Before you assign anything, confirm you have the size, the formats, the colours, the references, the copy, and any special notes.
Assign it quickly | Once the brief is confirmed, pass it on. Do not sit on it waiting for things you do not really need.
Give the full picture | Include the client name, the order number, the deadline, the brief file, and a short note on anything the client is particular about.
Set a clear deadline | Always say when it is due, and make sure the designer has seen it and agreed.
Put it in ClickUp | Move the status to Assigned to Designer with the designer's name and the deadline.
Sweep before you leave | Before you end your shift, check that every pending order has been assigned. Nothing should be left hanging.
```

> **Rule:** Never hand a half finished brief to a designer. It wastes their time, slows the delivery, and hurts the client relationship.

> **Tip:** A quick mental checklist before you assign, size, format, colours, references, copy, deadline, saves most of the back and forth.
$BODY$,
  array['csr','hr','pm','manager']::user_role[], false, 5
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

-- ===== SOP 05: revisions as a step flow =====================================
insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='fiverr-ops'),
  'SOP 05: Revisions and Tracking Them', 'sop-05-revisions',
  $BODY$
Treat a revision with the same care as a new order. Log it clearly, assign it fast, and follow it until it is done.

## Steps

```steps
Read it fully | When a revision comes in, go through every point the client raised before you do anything.
Clear up anything fuzzy | If a point is not clear, check with the client first. Never let a designer start on guesswork.
Pass it to the designer | Send it straight away with a clean, numbered list of exactly what is changing.
Set the deadline | Pick one that fits the client's expectations and the project, and make sure the designer agrees.
Update the sheet | Note the revision number, the designer, the deadline, and a short line on what is being changed.
Stay on it | Check in before the deadline to be sure it is on track, and raise it with a Senior if something is blocking it.
```

> **Rule:** Never send a revised design to a client before you have looked at it yourself and confirmed every change was made. See [SOP 07](/section/sop-07-quality-check).
$BODY$,
  array['csr','hr','pm','manager']::user_role[], false, 6
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

-- ===== SOP 09: keep the shape, genericise the sample name ====================
insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='fiverr-ops'),
  'SOP 09: Naming Your Files', 'sop-09-file-naming',
  $BODY$
Naming files the same way every time keeps things from getting lost or mixed up. Every file you send or store follows this.

## The format
```
ClientName_ProjectName_ProfileExtension_Date.ext
```
Final file the client has approved, for example: `SampleClient_LogoPack_AH2_25Jun2026.png`

## The rules

```checklist
No spaces in a file name. Use underscores instead.
For revisions, put the version in: v1, v2, v3, and so on.
Write the date like 25Jun2026.
The extension always matches the real file type.
Never write over an old version. Make a new file with the next version number.
```
$BODY$,
  array['csr','hr','pm','manager']::user_role[], false, 10
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

-- ===== SOP 10: triggers list + escalation step flow =========================
insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='fiverr-ops'),
  'SOP 10: Handling Sensitive or Confusing Cases', 'sop-10-sensitive-cases',
  $BODY$
Not every case is simple. When one is sensitive, complicated, or unclear, talk to your Senior before you act. Do not guess, and do not carry it alone.

## When to bring in a Senior
- The client is upset, angry, or unhappy with the work.
- They are asking to cancel or want a refund.
- The brief is very complex, or it clashes with what they said earlier.
- There is any legal, ethical, or reputation risk in it.
- You are not sure how to reply without making it worse.
- It is simply beyond your experience or what you are allowed to decide.

## How to escalate

```steps
Hold your reply | Send nothing to the client until you have spoken to a Senior. A quick wrong reply can make things worse.
Brief your Senior | Give them a clear, factual summary: the client's message, the order, and the history.
Follow their lead | Wait for their direction and do exactly that.
Write it down | Add a remark noting that you escalated, when, which Senior, and what you agreed to do.
```

> **Rule:** Asking a Senior is never a weakness. It is the right move when a case is bigger than your call. Never take a sensitive case on alone.
$BODY$,
  array['csr','hr','pm','manager']::user_role[], false, 11
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

-- ===== SOP 11: principles + how to do it step flow ==========================
insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='fiverr-ops'),
  'SOP 11: Offering Extra Services', 'sop-11-upselling',
  $BODY$
Suggest extra services only when they genuinely help the client, and always with value, never with pressure. Never beg for a sale.

## How we think about it
- Only suggest something that really fits what they are working on.
- Lead with what it does for them, not what it earns for us.
- One good suggestion is fine. Repeating it after they say no is not.
- Timing matters. The moment to suggest more is when they are happy with the work, never in the middle of a problem.

## How to do it

```steps
Spot the fit | While you look over their project, notice something that would genuinely add to it. A client getting a logo might also want a brand kit or a business card.
Frame it as value | For example, since we have already done your logo, we could make a matching business card so people remember your brand. Would that be useful?
Take the answer well | If they pass, thank them and go back to delivering their order beautifully. Do not bring it up again unless they do.
Log it | Note in the remarks that you offered something and what they said.
```

> **Important:** The goal is a relationship that lasts, not a quick sale. A client who trusts us comes back again and again, and that is worth far more than any single add on.
$BODY$,
  array['csr','hr','pm','manager']::user_role[], false, 12
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

-- ===== SOP 13: cancellations as a step flow =================================
insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='fiverr-ops'),
  'SOP 13: Cancellations and Upset Clients', 'sop-13-cancellations',
  $BODY$
A cancellation or a very upset client goes to a Senior straight away. A CSR is not allowed to cancel, refund, or promise anything here without a Senior saying so.

## What to do right away

```steps
Acknowledge them | Send a short, warm line at once that says you understand their concern and are passing it to the senior team to look at and come back shortly.
Promise nothing | No refunds, discounts, or free revisions without a Senior's approval. Just reassure them it is being taken seriously.
Bring in a Senior now | Reach your Senior through the proper channel and give them the whole case: the client, the order number, the complaint, and the history.
Follow their lead | Do exactly what the Senior decides, and do not change course without checking again.
Save it as a case study | Once it is resolved, write down what happened, how it was handled, and how it ended. It makes you better at the next one.
```

> **Standard:** A good first line is, "Thank you for letting us know. I completely understand your concern and I want to make sure this is sorted for you. I am passing it to our senior team now so they can look at your case and get back to you shortly."

> **Rule:** No CSR cancels an order or gives a refund on their own. Always escalate. Always.
$BODY$,
  array['csr','hr','pm','manager']::user_role[], false, 14
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;
