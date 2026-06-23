-- =============================================================================
-- HaseebMadeit Handbook — 0045 content (batch 37): five-part SOP shape, part 3
-- Restructure SOP 10-14 into the standard shape so the whole playbook reads the
-- same way and can be followed without questions:
--   Why it matters · Tools and access · Steps · If something goes wrong · Done right.
-- Wording is preserved where it was already good; the special callouts, the kept
-- lists, the example-message dodont block, and the daily-report table all carry
-- forward. Canonical facts are folded in: real ClickUp statuses, a Cancelled task
-- only on a Senior's call, and delivery as a ZIP by default with a company Drive
-- link only if needed. Full re-upserts, idempotent by slug.
-- =============================================================================

-- ===== SOP 10 ================================================================
insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='fiverr-ops'),
  'SOP 10: Handling Sensitive or Confusing Cases', 'sop-10-sensitive-cases',
  $BODY$
## Why it matters
Not every case is simple. When one is sensitive, complicated, or unclear, talk to your Senior before you act. A quick wrong reply can make things worse and is hard to take back. Do not guess, and do not carry it alone.

## When to bring in a Senior
```checklist
The client is upset, angry, or unhappy with the work.
They are asking to cancel or want a refund.
The brief is very complex, or it clashes with what they said earlier.
There is any legal, ethical, or reputation risk in it.
You are not sure how to reply without making it worse.
It is simply beyond your experience or what you are allowed to decide.
```

## Tools and access you need
```keyvalue
Fiverr | The client's message, the order, and the full history behind it.
ClickUp | The current status of the order and a place to log that you escalated.
WhatsApp or your team channel | To reach your Senior quickly through the proper channel.
```

## Steps
```steps
Hold your reply | Send nothing to the client until you have spoken to a Senior. A quick wrong reply can make things worse.
Brief your Senior | Give them a clear, factual summary: the client's message, the order, and the history.
Follow their lead | Wait for their direction and do exactly that.
Write it down | Add a remark noting that you escalated, when, which Senior, and what you agreed to do.
```

## If something goes wrong
| If this happens | What to do |
| --- | --- |
| You are not sure whether a case counts as sensitive | Treat it as if it does and check with a Senior. It is never wrong to ask. |
| The client pushes for an answer while you wait | Reassure them it is being looked at, promise nothing, and do not reply in full until the Senior has guided you. |
| It involves a cancellation or refund | Do not agree to anything yourself. Escalate, and follow the cancellation flow. See [SOP 13](/section/sop-13-cancellations). |

## Done right when
```checklist
You held your reply until a Senior had guided you.
The Senior had the full, factual picture.
You followed their direction exactly.
The escalation is logged in a remark, with the Senior and what was agreed.
```

> **Rule:** Asking a Senior is never a weakness. It is the right move when a case is bigger than your call. Never take a sensitive case on alone.
$BODY$,
  array['csr','hr','pm','manager']::user_role[], false, 11
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

-- ===== SOP 11 ================================================================
insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='fiverr-ops'),
  'SOP 11: Offering Extra Services', 'sop-11-upselling',
  $BODY$
## Why it matters
Suggest extra services only when they genuinely help the client, and always with value, never with pressure. A good suggestion at the right moment is a service to the client; pushing for a sale is not. Never beg for a sale.

## How we think about it
```checklist
Only suggest something that really fits what they are working on.
Lead with what it does for them, not what it earns for us.
One good suggestion is fine. Repeating it after they say no is not.
Timing matters. The moment to suggest more is when they are happy with the work, never in the middle of a problem.
```

## Tools and access you need
```keyvalue
Fiverr | The brief and the project, so you can see what would genuinely add to it.
ClickUp | A place to leave a remark on what you offered and what they said.
```

## Steps
```steps
Spot the fit | While you look over their project, notice something that would genuinely add to it. A client getting a logo might also want a brand kit or a business card.
Frame it as value | For example, since we have already done your logo, we could make a matching business card so people remember your brand. Would that be useful?
Take the answer well | If they pass, thank them and go back to delivering their order beautifully. Do not bring it up again unless they do.
Log it | Note in the remarks that you offered something and what they said.
```

## If something goes wrong
| If this happens | What to do |
| --- | --- |
| Nothing extra genuinely fits | Then suggest nothing. A forced add on costs more trust than it earns. |
| The client says no | Thank them and go back to delivering the order beautifully. Do not raise it again. |
| The client is mid-problem or unhappy | Hold the suggestion. Sort the problem first; the timing is wrong. |

## Done right when
```checklist
Anything you suggested genuinely fitted what they were working on.
You led with the value to them, not what it earns us.
You took a no gracefully and did not raise it again.
What you offered and what they said is logged in the remarks.
```

> **Important:** The goal is a relationship that lasts, not a quick sale. A client who trusts us comes back again and again, and that is worth far more than any single add on.
$BODY$,
  array['csr','hr','pm','manager']::user_role[], false, 12
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

-- ===== SOP 12 ================================================================
insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='fiverr-ops'),
  'SOP 12: Looking After the Client Relationship', 'sop-12-client-relationships',
  $BODY$
## Why it matters
Our relationships with clients are the most valuable thing we have, and you are the face of the company to them. Every chat should build trust. A client who feels looked after comes back; one who feels like a number does not.

## How we talk to clients
```checklist
Use the name they prefer.
Be warm and professional. Never cold, rude, blunt, or too casual.
Keep your word. If you say you will get back shortly, actually do, not the next day.
Keep them posted without being asked. If a client has to chase you for an update, that is on the CSR who has their profile.
If a deadline slips, tell them right away and apologise properly. A designer's or anyone's mistake stays inside, never put on the client.
```

## Tools and access you need
```keyvalue
Fiverr | Every conversation with the client, in their own thread.
The Order Management Sheet | The client name and the order details, so you always speak from the full picture.
ClickUp | The live status of their orders, so your updates are accurate.
```

## Steps
```steps
Open with warmth | Greet them by the name they prefer and reply in a tone that is warm and professional, never cold or too casual.
Keep them posted | Send updates without being asked, so they never have to chase you for one.
Keep your word | If you promised an update shortly, send it shortly. If a deadline slips, tell them at once and apologise.
Protect the inside | Keep any internal mistake inside the team. The client hears an apology and a plan, never the blame.
Close it well | When the project wraps, thank them genuinely and invite them back, with no selling tone.
```

## Example messages
```dodont
First reply to a new client | Hi [Name], thank you for reaching out to HaseebMadeit. I have your message and am reviewing your requirements right now. I will come back to you with a full response shortly. | ok noted. will check and reply.
A progress update while work is on | Hi [Name], a quick update. Your project is with our design team and on track for delivery by [date and time]. We will send it over as soon as it is ready. | Still working on it.
Delivering finished work | Hi [Name], great news, your [project name] is ready. I have sent everything as a ZIP. If the ZIP does not open, please use the Google Drive link, it is the same in both places. Please review and let us know your thoughts. | Here are your files.
When a deadline cannot be met | Hi [Name], I want to be open with you. Because of [brief reason], we need an extra [time] to make sure your work meets our quality standard. We are sorry for this and appreciate your patience. Your updated delivery time is [new time]. | Sorry for the delay, we will send it soon.
Closing message when a project is done | Hi [Name], it has been a pleasure working on your project. I hope you are delighted with the result. If you ever need anything in future, new designs, revisions, or new projects, we are always here. Thank you for choosing HaseebMadeit. | Done. Let us know if you need anything else.
```

## If something goes wrong
| If this happens | What to do |
| --- | --- |
| A deadline is going to slip | Tell the client right away and apologise. Never let a deadline pass in silence. |
| A designer or teammate made a mistake | Keep it inside. The client hears an apology and a plan, never the blame. |
| The client is upset or asking to cancel | Acknowledge warmly, promise nothing, and escalate to a Senior. See [SOP 13](/section/sop-13-cancellations). |

## Done right when
```checklist
You used the client's preferred name and kept a warm, professional tone.
They were kept posted without having to chase you.
Any internal mistake stayed inside, with only an apology and a plan shown to the client.
The project closed with genuine thanks and no pushy review or sales ask.
```

> **Standard:** Every message is a direct reflection of the brand. Write each one as if the CEO will read it. Be warm, clear, and professional, always.

## Building relationships that last
```checklist
Put the client's success ahead of the single sale. People who feel looked after come back, every time.
Remember the little things from past chats and bring them up when it fits.
When a project wraps up, thank them genuinely and invite them back, with no selling tone.
Never pressure a client to leave a review or place a new order before they are ready.
```
$BODY$,
  array['csr','hr','pm','manager']::user_role[], false, 13
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

-- ===== SOP 13 ================================================================
insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='fiverr-ops'),
  'SOP 13: Cancellations and Upset Clients', 'sop-13-cancellations',
  $BODY$
## Why it matters
A cancellation or a very upset client goes to a Senior straight away. These cases affect the client, the money, and our reputation all at once, so they are never a CSR's to settle alone. A CSR is not allowed to cancel, refund, or promise anything here without a Senior saying so.

## Tools and access you need
```keyvalue
Fiverr | The client's message, the order number, the complaint, and the full history.
ClickUp | Where the task moves to Cancelled, but only on the Senior's decision.
WhatsApp or your team channel | To reach a Senior at once through the proper channel.
```

## Steps
```steps
Acknowledge them | Send a short, warm line at once that says you understand their concern and are passing it to the senior team to look at and come back shortly.
Promise nothing | No refunds, discounts, or free revisions without a Senior's approval. Just reassure them it is being taken seriously.
Bring in a Senior now | Reach your Senior through the proper channel and give them the whole case: the client, the order number, the complaint, and the history.
Follow their lead | Do exactly what the Senior decides, and do not change course without checking again.
Move it only on their call | In ClickUp the task goes to Cancelled only once the Senior has made that decision, never before.
Save it as a case study | Once it is resolved, write down what happened, how it was handled, and how it ended. It makes you better at the next one.
```

## If something goes wrong
| If this happens | What to do |
| --- | --- |
| The client demands an immediate refund or cancellation | Promise nothing. Reassure them it is with the senior team and escalate at once. |
| You cannot reach a Senior right away | Keep the client reassured, promise nothing, and keep trying every channel until you reach one. |
| The case is also sensitive or unclear | Treat it with the same care and escalate. See [SOP 10](/section/sop-10-sensitive-cases). |

## Done right when
```checklist
The client was acknowledged at once with a short, warm line.
Nothing was promised without a Senior's approval.
A Senior had the whole case and you followed their lead exactly.
The task went to Cancelled only on the Senior's decision, and the resolved case is saved as a case study.
```

> **Standard:** A good first line is, "Thank you for letting us know. I completely understand your concern and I want to make sure this is sorted for you. I am passing it to our senior team now so they can look at your case and get back to you shortly."

> **Rule:** No CSR cancels an order or gives a refund on their own. Always escalate. Always.
$BODY$,
  array['csr','hr','pm','manager']::user_role[], false, 14
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

-- ===== SOP 14 ================================================================
insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='fiverr-ops'),
  'SOP 14: Your Daily Report', 'sop-14-daily-report',
  $BODY$
## Why it matters
Every CSR sends a daily report to their Senior at the end of the shift. It is how a Senior sees the whole shift at a glance, picks up anything still open, and keeps the next shift moving. Keep it accurate, complete, and on time, every day.

## Tools and access you need
```keyvalue
ClickUp | The status of everything you handled, so the report matches reality.
The Order Management Sheet | The order details behind your queries, assignments, and deliveries.
Your reporting channel | Where the finished report goes to your Senior at the end of the shift.
```

## What goes in it
| Part | What to put |
| --- | --- |
| Queries handled | How many came in and how many you answered. Note any still open. |
| Orders assigned | Which orders went to designers, with the designer and the deadline. |
| Revisions assigned | Each revision, with its number and the deadline. |
| Deliveries made | Everything you sent out, with the order and the time. |
| ClickUp status | Confirm ClickUp is fully up to date for everything you handled. |
| Escalations | Anything you took to a Senior, with a short note and how it ended. |
| Pending items | Whatever is carrying over to the next shift, and why. |
| Personal notes | Your own honest read on the shift: what was hard, what you practised, what to improve. |

## Steps
```steps
Bring ClickUp up to date | Before you write a word, make sure ClickUp is current for everything you touched. The report should match it exactly.
Gather the shift | Pull together your queries, assignments, revisions, and deliveries from the order details.
Fill every part | Work down the table above so nothing is left out, including escalations, pending items, and your own honest notes.
Send it on time | Get the finished report to your Senior by the end of the shift, through the proper channel.
```

## If something goes wrong
| If this happens | What to do |
| --- | --- |
| You are running short on time | Send it complete and on time anyway. A patchy or late report is a performance issue. |
| ClickUp is behind | Update ClickUp first, then report. The two must match. |
| Something is carrying over to the next shift | Put it under pending items with a short note on why, so nothing is lost. |

## Done right when
```checklist
ClickUp was brought up to date before the report was written.
Every part of the table is filled, including escalations and pending items.
Your honest personal notes on the shift are included.
The report reached your Senior by the end of the shift.
```

> **Rule:** The report reaches your Senior by the end of every shift, no exceptions. Reporting that is patchy or late is a performance issue.
$BODY$,
  array['csr','hr','pm','manager']::user_role[], false, 15
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;
