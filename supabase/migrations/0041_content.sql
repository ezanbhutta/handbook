-- =============================================================================
-- HaseebMadeit Handbook — 0041 content (batch 33): the deliverables standard
-- Make the main points the user stressed fully informative, not one-liners:
--   * Designer SOPs gain a proper "What we deliver" standard — every format AND
--     every colour variation (full-colour, colour-background variations, and the
--     monochrome black-and-white versions), with/without background spelled out.
--   * SOP 07 quality check is rewritten to verify every format and every colour
--     variation, and to use the real delivery rule (ZIP holds the full set; a
--     company Drive link only if needed; the client does not share a Drive),
--     replacing the stale "send both the Drive link and the ZIP" wording.
-- Designer SOPs edit is a targeted replace; SOP 07 is a full, idempotent re-upsert.
-- =============================================================================

-- ---- Designer SOPs: split naming from a full deliverables standard
update sections set body = replace(body,
$o$## File naming and formats
"Proper naming" means one consistent pattern, every single time:

```keyvalue
Pattern | ClientName_ProjectType_Version_Date
Example | AhmadBrand_Logo_v2_2024-01-15
Formats | Deliver every agreed format — AI, EPS, SVG, PNG, JPEG, and PDF — with SVG and PDF supplied both with and without a background, all at the right resolution
Storage | Keep every final source file in the company drive, never only on your own machine
```$o$,
$n$## File naming
"Proper naming" means one consistent pattern, every single time:

```keyvalue
Pattern | ClientName_ProjectType_Version_Date
Example | AhmadBrand_Logo_v2_2024-01-15
Storage | Keep every final source file in the company drive, never only on your own machine
```

## What we deliver
Every final package carries the full set: every format, and every colour variation. Never hand over a partial set.

**Formats**
- AI and EPS, the editable source files.
- SVG, with a background and without it (transparent).
- PNG and JPEG, at the right resolution.
- PDF, with a background and without it.

**Colour variations**
- The full-colour version.
- The colour-background variations.
- The monochrome, black and white versions.

> **Standard:** If a single format or colour variation is missing, the package is not ready. The CSR confirms the full set at the quality check before anything is delivered.$n$)
where slug = 'designer-sops';

-- ---- SOP 07: rewrite the quality check (formats + colour variations + ZIP/company drive)
insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='fiverr-ops'),
  'SOP 07: Quality Check Before Delivery', 'sop-07-quality-check',
  $BODY$
No design goes to a client, first draft or revision, until you have checked it yourself. This step is not optional.

## The checklist

```checklist
The design matches the brief in style, colour, size, and format.
Every bit of text is right. No spelling mistakes, no wrong names, no wrong numbers on the concepts.
The brand colours, fonts, and assets are what the client asked for. If not, send it back for a revision.
Every format is present: AI, EPS, SVG, PNG, JPEG, and PDF, with SVG and PDF both with and without a background.
Every colour variation is present: the full-colour version, the colour-background variations, and the monochrome black and white versions.
For a revision, every single point the client raised is done and checked by you.
The file name follows our naming convention.
The ZIP opens cleanly and holds the complete set.
A Drive link is included only if it is needed, and then it is from the company Drive, live and open. The client does not share a Drive.
No watermarks, guides, crop marks, or stray bits in the files you send.
The work looks professional, not rushed.
```

Naming follows [SOP 09](/section/sop-09-file-naming); the full set is the deliverables standard the designers work to.

> **Rule:** If even one of these fails, the file goes back to the designer before it leaves. No exceptions, not for a tight deadline, not for anything. The brand image is everything.
$BODY$,
  array['csr','hr','pm','manager']::user_role[], false, 8
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;
