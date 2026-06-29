-- =============================================================================
-- HaseebMadeit Handbook — 0052 content (batch 42): leave policy, emergency vs medical
-- Two refinements: medical leave (3/year) is fully separate and never counts
-- against casual or annual; emergency leave is NOT separate, it falls under
-- casual leave and therefore counts against the annual allowance. Moves
-- "emergency" out of the separate-allowance lists. Targeted, idempotent
-- replace() updates matching the current live text (post batches 40-41).
-- =============================================================================

-- A) intro line of "How the leave types work together"
update sections set body = replace(body,
$o$Your monthly casual leave and your annual leave share one pool. Medical, marriage, emergency, and half day leave are separate allowances of their own.$o$,
$n$Your monthly casual leave and your annual leave share one pool, and emergency leave falls under your casual leave. Medical, marriage, and half day leave are separate allowances of their own.$n$)
where slug = 'leave-policy';

-- B) the separate-allowances bullet, plus a new emergency bullet
update sections set body = replace(body,
$o$- Medical, marriage, emergency, and half day leave are their own separate allowances. Taking them does not reduce your annual leave.$o$,
$n$- Medical, marriage, and half day leave are their own separate allowances. Taking them does not reduce your annual leave, and your 3 medical days a year never count against your casual leave.
- Emergency leave is not a separate allowance. It falls under your casual leave, so it counts against your annual leave just as a casual leave does.$n$)
where slug = 'leave-policy';

-- C) the summary Rule
update sections set body = replace(body,
$o$Casual leave comes out of your annual allowance; medical, marriage, emergency, and half day leave do not reduce any other allowance.$o$,
$n$Casual leave, and any emergency leave taken under it, comes out of your annual allowance; medical, marriage, and half day leave do not reduce any other allowance.$n$)
where slug = 'leave-policy';

-- D) the Emergency leave section
update sections set body = replace(body,
$o$Paid emergency leave may be granted for genuine, urgent situations such as family emergencies, accidents, or unexpected medical needs. It is subject to checking, and you should provide supporting documents where you can. The company decides whether to grant it.$o$,
$n$Paid emergency leave may be granted for genuine, urgent situations such as family emergencies, accidents, or unexpected medical needs. It is subject to checking, and you should provide supporting documents where you can. The company decides whether to grant it. Emergency leave falls under your casual leave, so it counts against your annual leave just as a casual leave does.$n$)
where slug = 'leave-policy';

-- E) the Medical leave section
update sections set body = replace(body,
$o$3 working days of paid medical leave per calendar year. Tell the company in good time and, where asked, give a medical certificate from a registered doctor.$o$,
$n$3 working days of paid medical leave per calendar year, and these do not count against your casual or annual leave. Tell the company in good time and, where asked, give a medical certificate from a registered doctor.$n$)
where slug = 'leave-policy';
