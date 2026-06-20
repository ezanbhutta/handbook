-- =============================================================================
-- HaseebMadeit Handbook — 0033 content (batch 25): fix a rename false positive
-- The 0032 "Team Leader -> Manager" rename matched a lowercase "team leads" in
-- the designer overview that was a verb ("the project management team leads how
-- work flows"), not the role noun, leaving the broken "The project management
-- managers how work flows". Restore a grammatical sentence. Idempotent and
-- scoped to the one affected phrase.
-- =============================================================================

update sections
set body = replace(
  body,
  'The project management managers how work flows from here, and they keep a close eye on quality and timing.',
  'The project management team directs how work flows from here, and they keep a close eye on quality and timing.'
)
where body like '%project management managers how work%';
