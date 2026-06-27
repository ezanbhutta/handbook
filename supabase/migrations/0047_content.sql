-- =============================================================================
-- HaseebMadeit Handbook — 0047 content (batch 39): ASR Playbook, SOPs 1-4
-- Add the first four ASR SOPs to the asr-playbook chapter, each in the standard
-- five-part shape (Why it matters · Tools and access · Steps · If something goes
-- wrong · Done right when). Grounded in the ASR role documentation. The remaining
-- SOPs, KPIs, report templates, and policies follow in later batches. Visible to
-- ASRs and their leads. Full re-upserts, idempotent by slug.
-- =============================================================================

-- ===== ASR SOP 1 =============================================================
insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='asr-playbook'),
  'ASR SOP 1: Account Setup and Maintenance', 'asr-sop-account-setup',
  $BODY$
## Why it matters
Every account carries the company's name, so it has to be set up properly and kept healthy from day one. A clean, complete profile with a funded payment method and an honest record in the Account Register Sheet is what keeps an account in good standing and ready to take orders.

## Tools and access you need
```keyvalue
Account Register Sheet | Where every account is logged and kept current.
Team Leader | Who hands you the account details and approves the account as ready.
Approved credentials | The only information and logins you may use to build a profile.
```

## Steps
```steps
Receive the account details | Get them from the Team Leader and verify they are complete before you start.
Create the account profile | Use only approved information and credentials.
Set up the payment method | Add it and verify the balance is sufficient before any order.
Complete the profile | Fill in the bio, portfolio samples, and every required field.
Log the account | Record the name, platform, date created, and status in the Account Register Sheet.
Run a test if applicable | Conduct a test run and verify everything is live and functional.
Report account-ready status | Tell the Team Leader the account is ready and send a screenshot to confirm.
Check account health weekly | Review ratings, warnings, and policy flags, and report any issue immediately.
```

## If something goes wrong
| If this happens | What to do |
| --- | --- |
| The account details are incomplete | Do not proceed. Confirm with the Team Leader first. |
| The account gets a warning, flag, or suspension | Report it immediately and escalate. See [ASR SOP 7: Escalation](/section/asr-sop-escalation). |
| You are unsure about credentials or information | Ask. Do not guess. |

## Done right when
```checklist
The account is live, complete, and logged in the Account Register Sheet.
The payment method is set up and the balance is sufficient.
The Team Leader has confirmed the account is ready, with a screenshot.
Account health is checked weekly and any issue is reported straight away.
```

> **Rule:** Any deviation from this SOP must be approved in advance by a Senior or Team Leader.
$BODY$,
  array['asr','hr','pm','manager']::user_role[], false, 2
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

-- ===== ASR SOP 2 =============================================================
insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='asr-playbook'),
  'ASR SOP 2: Order Placement and Management', 'asr-sop-order-placement',
  $BODY$
## Why it matters
Orders are the work itself, so each one has to be placed on time, tracked honestly, and checked before it is accepted. A clear brief, a funded account, and a live Order Tracker Sheet are what keep an order moving and protect both the account and the client.

## Tools and access you need
```keyvalue
Order Tracker Sheet | Where every order is logged and kept current.
The order brief | The details from the Team Leader or the CSR team that you work from.
Team Leader or CSR team | Who provide the brief and pick up client follow-up when it is needed.
```

## Steps
```steps
Receive the order brief | Get it from the Team Leader or the CSR team and confirm all details are clear.
Check the account balance | Confirm there are funds before placing, and top up if needed by following the payment SOP.
Place the order | Place it within the agreed time frame and screenshot the order confirmation.
Log the order | Record the order ID, account, date, amount, and deadline in the Order Tracker Sheet.
Monitor order progress | Follow up with the seller if there is no update within the expected time.
Review the delivery | Check it when it arrives and flag any quality issue to the Team Leader before accepting.
Accept and leave feedback | Accept the delivery and leave appropriate feedback as per the communication guidelines.
Update and notify | Set the order to Completed in the Order Tracker and notify the CSR team if client follow-up is needed.
```

## If something goes wrong
| If this happens | What to do |
| --- | --- |
| The balance is low | Top up by following the payment SOP. See [ASR SOP 4: Payment Handling](/section/asr-sop-payment). |
| The seller goes quiet | Follow up first, then escalate if there is still no update. See [ASR SOP 7: Escalation](/section/asr-sop-escalation). |
| The delivery has quality issues | Flag it to the Team Leader before accepting. Do not accept it. |

## Done right when
```checklist
The order was placed within the agreed time frame, with a screenshot of the confirmation.
The order is logged in the Order Tracker Sheet with the ID, account, date, amount, and deadline.
The delivery was reviewed and any quality issue was flagged before accepting.
The Order Tracker is updated to Completed and the CSR team is notified if follow-up is needed.
```

> **Rule:** Any deviation from this SOP must be approved in advance by a Senior or Team Leader.
$BODY$,
  array['asr','hr','pm','manager']::user_role[], false, 3
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

-- ===== ASR SOP 3 =============================================================
insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='asr-playbook'),
  'ASR SOP 3: Client and Seller Communication', 'asr-sop-communication',
  $BODY$
## Why it matters
Every message you send speaks for the company, so it has to be prompt, professional, and safe. Replying on time, keeping a polite tone, and never sharing anything off-platform are what protect the account and the relationship.

## Tools and access you need
```keyvalue
Daily Activity Sheet | Where important communications are logged.
Team Leader or Senior | Who set the response timeframes and review anything sensitive before it goes out.
The platform | The only place messages, pricing, and contact details may be shared.
```

## Steps
```steps
Read incoming messages | Read everything within 15 minutes of your shift start.
Respond on time | Reply to all messages within the timeframes set by the Team Leader.
Keep it professional | Use polite English at all times, with no informal language or slang.
Handle order questions carefully | Confirm details and do not make commitments that are not approved.
Hold back on complaints | For complaints or disputes, do not respond until the Team Leader or a Senior has reviewed it.
Get sensitive messages approved | Any outgoing message on a sensitive account must be approved before sending.
Log important messages | Record them in the Daily Activity Sheet.
Keep information on-platform | Never share personal information, company details, or pricing outside the platform.
```

## If something goes wrong
| If this happens | What to do |
| --- | --- |
| A complaint or dispute comes in | Do not reply until it has been reviewed, then escalate. See [ASR SOP 7: Escalation](/section/asr-sop-escalation). |
| You are unsure how to reply | Ask. Never guess. |
| You are asked for pricing or off-platform contact | Never share it outside the platform. |

## Done right when
```checklist
All incoming messages were read within 15 minutes of shift start.
Every reply was professional, on time, and within the approved limits.
Sensitive messages were reviewed and approved before they were sent.
Important communications are logged in the Daily Activity Sheet.
```

> **Rule:** Any deviation from this SOP must be approved in advance by a Senior or Team Leader.
$BODY$,
  array['asr','hr','pm','manager']::user_role[], false, 4
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

-- ===== ASR SOP 4 =============================================================
insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='asr-playbook'),
  'ASR SOP 4: Payment Handling', 'asr-sop-payment',
  $BODY$
## Why it matters
Money is the most sensitive part of the role, so every balance, top-up, and transaction has to be checked, recorded, and reported. Watching the balances, keeping a complete record, and never moving funds without approval are what keep the accounts funded and the company safe.

## Tools and access you need
```keyvalue
Account balances | Checked at the start of every shift against the Team Leader's threshold.
Senior or HR Manager | Who receive top-up requests and approve any movement of funds in writing.
Designated payment folder | Where every payment confirmation screenshot is filed.
```

## Steps
```steps
Check all balances | Review every account balance at the start of every shift.
Report a low balance fast | If a balance is below the Team Leader's threshold, report it immediately and do not wait.
Submit top-up requests | Send them to the Senior with the exact amount and account name.
Never move funds unapproved | Do not transfer funds between accounts without written approval from a Senior or the HR Manager.
Record every transaction | Note the date, amount, account, and purpose. No exceptions.
File the confirmations | Screenshot all payment confirmations and file them in the designated folder.
Report problems within 5 minutes | Tell the Team Leader about any failed or suspicious transaction within 5 minutes.
```

## If something goes wrong
| If this happens | What to do |
| --- | --- |
| A transaction fails or looks suspicious | Report it to the Team Leader within 5 minutes. |
| A balance is low | Report it immediately. Do not wait. |
| You are asked to move funds between accounts | Never do it without written approval from a Senior or the HR Manager. |

## Done right when
```checklist
All account balances were checked at the start of the shift.
Every transaction is recorded with the date, amount, account, and purpose.
All payment confirmations are screenshotted and filed in the designated folder.
Any low balance or failed transaction was reported straight away.
```

> **Rule:** Any deviation from this SOP must be approved in advance by a Senior or Team Leader.
$BODY$,
  array['asr','hr','pm','manager']::user_role[], false, 5
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;
