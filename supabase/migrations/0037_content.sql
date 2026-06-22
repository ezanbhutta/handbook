-- =============================================================================
-- HaseebMadeit Handbook — 0037 content (batch 29): correct the deliverable formats
-- The agency delivers: AI, EPS, SVG (with and without background), PNG, JPEG,
-- and PDF (with and without background). Update the canonical Formats spec in
-- the Designer SOPs, plus the two illustrative format lists (SOP 07 quality
-- check and the order lifecycle), to match — dropping PSD and adding EPS, SVG,
-- and JPEG, and noting the with/without-background variants for SVG and PDF.
-- Targeted, idempotent string replacements; no section bodies are restated.
-- =============================================================================

-- 1. Canonical spec: Designer SOPs, "File naming and formats" keyvalue row.
update sections set body = replace(body,
  'Formats | Deliver in the agreed formats — AI, PSD, PDF, PNG — at the right resolution',
  'Formats | Deliver every agreed format — AI, EPS, SVG, PNG, JPEG, and PDF — with SVG and PDF supplied both with and without a background, all at the right resolution')
where slug = 'designer-sops';

-- 2. SOP 07 quality check: the "saved in the format the client wanted" line.
update sections set body = replace(body,
  'The file is saved in the format the client wanted, whether PNG, PDF, AI, or PSD.',
  'The file is saved in every format the client asked for — AI, EPS, SVG, PNG, JPEG, or PDF — including the with-background and without-background versions where they apply.')
where slug = 'sop-07-quality-check';

-- 3. Order lifecycle: the "Final Files" preparation bullet.
update sections set body = replace(body,
  '- Prepare every format the client asked for: PNG, PDF, AI, PSD, and so on.',
  '- Prepare every format the client asked for — AI, EPS, SVG, PNG, JPEG, and PDF — including the with-background and without-background versions of SVG and PDF.')
where slug = 'order-lifecycle';
