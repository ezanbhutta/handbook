-- =============================================================================
-- HaseebMadeit Handbook, 0025 content (batch 17)
-- Policy change: unlimited revisions in every package. Update the client-facing
-- policy (replaces "set number of revisions / add-ons") and reinforce it in the
-- revisions SOP. New concepts or extra scope remain paid add ons. Idempotent.
-- =============================================================================

insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='delivery-qa'),
  'Working With Clients', 'client-facing-policies',
  $BODY$
## Talking to clients
- Reply within 5 to 10 minutes, depending on the service tier.
- Use approved channels only (ClickUp, WhatsApp).
- Do not send progress updates without management approval.
- Revision requests must be clear and doable. Vague feedback is not accepted, so ask the client to clarify.

## Revisions
Every package comes with unlimited revisions. We keep refining a design until the client is genuinely happy with it.

- There is no cap on revision rounds in any package. We would rather get it right than rush a client off.
- A revision means adjusting work we already agreed on, not a brand new concept or a change of scope. New concepts and extra scope are still paid add ons.
- Keep each revision request clear and specific, and turn it around quickly, usually within 3 to 6 hours a round.

> **Key principle:** Unlimited revisions are about quality and a long relationship, not the single sale. A client who feels heard and looked after comes back again and again, and that is worth far more than any one order.

## Scope and add ons
- A package includes only the items listed in the package or proposal.
- Extra concepts, layouts, versions, or formats are paid add ons.
- Add ons are agreed and charged before the work begins.

## Portfolio
- Only high quality, strategy backed projects go in the portfolio.
- Weak, client directed designs are left out by default.
- Written client approval is needed before adding their work.
- Strategy documents stay HaseebMadeit property unless the client buys them.
$BODY$,
  array['csr','asr','hr','pm','manager','office_boy']::user_role[], false, 3
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='fiverr-ops'),
  'SOP 05: Revisions and Tracking Them', 'sop-05-revisions',
  $BODY$
Treat a revision with the same care as a new order. Log it clearly, assign it fast, and follow it until it is done.

> **Standard:** Every package includes unlimited revisions. We keep refining until the client is genuinely happy. This is about quality and a lasting relationship, not the sale. A revision adjusts work we already agreed on. A brand new concept or a change of scope is a paid add on.

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
