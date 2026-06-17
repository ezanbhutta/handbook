# HaseebMadeit Handbook

One live company handbook. A single source of truth, with role-derived access,
intelligent search, and a "What's New" banner. The admin authors and approves
every change; the database — not the UI — decides who can read what.

**Access model — no team logins.** Each role gets its own secret link
(`/r/<token>`). A teammate opens their link and reads the common handbook plus
their role's sections — no password, no account. Only the founder logs in (with
a password) to author content and manage links. Links are bearer secrets:
rotate one to instantly revoke it.

**Three reading modes.** Day (bright violet brand), Night (deep indigo), and
Reading (warm cream + serif body) — picked from the header, remembered per
device. Tuned for long, comfortable reading on a phone.

> **Phase 1 (this build):** the complete, shippable core. No-login role links +
> admin password auth, role-based visibility enforced in the database, the
> reading experience, Postgres search (typos + keywords + synonyms), What's New,
> and the full admin suite. The Phase 2 intelligence layer (AI conflict-check,
> semantic search, gap report) is scaffolded but not wired up.

## Tech stack

- **Backend / DB / Auth:** Supabase — Postgres, Auth, Row Level Security, Storage.
- **Frontend:** React + Vite + TypeScript, Tailwind CSS, React Router, TanStack
  Query, `@supabase/supabase-js`, `react-markdown` + `rehype-sanitize`.
- **Hosting:** Vercel (SPA). Backend on Supabase.

## How it works (the important parts)

- **Single source of truth, role-derived access.** Content lives once. Each
  section carries an `allowed_roles` list; it defaults to all six roles
  (visible to everyone) and is narrowed only to restrict a sensitive section.
- **Visibility is enforced in the database.** For the founder (logged in) the
  base tables run under RLS. For readers (no login) every read goes through
  `SECURITY DEFINER` token RPCs that resolve the link's role and return only that
  role's content; the base tables deny anonymous reads, so the token is the only
  way in. Either way, a role can't fetch or search content it isn't allowed to —
  restricted sections never surface, not even as a hint.
- **The book never publishes itself.** The admin writes the change, adds a
  one-line summary, and clicks publish. Publishing writes the section and a
  `change_log` entry whose visibility mirrors the section.
- **What's New.** The banner shows the single most recent change the viewer is
  allowed to see, and persists until a newer one replaces it. The full history
  is Chapter 12 (`/whats-new`), permission-filtered.
- **Search, V1.** Trigram similarity (typos/partials) + full-text (keywords) +
  a maintained synonym map ("chutti" → "leave"), all in one Postgres function.
  Every search is logged silently to feed the future Gap Report.

The six roles are `csr`, `asr`, `hr`, `pm`, `manager`, `office_boy`, plus an
`is_admin` flag (the founder) that grants full author/approve power.

## Project structure

```
.
├── src/
│   ├── lib/            supabase client, types, auth, query hooks, admin ops
│   ├── components/     layout, search bar, nav, markdown, banner, icons, states
│   └── pages/          login, home, chapter, section, what's new, search
│       └── admin/      overview, chapters, sections, editor, synonyms, users, insights
├── supabase/
│   ├── migrations/     schema, RLS, RPCs, seed, storage  (see supabase/README.md)
│   └── functions/      admin-users edge function (privileged user management)
└── index.html, vite/ts/tailwind config, vercel.json
```

## Local setup

**1. Backend.** Create a Supabase project, then apply the migrations and deploy
the Edge Function — see [`supabase/README.md`](./supabase/README.md). It also
covers the one-time **first-admin bootstrap** (there's no public sign-up, so the
first admin is created by hand).

**2. Frontend.**

```bash
npm install
cp .env.example .env     # fill in VITE_SUPABASE_URL and VITE_SUPABASE_ANON_KEY
npm run dev
```

Scripts: `npm run dev` · `npm run build` · `npm run preview` · `npm run typecheck`.

## Deployment (Vercel)

Import the repo into Vercel. It auto-detects Vite (`npm run build` → `dist`); a
`vercel.json` adds the SPA rewrite. Set the two `VITE_SUPABASE_*` env vars in the
Vercel project. The anon key is safe to expose — RLS is the real protection. The
service-role key lives only in the Supabase Edge Function and is never shipped to
the browser.

## Design standard

Mobile-first (staff use phones, often late at night): 16px base font, semantic
color tokens with an automatic dark theme, 4.5:1 contrast, 44×44px touch targets,
SVG-only icons, 150–300ms transitions. The search bar and the What's New banner
are the two most prominent elements on the home screen.

## Phase 1 acceptance criteria — how each is met

- **A CSR cannot see/fetch/search a Manager-only section** → `sections_read` RLS
  + `SECURITY INVOKER` on `search_handbook`/`get_navigation`. Enforced at the DB,
  not the UI.
- **A section visible to all roles appears for everyone** → default
  `allowed_roles` = all six.
- **Misspellings ("atendance", "cancelation") find the right section** → trigram
  similarity + `body ILIKE` fallback.
- **Synonyms ("chutti", "refund") find the right section** → `search_synonyms`
  expanded into the query.
- **Publishing updates the banner instantly and writes a permanent Ch. 12 entry**
  → `saveSection` writes the section + a mirrored `change_log` row; the banner is
  simply the newest visible row.
- **A Manager-only change never appears in a CSR's What's New** → `change_log`
  RLS mirrors section visibility.
- **Admin creates a user, assigns a role, that user logs into the right view** →
  `admin-users` Edge Function + role-based RLS.
- **Every search writes a `search_log` row** → silent logging on each query.

## Phase 2 (scaffolded, not built)

Conflict-check on publish (Anthropic API Edge Function — the authoring flow
already routes through a "Check before publish" step), knowledge-dump classifier,
corrections queue, the search Gap Report at `/admin/insights`, and semantic
search (pgvector) blended into `search_handbook`. The search log is already
collecting data for the Gap Report from day one.
