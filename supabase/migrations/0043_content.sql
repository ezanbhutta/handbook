-- =============================================================================
-- HaseebMadeit Handbook — 0043 content (batch 35): five-part SOP shape, part 1
-- Restructure SOP 01-04 into the standard shape so the whole playbook reads the
-- same way and can be followed without questions:
--   Why it matters · Tools and access · Steps · If something goes wrong · Done right.
-- Wording is preserved where it was already good; corrections are folded in:
-- SOP 03 uses the real ClickUp statuses; SOP 04 uses the real assign flow
-- (assignee + Pickup Your Projects, designer sets In Progress) and keeps the
-- client name off ClickUp. Full re-upserts, idempotent by slug.
-- =============================================================================

-- ===== SOP 01 =================================================================
insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='fiverr-ops'),
  'SOP 01: Client Profile Review and Order Management', 'sop-01-profile-review',
  $BODY$
## Why it matters
Before you reply to a client or touch an order, you read their profile and their history. Every client is a case of their own, and two minutes here saves most of the mistakes: the wrong style, a missed revision, or asking something they already told you.

## Tools and access you need
```keyvalue
Fiverr | The client's full profile, order history, briefs, and any Senior notes.
ClickUp | The live status of each of their orders.
Order Management Sheet | The client record and the order details.
```

## Steps
```steps
Open the profile | Look at the full profile before you say a word: their order history, past remarks, the briefs, and any notes a Senior left.
Read every remark | Get a real sense of what they like, what went wrong before, and where each of their orders stands today.
Check the active orders | For each one, know the stage it is at: Pickup Your Projects, In Progress, Deliver to Client, Client Response, Revision, Revision Complete, Final Files, or Complete.
Spot what is urgent | Notice what is close to a deadline, and flag anything stuck or overdue so it gets attention.
Check the brief | Make sure it is complete and clear. If anything is missing, sort it out with the client before you hand it to a designer.
```

## If something goes wrong
| If this happens | What to do |
| --- | --- |
| The brief is incomplete or unclear | Confirm the missing details with the client before any work starts. Never guess. |
| You find an order stuck or overdue | Flag it to the Project Manager straight away. |
| A Senior left a note you do not understand | Ask before you act, not after. |

## Done right when
```checklist
You have read the full profile, the history, and the remarks.
You know the stage of every active order.
Anything urgent or stuck has been flagged.
The brief is confirmed complete before anything goes to a designer.
```

> **Tip:** Two minutes on the profile saves you most of the mistakes. Start here every time.
$BODY$,
  array['csr','hr','pm','manager']::user_role[], false, 2
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

-- ===== SOP 02 =================================================================
insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='fiverr-ops'),
  'SOP 02: Reply Within Five Minutes', 'sop-02-query-5-min',
  $BODY$
## Why it matters
Every new client message gets a reply within five minutes. There is no exception to this. A slow reply makes us look unprofessional; a quick one, even a holding line, keeps the client confident we are on it.

```stats
5 min | Maximum reply time
0 | Exceptions
```

## Tools and access you need
```keyvalue
Fiverr and every channel | The inbox, chat, ClickUp, and anything else you watch, all shift.
Notifications | Turned on, so a new message never sits unseen.
Holding lines | Two or three ready replies so you always make the five minutes.
```

## Steps
```steps
Watch every channel | Keep an eye on email, chat, ClickUp, and anything else you have been given, the whole shift.
Answer within five minutes | Even if you do not have the full answer yet, let them know you have their message and you are looking into it.
Get the context | Pull up their profile and the order details so you understand the whole picture before you give a real answer.
Reply properly | Keep it clear, polite, and in the tone the brand expects.
Log it | Drop a short remark so anyone on the team can see what was asked and what you said.
```

## If something goes wrong
| If this happens | What to do |
| --- | --- |
| You cannot fully answer in time | Send a holding line inside five minutes, then come back as soon as you can. |
| You are mid-task on another order | Still send the quick line first. The five minutes comes before everything. |
| The question is sensitive or complex | Acknowledge it, promise nothing, and escalate before you reply in full. See [SOP 10](/section/sop-10-sensitive-cases). |

## Done right when
```checklist
Every message was acknowledged within five minutes.
A proper answer followed once you had the context.
The exchange is logged in a remark.
```

> **Tip:** Keep a holding line ready, like "Thanks for your message, I am looking into your case and will update you shortly," so you never miss the mark.
$BODY$,
  array['csr','hr','pm','manager']::user_role[], false, 3
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

-- ===== SOP 03 =================================================================
insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='fiverr-ops'),
  'SOP 03: Keep ClickUp Updated Every Hour', 'sop-03-clickup-updates',
  $BODY$
## Why it matters
ClickUp is the one place we all trust for the status of every order. Keep it current so Seniors, the Project Manager, and your teammates always know where things stand. If it is not in ClickUp, it did not happen.

## Tools and access you need
```keyvalue
ClickUp | Where you set the status and leave a remark, at least once an hour.
The status labels | The full list of statuses lives in How We Use ClickUp.
```

## Steps
```steps
Update every hour | Log in at least once an hour and update everything you are working on. Do not save it all for the end of the shift.
Update before you take on more | Never let unlogged updates pile up before you pick up the next task.
Update before a break | When you step away from the desk for any reason, leave nothing missing.
Use the right status | Pick the correct label: Pickup Your Projects, In Progress, Deliver to Client, Client Response, Revision, Revision Complete, Final Files, Complete, or Cancelled.
Add a remark | Each update should say what happened and what comes next. An update with no context is not enough.
```

## If something goes wrong
| If this happens | What to do |
| --- | --- |
| You are unsure which status fits | Check [How We Use ClickUp](/section/clickup-basics). If still unsure, ask the Project Manager. |
| Updates have piled up | Clear them now. Never let them stack before the next task. |
| A task is blocked | Set the status, leave a remark explaining the block, and flag the Project Manager. |

## Done right when
```checklist
Every task you touched is in the right status.
Each change has a remark with what happened and what comes next.
Nothing is left unlogged before your break or the end of your shift.
```

> **Rule:** If it is not in ClickUp, it did not happen. A task nobody can see is a task nobody can help you with.
$BODY$,
  array['csr','hr','pm','manager']::user_role[], false, 4
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

-- ===== SOP 04 =================================================================
insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='fiverr-ops'),
  'SOP 04: Giving Orders to Designers', 'sop-04-assign-designers',
  $BODY$
## Why it matters
Handing work to the design team is one of the most important things you do. A weak or late brief shows up straight away in the quality and in how the client feels.

## Tools and access you need
```keyvalue
ClickUp | Create the assignment, set the designer as assignee, and set the status.
The brief | The complete instructions to pass to the designer.
Your team channel | WhatsApp or chat, to reach the designer and the Project Manager.
```

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
Give the full picture | Include the order number, the deadline, the brief file, and a short note on anything the client is particular about.
Set the deadline | Our designers are monthly staff with fixed daily projects delivered inside their shift, so the work is already committed. Set the deadline; you do not need to chase a per-task agreement.
Put it in ClickUp | Add the designer as the assignee and leave the task in Pickup Your Projects. The designer sets In Progress when they start.
Sweep before you leave | Before you end your shift, check that every pending order has been assigned. Nothing should be left hanging.
```

## If something goes wrong
| If this happens | What to do |
| --- | --- |
| The brief is missing something | Do not assign. Get the missing piece from the client first. See [SOP 01](/section/sop-01-profile-review). |
| The designer is late or unavailable | Tell the Project Manager straight away, on any channel. |
| There is more work than capacity | Raise it with the Project Manager to balance the load. |

## Done right when
```checklist
The brief was complete before you assigned it.
The designer is set as the assignee, with the order number, deadline, and brief.
The task is in Pickup Your Projects, and the client name is not on ClickUp.
Every pending order is assigned before you leave.
```

> **Rule:** Never hand a half finished brief to a designer. It wastes their time, slows the delivery, and hurts the client relationship.
$BODY$,
  array['csr','hr','pm','manager']::user_role[], false, 5
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;
