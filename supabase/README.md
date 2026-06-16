# Supabase backend

Everything the handbook needs on the server: schema, Row Level Security, the
search/navigation RPCs, the 12-chapter seed, and the `admin-users` Edge
Function.

## Layout

```
supabase/
├── migrations/
│   ├── 0001_schema.sql     extensions, enums, tables, indexes, search trigger
│   ├── 0002_security.sql   RLS helper functions + policies
│   ├── 0003_rpc.sql        get_navigation() + search_handbook()
│   ├── 0004_seed.sql       12 chapters + starter synonyms
│   ├── 0005_storage.sql    section-image bucket + policies
│   └── 0006_access_links.sql  no-login role links + reader RPCs
└── functions/
    └── admin-users/        privileged user management (service-role only)
```

## Apply the migrations

**Option A — Supabase CLI (recommended)**

```bash
supabase link --project-ref YOUR_PROJECT_REF
supabase db push          # applies everything in migrations/ in order
supabase functions deploy admin-users
```

**Option B — SQL editor**

Paste the contents of `0001` → `0002` → `0003` → `0004` (in that order) into
the Supabase SQL editor and run each. Then deploy the Edge Function with the
CLI (`supabase functions deploy admin-users`).

The migrations are idempotent, so re-running them is safe.

## Create the first admin (one-time bootstrap)

There's a deliberate chicken-and-egg: only an admin can create accounts, so the
very first admin is provisioned by hand.

1. **Authentication → Users → Add user** in the Supabase dashboard. Set an
   email + password and tick "Auto Confirm User".
2. Copy the new user's UUID, then run this in the SQL editor:

   ```sql
   insert into profiles (id, full_name, role, is_admin, is_active)
   values ('PASTE-AUTH-USER-UUID', 'Haseeb', 'manager', true, true);
   ```

That account can now sign in and reach `/admin`.

## Team access — role links (no login)

Migration `0006` seeds one secret link per role and exposes `SECURITY DEFINER`
reader RPCs (`nav_for_token`, `section_for_token`, `search_for_token`, …) that
take a token, resolve its role, and return only that role's content. The base
tables deny anonymous reads, so the token is the only way in.

After deploying, sign in and open **Admin → Links** to copy each role's link and
share it (e.g. the CSR link with CSRs). A link looks like
`https://your-site/r/<token>`. If a link leaks, hit **Rotate** to invalidate it
and reshare the new one. The `admin-users` function is now only needed if you
want to create *additional admin* accounts.

## How security works (quick reference)

- **Content is gated at the database.** `sections` and `change_log` are only
  readable when `is_admin()` or the caller's role is in `allowed_roles`. A
  forbidden section can't be fetched or searched — it's not just hidden in the UI.
- **Search obeys RLS.** `search_handbook()` runs `SECURITY INVOKER`, so results
  are filtered by the same policies. A restricted section never appears, not
  even as a locked hint.
- **Only admins write.** Every table's write policy is `is_admin()`.
- **No recursion.** `is_admin()` / `auth_role()` are `SECURITY DEFINER` owned by
  `postgres`, which owns `profiles` and therefore bypasses RLS on the internal
  lookup — so calling them inside the `profiles` policy can't loop.

## Environment / secrets

- Frontend (`.env`): `VITE_SUPABASE_URL`, `VITE_SUPABASE_ANON_KEY`.
- The `admin-users` function reads `SUPABASE_URL`, `SUPABASE_ANON_KEY`, and
  `SUPABASE_SERVICE_ROLE_KEY` — Supabase injects all three automatically, so
  there's nothing extra to configure for Phase 1.
- **Never** put the service-role key in the frontend or commit it.

## Storage (section images)

Handled automatically by `0005_storage.sql`: it creates a public **`handbook`**
bucket with admin-only writes and signed-in reads. The authoring screen uploads
images there and inserts them into the body as markdown.

The bucket is public so images embed with stable URLs; paths are UUID-based and
no client data is stored. Section *text* stays fully RLS-gated. For sensitive
imagery, switch to a private bucket + signed URLs later (see the note in the
migration).
