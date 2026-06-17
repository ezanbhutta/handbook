-- =============================================================================
-- HaseebMadeit Handbook, 0007 content (batch 1)
-- Sourced from: Company Hierarchy & JDs, CSR SOPs, Quarterly Bonus Policy.
-- Written in a plain, human voice (no em dashes, no hyphens, no AI phrasing).
--
-- Visibility model:
--   "Everyone"  = all six roles (welcome, company/org).
--   CSR content = csr + hr + pm + manager. CSR and ASR are SEPARATE roles, so
--                 ASR is not included here; it gets its own content later.
--   Manager has full data access (it appears in every section's allowed_roles).
-- Idempotent: re-running upserts each section by slug (edit + re-run to update).
-- =============================================================================

-- ===== CHAPTER 1 · Welcome & Company ========================================

insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='welcome'),
  'Welcome to HaseebMadeit', 'welcome-to-haseebmadeit',
  $BODY$
We are a design and branding agency based in Multan. Most of our work comes through clients online, and our teams run across three shifts so someone is always there to help.

## Who we are
We build brands and designs that people remember. The work is creative, but the thing that keeps clients coming back is how we treat them. That part is on all of us, whatever your role.

## What this book is for
Think of this as the one place that answers your questions. When you are not sure how something is done here, look it up first. It stays current, so whenever a rule changes you will see it on the What's New page.

> **Tip:** The brand image is everything, and the experience is what clients remember. Protect both and you are doing your job well.

If you are new, start with these:

- [Company Hierarchy and Shifts](/section/company-hierarchy), so you know who's who and who to ask.
- Your own role page under Your Role.
- If you are a CSR, the [CSR Playbook](/section/csr-playbook-start-here).
$BODY$,
  array['csr','asr','hr','pm','manager','office_boy']::user_role[], true, 1
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='welcome'),
  'Company Hierarchy and Shifts', 'company-hierarchy',
  $BODY$
We run three shifts, and each one has a Team Leader you report to along with its own CSR team. When something is past what you can handle on your own, your Team Leader is the first person you go to.

## Shifts and Team Leaders
| Shift | Team Leader |
| --- | --- |
| Morning | Ezan |
| Evening | Zubair and Ezan |
| Night | Zubair |

## How the team is set up
- **CEO and Founder, Abdul Haseeb.** Final calls, scores, and the big decisions.
- **Team Leaders and Seniors.** They run the shift, sort out escalations and cancellations, and coach the team.
- **Project Manager.** Keeps work moving between the CSRs and the designers. See the [Project Manager role](/section/role-pm).
- **CSRs.** They own the client conversation and the order from start to finish. See the [CSR role](/section/role-csr).

## The CSR team, by shift
| Morning | Evening | Night |
| --- | --- | --- |
| Iqra Qaiser | Abdul Basit | Salman Malik |
| Tanzeel Bibi | Tayyab | Ahmed Bibrash |
| Hassan Mehdi | Husnain Gillani | Swaid Khan |
| Amrah Shoaib | Abdul Hadi | Saad Khan |
|  | Ali Shakeel | Nadir Ali |
|  |  | Samama |

> **Tip:** Not sure who to ask? Go to your shift Team Leader first. They will take it up to the Project Manager or the CEO if it needs to go further. HR and the Seniors keep this list current.
$BODY$,
  array['csr','asr','hr','pm','manager','office_boy']::user_role[], true, 2
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

-- ===== CHAPTER 4 · Your Role ================================================

insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='your-role'),
  'The CSR Role', 'role-csr',
  $BODY$
As a CSR you own the client and the order, from the first message all the way to the final delivery. Speed, care, and getting the details right are the heart of the job. This page is the overview. The step by step way we do each part lives in the [CSR Playbook](/section/csr-playbook-start-here).

## What you are responsible for
- Treat every client profile as its own case. Read it properly and give them the best experience you can.
- Reply to a new query within five minutes. See [SOP 02](/section/sop-02-query-5-min).
- Keep ClickUp updated every hour. It is the one place we all trust for order status. See [SOP 03](/section/sop-03-clickup-updates).
- Hand work to designers on time, with a brief that is actually complete. See [SOP 04](/section/sop-04-assign-designers) and [SOP 05](/section/sop-05-revisions).
- Write clear remarks on every order so anyone can pick it up. See [SOP 06](/section/sop-06-remarks).
- Check every delivery yourself before it reaches the client. See [SOP 07](/section/sop-07-quality-check).
- Name and send files the right way, the Drive link and the ZIP together. See [SOP 08](/section/sop-08-delivery) and [SOP 09](/section/sop-09-file-naming).
- Pass cancellations and upset clients to a Senior straight away. See [SOP 10](/section/sop-10-sensitive-cases) and [SOP 13](/section/sop-13-cancellations).
- Build real relationships. Always help, never beg for a sale. See [SOP 11](/section/sop-11-upselling) and [SOP 12](/section/sop-12-client-relationships).
- Send your daily report at the end of every shift. See [SOP 14](/section/sop-14-daily-report).

> **Rule:** If a case feels confusing or sensitive, talk to a Senior. Never try to handle a hard one on your own.
$BODY$,
  array['csr','hr','pm','manager']::user_role[], true, 1
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='your-role'),
  'The Senior CSR Role', 'role-senior-csr',
  $BODY$
A Senior CSR runs the team day to day. You watch over the floor, coach the CSRs, take on cancellations and retention, and keep the CEO in the loop.

## What you look after
- Keep an eye on the team every day: timing, breaks, dress, how engaged people are, and how they are performing.
- Go through the team's cases daily. Be there for their questions, then hand out the work around sales, negotiation, and client relationships.
- Match the incoming order count against the sheet and against what is assigned in ClickUp.
- Coach each CSR to their strengths, and run small training exercises when there is room.
- Take on every profile cancellation yourself and work it with a plan, whether that is a meeting, a discount, or a careful negotiation. See [SOP 13](/section/sop-13-cancellations).
- Watch the patterns in queries and orders, the volume and the timing, and act on what you see.
- Set the week's targets and hold the team to them.
- Talk to HR every couple of days about team issues and hiring, and help picture the kind of person we want.
- Keep researching the market, and push us to grow beyond a single platform.
- Send the CEO a clear team report every day, and flag anything big or small the same day.

> **Tip:** You score the CSRs each quarter on what you can actually see, not on a feeling. Read the [Quarterly Bonus Policy](/section/quarterly-bonus-policy), and give people feedback monthly so the quarterly review never surprises them.
$BODY$,
  array['csr','hr','pm','manager']::user_role[], false, 2
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='your-role'),
  'The Project Manager Role', 'role-pm',
  $BODY$
The Project Manager keeps work flowing between the CSRs and the designers. You run the daily check ins, keep ClickUp clean, hand out briefs, and report to the CEO.

## What you look after
- Run a daily check in and follow up on yesterday's tasks and updates.
- Collect updates from the designers each day and make sure work is assigned or reviewed.
- Keep the progress sheet current, and send the CEO your reports.
- Send a weekly report with notes and reasons for each person on the team.
- Work with the CSR team on which real orders go to which designer.
- Keep ClickUp clear day by day so nobody is stuck on an order.
- When the CSRs say there are no real orders left, hand the designers practice projects so they keep their hands busy.
- Onboard new designers and walk them through ClickUp, the setup, how we work, and our policies.
- Sit in on meetings, sort out problems, and see them through. If something is genuinely out of your hands, take it to the CEO quickly.
- Spot the problems across the team and bring solutions to the meeting with the CEO.

> **Tip:** You are the bridge between the people selling and the people making. When you are unsure, protect two things first: the deadline and the quality of the brief. Both decide how the client feels.
$BODY$,
  array['csr','hr','pm','manager']::user_role[], false, 3
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

-- ===== CHAPTER 5 · Fiverr Operations Playbook (CSR SOPs) ====================

insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='fiverr-ops'),
  'CSR Playbook: Start Here', 'csr-playbook-start-here',
  $BODY$
These are the standard procedures for every CSR. You are expected to know them and follow them, every day.

> **Important:** Not following these can lead to a formal warning. When you are in doubt, ask your Senior before you act, not after.

## The fourteen procedures
1. [Client Profile Review and Order Management](/section/sop-01-profile-review)
2. [Reply Within Five Minutes](/section/sop-02-query-5-min)
3. [Keep ClickUp Updated Every Hour](/section/sop-03-clickup-updates)
4. [Giving Orders to Designers](/section/sop-04-assign-designers)
5. [Revisions and Tracking Them](/section/sop-05-revisions)
6. [Remarks on Every Order](/section/sop-06-remarks)
7. [Quality Check Before Delivery](/section/sop-07-quality-check)
8. [Delivering to the Client](/section/sop-08-delivery)
9. [Naming Your Files](/section/sop-09-file-naming)
10. [Handling Sensitive or Confusing Cases](/section/sop-10-sensitive-cases)
11. [Offering Extra Services](/section/sop-11-upselling)
12. [Looking After the Client Relationship](/section/sop-12-client-relationships)
13. [Cancellations and Upset Clients](/section/sop-13-cancellations)
14. [Your Daily Report](/section/sop-14-daily-report)

> **Tip:** If you remember only three things, remember these: reply in five minutes, put everything in ClickUp, and check the work before it goes out.
$BODY$,
  array['csr','hr','pm','manager']::user_role[], true, 1
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='fiverr-ops'),
  'SOP 01: Client Profile Review and Order Management', 'sop-01-profile-review',
  $BODY$
Before you reply to a client or touch an order, read their profile and their history. Every client is a case of their own.

## Steps
1. **Open the profile.** Look at the full profile before you say a word: their order history, past remarks, the briefs, and any notes a Senior left.
2. **Read every remark.** Get a real sense of what they like, what went wrong before, and where each of their orders stands today.
3. **Check the active orders.** For each one, know the stage it is at, whether that is brief received, in design, in revision, waiting to deliver, or delivered.
4. **Spot what is urgent.** Notice what is close to a deadline, and flag anything stuck or overdue so it gets attention.
5. **Check the brief.** Make sure it is complete and clear. If anything is missing, sort it out with the client before you hand it to a designer.

> **Rule:** Never guess what a client wants. Confirm the brief is complete before any work starts.

> **Tip:** Two minutes on the profile saves you most of the mistakes, like the wrong style, a missed revision, or asking something they already told you. Start here every time.
$BODY$,
  array['csr','hr','pm','manager']::user_role[], false, 2
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='fiverr-ops'),
  'SOP 02: Reply Within Five Minutes', 'sop-02-query-5-min',
  $BODY$
Every new client message gets a reply within five minutes. There is no exception to this.

## Steps
1. **Watch every channel.** Keep an eye on email, chat, ClickUp, and anything else you have been given, the whole shift.
2. **Answer within five minutes.** Even if you do not have the full answer yet, let them know you have their message and you are looking into it.
3. **Get the context.** Pull up their profile and the order details so you understand the whole picture before you give a real answer.
4. **Reply properly.** Keep it clear, polite, and in the tone the brand expects.
5. **Log it.** Drop a short remark so anyone on the team can see what was asked and what you said.

> **Important:** A slow reply makes us look unprofessional. If you are busy with something else, still send a quick line within five minutes and come back to them as soon as you can.

> **Tip:** Keep two or three friendly holding lines ready, something like, "Thanks for your message, I am looking into your case and will update you shortly," so you never miss the five minute mark.
$BODY$,
  array['csr','hr','pm','manager']::user_role[], false, 3
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='fiverr-ops'),
  'SOP 03: Keep ClickUp Updated Every Hour', 'sop-03-clickup-updates',
  $BODY$
ClickUp is the one place we all trust for the status of every order. Keep it current so Seniors, the Project Manager, and your teammates always know where things stand.

## Steps
1. **Update every hour.** Log in at least once an hour and update everything you are working on. Do not save it all for the end of the shift.
2. **Update before you take on more.** Never let unlogged updates pile up before you pick up the next task.
3. **Update before a break.** When you step away from the desk for any reason, leave nothing missing.
4. **Use the right status.** Pick the correct label, like In Progress, Pending Client Feedback, Assigned to Designer, Revision Sent, or Delivered. Do not leave a task sitting in the wrong one.
5. **Add a remark.** Each update should say what happened and what comes next. An update with no context is not enough.

> **Rule:** If it is not in ClickUp, it did not happen. A task nobody can see is a task nobody can help you with.

> **Tip:** The labels we use are listed in [How We Use ClickUp](/section/clickup-basics).
$BODY$,
  array['csr','hr','pm','manager']::user_role[], false, 4
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='fiverr-ops'),
  'SOP 04: Giving Orders to Designers', 'sop-04-assign-designers',
  $BODY$
Handing work to the design team is one of the most important things you do. A weak or late brief shows up straight away in the quality and in how the client feels.

## Steps
1. **Check the brief is complete.** Before you assign anything, confirm you have the size, the file formats, the brand colours, the references, the copy, and any special notes.
2. **Assign it quickly.** Once the brief is confirmed, pass it on. Do not sit on it waiting for things you do not really need.
3. **Give the full picture.** Include the client name, the order number, the deadline, the brief file, and a short note on anything the client is particular about.
4. **Set a clear deadline.** Always say when it is due, and make sure the designer has seen it and agreed.
5. **Put it in ClickUp.** Move the status to Assigned to Designer with the designer's name and the deadline.
6. **Sweep before you leave.** Before you end your shift, check that every pending order has been assigned. Nothing should be left hanging.

> **Rule:** Never hand a half finished brief to a designer. It wastes their time, slows the delivery, and hurts the client relationship.

> **Tip:** A quick mental checklist before you assign, size, format, colours, references, copy, deadline, saves most of the back and forth.
$BODY$,
  array['csr','hr','pm','manager']::user_role[], false, 5
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='fiverr-ops'),
  'SOP 05: Revisions and Tracking Them', 'sop-05-revisions',
  $BODY$
Treat a revision with the same care as a new order. Log it clearly, assign it fast, and follow it until it is done.

## Steps
1. **Read it fully.** When a revision comes in, go through every point the client raised before you do anything.
2. **Clear up anything fuzzy.** If a point is not clear, check with the client first. Never let a designer start on guesswork.
3. **Pass it to the designer.** Send it straight away with a clean, numbered list of exactly what is changing.
4. **Set the deadline.** Pick one that fits the client's expectations and the project, and make sure the designer agrees.
5. **Update the sheet.** Note the revision number, the designer, the deadline, and a short line on what is being changed.
6. **Stay on it.** Check in before the deadline to be sure it is on track, and raise it with a Senior if something is blocking it.

> **Rule:** Never send a revised design to a client before you have looked at it yourself and confirmed every change was made. See [SOP 07](/section/sop-07-quality-check).
$BODY$,
  array['csr','hr','pm','manager']::user_role[], false, 6
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='fiverr-ops'),
  'SOP 06: Remarks on Every Order', 'sop-06-remarks',
  $BODY$
Every order needs a running set of remarks, so that anyone on the team, even a Senior who has never seen this client, can understand the whole story just by reading them.

## What a good remark looks like
| Good | Poor |
| --- | --- |
| "Client asked for 3 logo options on a dark background. Brief shared with Ali. Due 28 June, 5pm. They like a minimal style, noted in the brief." | "Assigned to designer. Will update soon." |

## How to write them
- Add a remark whenever something real happens on the order, like an assignment, a revision, a delivery, or feedback from the client.
- Each one should say what happened, who is on it, and what comes next.
- Write in clear, simple English. No slang, no short forms, no vague lines.
- A Senior who has never touched this client should get the full story from your remarks alone.
$BODY$,
  array['csr','hr','pm','manager']::user_role[], false, 7
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='fiverr-ops'),
  'SOP 07: Quality Check Before Delivery', 'sop-07-quality-check',
  $BODY$
No design goes to a client, first draft or revision, until you have checked it yourself. This step is not optional.

## The checklist
1. The design matches the brief in style, colour, size, and format.
2. Every bit of text is right. No spelling mistakes, no wrong names, no wrong numbers on the concepts.
3. The brand colours, fonts, and assets are what the client asked for. If not, send it back for a revision.
4. The file is saved in the format the client wanted, whether that is PNG, PDF, AI, or PSD.
5. For a revision, every single point the client raised is done and checked by you.
6. The file name follows our way of naming things. See [SOP 09](/section/sop-09-file-naming).
7. The Google Drive link is live, open, and tidy.
8. If you are sending a ZIP, it opens cleanly. Send both the Drive link and the ZIP, and always upload the open files so the client is never stuck. Do not upload the ZIP itself onto the Drive.
9. No watermarks, guides, crop marks, or stray bits in the files you send.
10. The work looks professional, not rushed.

> **Rule:** If even one of these fails, the file goes back to the designer before it leaves. No exceptions, not for a tight deadline, not for anything. The brand image is everything.
$BODY$,
  array['csr','hr','pm','manager']::user_role[], false, 8
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='fiverr-ops'),
  'SOP 08: Delivering to the Client', 'sop-08-delivery',
  $BODY$
Delivery is the moment the client sees the most, so handle it with care and finish every detail.

## Steps, in order
1. **Finish the quality check first.** Never deliver before you have done the full [quality check](/section/sop-07-quality-check). Delivery always comes after.
2. **Name the files.** Follow the [naming guide](/section/sop-09-file-naming).
3. **Put the package together.** Organise everything into a clear folder, with all the formats, the Drive link, and a ZIP if it suits.
4. **Upload to Google Drive.** Use the client's folder and set the sharing so they can open it without any trouble.
5. **Send the delivery message.** Keep it professional and in the brand's tone. Confirm what you are sending, add the Drive link and the ZIP, and let them know the Drive link works if the ZIP does not open.
6. **Update ClickUp.** Move it to Delivered and leave a remark with the date and what went out.
7. **Add a delivery remark.** Note the date, the time, what you sent, and the Drive link for the record.

> **Standard:** Every delivery message includes the Google Drive link and the ZIP, with this line: "If the ZIP file does not open, please use the Google Drive link, it is the same in both places."
$BODY$,
  array['csr','hr','pm','manager']::user_role[], false, 9
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='fiverr-ops'),
  'SOP 09: Naming Your Files', 'sop-09-file-naming',
  $BODY$
Naming files the same way every time keeps things from getting lost or mixed up. Every file you send or store follows this.

## The format
```
ClientName_ProjectName_ProfileExtension_Date.ext
```
Final file the client has approved, for example: `Ashyervanny_Cropmedia_AH2_25Jun2026.png`

## The rules
- No spaces in a file name. Use underscores instead.
- For revisions, put the version in: v1, v2, v3, and so on.
- Write the date like 25Jun2026.
- The extension always matches the real file type.
- Never write over an old version. Make a new file with the next version number.
$BODY$,
  array['csr','hr','pm','manager']::user_role[], false, 10
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

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
1. **Hold your reply.** Send nothing to the client until you have spoken to a Senior. A quick wrong reply can make things worse.
2. **Brief your Senior.** Give them a clear, factual summary: the client's message, the order, and the history.
3. **Follow their lead.** Wait for their direction and do exactly that.
4. **Write it down.** Add a remark noting that you escalated, when, which Senior, and what you agreed to do.

> **Rule:** Asking a Senior is never a weakness. It is the right move when a case is bigger than your call. Never take a sensitive case on alone.
$BODY$,
  array['csr','hr','pm','manager']::user_role[], false, 11
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

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
1. **Spot the fit.** While you look over their project, notice something that would genuinely add to it. A client getting a logo might also want a brand kit or a business card.
2. **Frame it as value.** For example: "Since we have already done your logo, we could make a matching business card so people remember your brand. Would that be useful?"
3. **Take the answer well.** If they pass, thank them and go back to delivering their order beautifully. Do not bring it up again unless they do.
4. **Log it.** Note in the remarks that you offered something and what they said.

> **Important:** The goal is a relationship that lasts, not a quick sale. A client who trusts us comes back again and again, and that is worth far more than any single add on.
$BODY$,
  array['csr','hr','pm','manager']::user_role[], false, 12
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='fiverr-ops'),
  'SOP 12: Looking After the Client Relationship', 'sop-12-client-relationships',
  $BODY$
Our relationships with clients are the most valuable thing we have, and you are the face of the company to them. Every chat should build trust.

## How we talk to clients
- Use the name they prefer.
- Be warm and professional. Never cold, rude, blunt, or too casual.
- Keep your word. If you say you will get back shortly, actually do, not the next day.
- Keep them posted without being asked. If a client has to chase you for an update, that is on the CSR who has their profile.
- If a deadline slips, tell them right away and say sorry properly. Never let a deadline pass in silence, and never let a message make us look careless. If a designer or anyone else made a mistake, that stays inside. You never put it on the client, because it reflects on all of us.

## Building something that lasts
- Put the client's success ahead of the single sale. People who feel looked after come back, every time.
- Remember the little things from past chats and bring them up when it fits.
- When a project wraps up, thank them honestly and invite them back, with no selling in your tone.
- Never push a client to leave a review or place another order before they are ready. Understand their problem, guide them well, and ask a Senior if you are stuck. Do not sell. Help. Show them value and you will see the difference.
$BODY$,
  array['csr','hr','pm','manager']::user_role[], false, 13
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='fiverr-ops'),
  'SOP 13: Cancellations and Upset Clients', 'sop-13-cancellations',
  $BODY$
A cancellation or a very upset client goes to a Senior straight away. A CSR is not allowed to cancel, refund, or promise anything here without a Senior saying so.

## What to do right away
1. **Acknowledge them.** Send a short, warm line at once. For example: "Thank you for letting us know. I completely understand your concern and I want to make sure this is sorted for you. I am passing it to our senior team now so they can look at your case and get back to you shortly."
2. **Promise nothing.** No refunds, discounts, or free revisions without a Senior's approval. Just reassure them it is being taken seriously.
3. **Bring in a Senior now.** Reach your Senior through the proper channel and give them the whole case: the client, the order number, the complaint, and the history.
4. **Follow their lead.** Do exactly what the Senior decides, and do not change course without checking again.
5. **Save it as a case study.** Once it is resolved, write down what happened, how it was handled, and how it ended. It makes you better at the next one.

> **Rule:** No CSR cancels an order or gives a refund on their own. Always escalate. Always.
$BODY$,
  array['csr','hr','pm','manager']::user_role[], false, 14
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='fiverr-ops'),
  'SOP 14: Your Daily Report', 'sop-14-daily-report',
  $BODY$
Every CSR sends a daily report to their Senior at the end of the shift. Keep it accurate, complete, and on time, every day.

## What goes in it
| Part | What to put |
| --- | --- |
| Queries handled | How many came in and how many you answered. Note any still open. |
| Orders assigned | Which orders went to designers, with the designer and the deadline. |
| Revisions assigned | Each revision, with its number and the deadline. |
| Deliveries made | Everything you sent out, with the client or order and the time. |
| ClickUp status | Confirm ClickUp is fully up to date for everything you handled. |
| Escalations | Anything you took to a Senior, with a short note and how it ended. |
| Pending items | Whatever is carrying over to the next shift, and why. |
| Personal notes | Your own honest read on the shift: what was hard, what you practised, what to improve. |

> **Rule:** The report reaches your Senior by the end of every shift, no exceptions. Reporting that is patchy or late is a performance issue.
$BODY$,
  array['csr','hr','pm','manager']::user_role[], false, 15
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

-- ===== CHAPTER 7 · Tools & Systems ==========================================

insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='tools'),
  'How We Use ClickUp', 'clickup-basics',
  $BODY$
ClickUp holds the real status of every order and task. Keep it accurate and current so everyone can rely on it.

## The one rule
> If it is not in ClickUp, it did not happen.

## The status labels
- **In Progress.** You are actively working on it.
- **Assigned to Designer.** Handed off, with the designer and the deadline.
- **Pending Client Feedback.** Waiting on the client.
- **Revision Sent.** A revision has gone out and you are waiting to hear back.
- **Delivered.** The final work is done.

## Habits that keep it clean
- Update at least once an hour, and before any break. See [SOP 03](/section/sop-03-clickup-updates).
- Every change gets a remark, what happened and what comes next. See [SOP 06](/section/sop-06-remarks).
- Match the incoming order numbers against the sheet and ClickUp.

> **Tip:** Before you leave your desk, take one minute to sweep through, every task in the right status with a current remark.
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
Every three months, the customer support team earns a bonus based on performance, not on sales. You are scored out of 100 on the things you actually control: how you show up, how you talk to clients, and how well you do the work.

> **Tip:** Your bonus is not tied to sales numbers. It is tied to how steady, professional, and careful you are.

## When it is reviewed
| Quarter | Period | Reviewed | Paid |
| --- | --- | --- | --- |
| Q1 | January to March | Last week of March | First week of April |
| Q2 | April to June | Last week of June | First week of July |
| Q3 | July to September | Last week of September | First week of October |
| Q4 | October to December | Last week of December | First week of January |

## The scorecard, out of 100
| Area | Points | What we look at |
| --- | --- | --- |
| Punctuality and attendance | 20 | On time sign in, breaks managed well, no unexplained absences, there through the shift. |
| Behaviour and professionalism | 15 | Respect for the team and Seniors, dress, a positive attitude, no disciplinary notes. |
| Work quality | 20 | Accurate ClickUp and sheet entries, correct file names, clear reports, checked before delivery. |
| Work execution | 15 | The right steps every time, orders and revisions assigned on time, proper escalation, nothing missed. |
| Client communication | 20 | Replies in five minutes, a warm and clear tone, understanding the brief, building real relationships. |
| Cancellation handling | 10 | Escalating cancellations quickly, not handling hard cases alone, following up on them. |

## How each area is scored
Your Senior scores each area on what they can actually see, not on opinion, using the same five levels:

| Rating | Score | What it means |
| --- | --- | --- |
| Excellent | 100% | Went above what we expected, all quarter. Set the example. |
| Good | 80% | Met it well, with only small slips that did not repeat. |
| Average | 60% | Met most of it. Clear places to improve. |
| Below average | 40% | Fell short often. Several issues over the quarter. |
| Poor | 0% | Did not meet it. Serious or repeated problems. |

## The bonus tiers
| Tier | Score | Bonus | Extra |
| --- | --- | --- | --- |
| Elite performer | 90 to 100 | Full bonus plus 10% | Written recognition and first in line for promotion |
| High performer | 75 to 89 | Full bonus | A word of recognition in the team meeting |
| Meets standard | 60 to 74 | Half bonus | A casual feedback session with your Senior |
| Below standard | 40 to 59 | No bonus | An improvement plan for next quarter |
| Unsatisfactory | Below 40 | No bonus | A formal review with HR |

## A worked example
Meet Sarah, who had a solid but not perfect quarter:

| Area | Max | Rating | Score | Senior's note |
| --- | --- | --- | --- | --- |
| Punctuality | 20 | Good | 16 | Late twice, otherwise steady. |
| Behaviour | 15 | Excellent | 15 | Lovely attitude. |
| Work quality | 20 | Good | 18 | A few early file naming slips. |
| Work execution | 15 | Excellent | 15 | Always followed the steps. |
| Client communication | 20 | Good | 18 | Strong relationships, missed the five minute reply three times. |
| Cancellation handling | 10 | Average | 8 | Handled one case alone instead of escalating. |
| Total | 100 | | 90 | High performer, full bonus |

Sarah's focus for next quarter is simple: always escalate the hard cancellations instead of solving them alone.

## Who is eligible
- At least two full months with us inside the quarter.
- No active written warning at review time. A formal warning takes 10 points off your total.
- No unexcused, unpaid absences during the quarter.
- Daily reports sent steadily, without big gaps.

## Our promise on fairness
- You get your full scorecard every quarter, area by area.
- You can talk your scores over with your Senior before they are final.
- Your Senior gives you feedback monthly, so the quarterly review never surprises you.
- The CEO reviews every score before any bonus is confirmed.
- If you think a score is wrong, you can raise it in writing within five working days.
$BODY$,
  array['csr','hr','pm','manager']::user_role[], false, 1
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;
