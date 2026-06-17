-- =============================================================================
-- HaseebMadeit Handbook, 0009 content (batch 3)
-- A short FAQ for Chapter 11, drawn straight from the SOPs (no new policy).
-- Plain human voice. Idempotent upsert by slug.
-- =============================================================================

insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='faq'),
  'Frequently Asked Questions', 'faq-common',
  $BODY$
Quick answers to the things people ask most. Each one points to the full page if you want the detail.

## How fast should I reply to a client?
Within five minutes, every time. Even if you do not have the full answer yet, send a quick line so they know you are on it. See [SOP 02](/section/sop-02-query-5-min).

## Where do I check the status of an order?
In ClickUp. It is the one place we all trust, so keep it updated every hour. See [How We Use ClickUp](/section/clickup-basics).

## A client wants to cancel, or they are upset. What do I do?
Pass it to a Senior straight away, and promise nothing on your own. See [SOP 13](/section/sop-13-cancellations).

## Can I send a delivery before checking it?
No. Every delivery goes through the quality check first, first draft or revision. See [SOP 07](/section/sop-07-quality-check).

## I am not sure how to handle a case. What now?
Ask your Senior. It is always the right move, and it is never a weakness. See [SOP 10](/section/sop-10-sensitive-cases).

> **Tip:** Got a question that should live here? Tell your Senior and we will add it.
$BODY$,
  array['csr','hr','pm','manager']::user_role[], false, 2
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;
