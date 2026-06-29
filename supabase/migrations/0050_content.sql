-- =============================================================================
-- HaseebMadeit Handbook — 0050 content (batch 40): leave policy correction
-- Correct the relationship between monthly casual leave and annual leave: a
-- monthly casual leave is automatically deducted from the annual allowance, and
-- once all monthly casual leaves are used, no further annual leave is allowed.
-- This reverses the earlier "each allowance is separate" wording for casual vs
-- annual. Medical, marriage, emergency, and half-day leave stay separate.
-- Targeted, idempotent replace() updates on the leave-policy section.
-- =============================================================================

-- 1) "How the leave types work together" — casual now draws down annual.
update sections set body = replace(body,
$o$## How the leave types work together
Each kind of leave is its own separate allowance. Using one does not eat into another. Your 14 annual days stay yours no matter how many casual or medical days you have taken in the same year.

- Casual leave is a monthly allowance, 1 a month. It is separate from your annual leave and never comes out of it. Unused casual leave does not roll into your annual balance either.
- Medical, marriage, and emergency leave are their own separate allowances too. Taking them does not reduce your annual leave.
- Annual leave is the yearly allowance you plan ahead for. It is the one you give the long notice for.

> **Example:** Say you take your 1 casual leave in June, then 2 medical days later in the year. Your annual leave is untouched. You still have all 14 annual days to apply for, on their own.$o$,
$n$## How the leave types work together
Your monthly casual leave and your annual leave share one pool. Medical, marriage, emergency, and half day leave are separate allowances of their own.

- Casual leave is your monthly allowance, 1 a month, and it comes straight out of your annual leave. Every casual leave you take is automatically deducted from your annual days, and once you have used all of your monthly casual leaves, you cannot take any further annual leave that year.
- Medical, marriage, emergency, and half day leave are their own separate allowances. Taking them does not reduce your annual leave.
- Annual leave is the yearly allowance you plan ahead for, and it is what your monthly casual leaves draw down.

> **Example:** Say you take a casual leave in June. That day comes straight off your annual balance. If you then take 2 medical days later in the year, those are separate and do not touch your annual leave. But if you have already used up your monthly casual leaves for the year, you cannot apply for annual leave on top.$n$)
where slug = 'leave-policy';

-- 2) Annual leave — state the deduction and the block up front.
update sections set body = replace(body,
$o$- Apply to HR 15 to 30 days in advance, with approval from Operations and HR.$o$,
$n$- Your monthly casual leaves come out of this allowance automatically, and once you have used all of them, you cannot take any further annual leave.
- Apply to HR 15 to 30 days in advance, with approval from Operations and HR.$n$)
where slug = 'leave-policy';

-- 3) Casual leave — note the automatic deduction from annual.
update sections set body = replace(body,
$o$- 1 casual leave per month, with prior notice.$o$,
$n$- 1 casual leave per month, with prior notice. Each one is deducted from your annual leave allowance automatically.$n$)
where slug = 'leave-policy';
