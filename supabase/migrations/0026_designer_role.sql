-- =============================================================================
-- HaseebMadeit Handbook, 0026 — add the Designer role
-- Isolated in its own migration so the new enum value is committed before any
-- later migration uses it (Postgres will not let a new enum value be used in
-- the same transaction that adds it).
-- =============================================================================

alter type user_role add value if not exists 'designer';
