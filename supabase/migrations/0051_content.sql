-- =============================================================================
-- HaseebMadeit Handbook — 0051 content (batch 41): leave policy follow-up
-- The leave-policy summary Rule still said approved leave "does not reduce any
-- other allowance", which now contradicts batch 40 (casual leave draws down
-- annual). Bring that one line in line with the corrected policy.
-- Targeted, idempotent replace() on the leave-policy section.
-- =============================================================================

update sections set body = replace(body,
$o$> **Rule:** Leave is only unpaid or deducted when it is unapproved, when a second casual leave in a month is not specially approved, when it falls under the sandwich rule, or during your notice period. Approved leave inside each allowance is paid, and it does not reduce any other allowance.$o$,
$n$> **Rule:** Leave is only unpaid or deducted when it is unapproved, when a second casual leave in a month is not specially approved, when it falls under the sandwich rule, or during your notice period. Approved leave is paid. Casual leave comes out of your annual allowance; medical, marriage, emergency, and half day leave do not reduce any other allowance.$n$)
where slug = 'leave-policy';
