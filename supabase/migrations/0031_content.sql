-- =============================================================================
-- HaseebMadeit Handbook — 0031 content (batch 23): placement & ordering
-- Housekeeping only — no body changes:
--   1. Move "HR Manager: Role & Responsibilities" into the "Your Role" chapter,
--      alongside the other per-role descriptions (CSR, Senior CSR, ASR, PM).
--      Scope its visibility to hr/pm/manager to match how those role sections
--      are scoped (the role itself plus management), instead of all roles.
--   2. Fix a pre-existing order_index collision inside "Your Role" (Senior CSR
--      and ASR were both at 2) and slot the HR role in at the end.
--   3. Reorder the Welcome chapter so the company foundations (Mission/Vision,
--      What We Do) sit right under the welcome greeting, and resolve a stale
--      order_index collision there (How to Use / The Design Team both at 3).
-- Pure metadata updates, idempotent.
-- =============================================================================

-- 1) Relocate + rescope the HR role section into "Your Role" ------------------
update sections
   set chapter_id   = (select id from chapters where slug='your-role'),
       order_index  = 5,
       allowed_roles = array['hr','pm','manager']::user_role[]
 where slug = 'hr-manager-role';

-- 2) Tidy ordering inside "Your Role" ----------------------------------------
-- 1 The CSR Role / 2 The Senior CSR Role  (both unchanged)
update sections set order_index = 3 where slug = 'role-asr';   -- was colliding at 2
update sections set order_index = 4 where slug = 'role-pm';    -- was 3
-- 5 HR Manager: Role & Responsibilities (set above)

-- 3) Reorder the Welcome chapter ---------------------------------------------
-- 1 Welcome to HaseebMadeit (unchanged)
update sections set order_index = 2 where slug = 'mission-vision-values';
update sections set order_index = 3 where slug = 'what-we-do';
update sections set order_index = 4 where slug = 'company-hierarchy';
update sections set order_index = 5 where slug = 'design-team';
update sections set order_index = 6 where slug = 'how-to-use';
update sections set order_index = 7 where slug = 'about-these-policies';
