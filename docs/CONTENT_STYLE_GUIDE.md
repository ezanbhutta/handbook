# HaseebMadeit Handbook — Content & Formatting Style Guide

How we write and structure every section. Grounded in how the best in the world
do it: GOV.UK content design, Nielsen Norman Group eye-tracking research, the
GitLab handbook, and Google's developer documentation style guide (sources at the
bottom). The goal: staff find the answer in seconds, on a phone, and act on it.

---

## The 6 principles

1. **People scan, they don't read.** On a typical page users read ~20–28% of the
   words (NN/g). Win the scan: descriptive headings, short chunks, lists, bold
   keywords, and callouts. Structure content as a "layer cake" of headings + lists.
2. **Front-load everything.** Put the answer first, the explanation after. Every
   section opens with a one-line **In short:** summary. Within steps, lead with the
   action, then the detail. Put **conditions before instructions** ("If X, do Y").
3. **Single source of truth — link, don't repeat.** One topic lives in one place.
   If two sections need the same fact, one owns it and the other links to it
   (e.g. the CSR job description links into the SOPs instead of repeating them).
4. **Plain English, simple words.** Aim around an 8th-grade reading level. Short
   sentences. Common words. Spell out an acronym on first use — CSR (Customer
   Support Representative), SOP, QC, DAR — then use the short form.
5. **Speak to the reader: "you", active voice, present tense.** "Assign the order"
   not "the order should be assigned". Direct and unambiguous.
6. **Action-oriented.** Numbered lists for sequences (steps), bullets for
   non-sequential points, tables for comparisons. Descriptive link text — never
   "click here".

---

## Section template

Every section should follow this shape (omit parts that don't apply):

```markdown
**In short:** One sentence — the essence a reader needs even if they read nothing else.

## <Descriptive heading that leads with the key words>
A short intro only if it adds context.

## Steps            ← numbered for a sequence
1. **Action** — the detail.
2. **Action** — the detail.

> **Rule:** The non-negotiable.

**Helping points**
- A tip we add to make it easier (our value-add, beyond the raw source).
- A cross-link to the related section: [Quality Check](/section/sop-07-quality-check).
```

Keep sections to **one topic**. If a topic has many parts, split it and link
them from an index/"Start Here" section.

---

## Callouts

Write a callout as a blockquote whose first word is a label and a colon. The
renderer turns these into colored, icon-tagged boxes automatically:

| Label | Use it for | Renders as |
| --- | --- | --- |
| `> **Rule:**` | A non-negotiable / must-do | Red |
| `> **Important:**` / `> **Warning:**` | A risk or strong caution | Amber |
| `> **Standard:**` | A fixed format/standard to copy | Violet |
| `> **Tip:**` / `> **Helping point:**` | An aid we add to help | Green |
| `> **Key principle:**` | A guiding idea | Violet |
| `> **Note:**` | A neutral aside | Grey |

Use callouts sparingly — 1–3 per section. If everything is highlighted, nothing is.

---

## Headings, lists, and tables

- **Headings:** sentence case, descriptive, lead with the important words
  ("Quality review checklist", not "Checklist"). `##` for sections, `###` for
  sub-parts. Don't skip levels.
- **Lists:** numbered = order matters; bullets = order doesn't. Keep items
  parallel (all start with a verb, or all nouns).
- **Tables:** for side-by-side comparisons (good vs poor, scorecards, schedules).
  Keep them narrow — they're read on phones.
- **Bold** the few keywords that carry the meaning of a line, not whole sentences.

---

## Voice: write like a person

Sound like a real colleague explaining something, not a manual and not a robot.
This is the most important rule here.

- **No em dashes or en dashes.** Use full stops, commas, or "and". Rewrite the
  sentence rather than reaching for a dash.
- **Avoid hyphens.** Reword instead. "Five minute reply" becomes "reply within
  five minutes"; "after sales" stays two words; "cross sell" becomes "offer an
  extra service".
- **Use contractions.** "It's", "you'll", "don't". They make writing sound human.
- **Plain everyday words.** "Make sure", not "ensure". "Use", not "utilise".
  "About", not "regarding". "Before", not "prior to".
- **No AI tells.** Skip "In short", "delve", "robust", "seamless", "leverage",
  "it's worth noting", "furthermore", and perfectly parallel triads. Vary your
  sentence lengths.
- **Keep the company's own warmth** where it's strong ("Always help, never sell").

Read it aloud. If it sounds like a person wrote it for a teammate, it's right.

---

## Visibility (who sees what)

Roles: `csr`, `asr`, `hr`, `pm`, `manager`, `office_boy`. **CSR and ASR are
separate roles** — don't bundle them. Default open, restrict by exception:

- **Everyone (all six roles):** welcome, company/org, conduct & culture,
  attendance, security basics, emergencies, glossary.
- **Manager always has full access** — include `manager` in every section.
- **CSR content** (CSR job descriptions, the SOPs/playbook, ClickUp, bonus):
  `csr, hr, pm, manager`.
- **ASR content:** scoped to `asr` (+ `hr, pm, manager`) when it's added.
- **Tighter:** restrict to specific roles only when it's genuinely sensitive.

Flag onboarding-critical sections with **Start Here** so new hires see them first.

---

## Before publishing — quick checklist

- [ ] Opens with a one-line **In short:** summary.
- [ ] Headings are descriptive and lead with key words.
- [ ] Steps are numbered and action-first; conditions before instructions.
- [ ] Acronyms spelled out on first use.
- [ ] 1–3 callouts, not a wall of them.
- [ ] Cross-links instead of repeated content.
- [ ] Correct visibility (allowed roles) + Start Here flag if it's onboarding.
- [ ] Reads in plain, simple English.

---

## Sources

- GOV.UK — [Content design](https://www.gov.uk/guidance/content-design) and [A–Z style guide](https://www.gov.uk/guidance/style-guide/a-to-z)
- Nielsen Norman Group — [F-shaped reading pattern](https://www.nngroup.com/articles/f-shaped-pattern-reading-web-content/) and [Layer-cake scanning](https://www.nngroup.com/articles/layer-cake-pattern-scanning/)
- GitLab — [Documentation style guide](https://docs.gitlab.com/ee/development/documentation/styleguide/) and [Handbook-first](https://handbook.gitlab.com/handbook/company/culture/all-remote/handbook-first/)
- Google — [Developer documentation style guide highlights](https://developers.google.com/style/highlights)
