// =============================================================================
// Edge Function: admin-users
// Privileged user management. Creating an auth account needs the service-role
// key, which must never reach the browser — so it lives here.
//
// The caller's JWT is verified and their profile must have is_admin = true
// before any privileged action runs. Service-role calls happen only after
// that check passes.
//
// Actions (POST JSON body { action, ... }):
//   list                                  -> [{ id, email, full_name, role, is_admin, is_active, created_at }]
//   create  { email, password, full_name, role, is_admin? }
//   setPassword { user_id, password }
//
// Role changes and active toggles are done directly against the `profiles`
// table from the client (admin RLS already allows it) — they don't need the
// service role, so they're intentionally not duplicated here.
//
// Deploy:  supabase functions deploy admin-users
// Secrets: SUPABASE_URL, SUPABASE_ANON_KEY, SUPABASE_SERVICE_ROLE_KEY are
//          injected automatically by Supabase.
// =============================================================================

import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers':
    'authorization, x-client-info, apikey, content-type',
  'Access-Control-Allow-Methods': 'POST, OPTIONS',
}

const json = (body: unknown, status = 200) =>
  new Response(JSON.stringify(body), {
    status,
    headers: { ...corsHeaders, 'Content-Type': 'application/json' },
  })

const ROLES = ['csr', 'asr', 'hr', 'pm', 'manager', 'office_boy']

Deno.serve(async (req: Request) => {
  if (req.method === 'OPTIONS') return new Response('ok', { headers: corsHeaders })
  if (req.method !== 'POST') return json({ error: 'Method not allowed' }, 405)

  const url = Deno.env.get('SUPABASE_URL')!
  const anonKey = Deno.env.get('SUPABASE_ANON_KEY')!
  const serviceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!

  const authHeader = req.headers.get('Authorization')
  if (!authHeader) return json({ error: 'Missing Authorization header' }, 401)

  // Client scoped to the caller — used only to identify them and check admin.
  const caller = createClient(url, anonKey, {
    global: { headers: { Authorization: authHeader } },
  })

  const { data: userData, error: userErr } = await caller.auth.getUser()
  if (userErr || !userData?.user) return json({ error: 'Invalid session' }, 401)

  const { data: me, error: meErr } = await caller
    .from('profiles')
    .select('is_admin')
    .eq('id', userData.user.id)
    .single()

  if (meErr || !me?.is_admin) return json({ error: 'Admin access required' }, 403)

  // Privileged client — bypasses RLS, can touch auth.admin.
  const admin = createClient(url, serviceKey, {
    auth: { autoRefreshToken: false, persistSession: false },
  })

  let payload: Record<string, unknown>
  try {
    payload = await req.json()
  } catch {
    return json({ error: 'Invalid JSON body' }, 400)
  }
  const action = payload.action

  try {
    if (action === 'list') {
      const { data: profiles, error } = await admin
        .from('profiles')
        .select('id, full_name, role, is_admin, is_active, created_at')
        .order('created_at', { ascending: true })
      if (error) throw error

      // Merge in the login email from auth.users (only reachable via admin API).
      const { data: authList, error: authErr } = await admin.auth.admin.listUsers({
        page: 1,
        perPage: 1000,
      })
      if (authErr) throw authErr
      const emailById = new Map(authList.users.map((u) => [u.id, u.email]))

      const users = (profiles ?? []).map((p) => ({
        ...p,
        email: emailById.get(p.id) ?? null,
      }))
      return json({ users })
    }

    if (action === 'create') {
      const email = String(payload.email ?? '').trim().toLowerCase()
      const password = String(payload.password ?? '')
      const full_name = String(payload.full_name ?? '').trim()
      const role = String(payload.role ?? '')
      const is_admin = Boolean(payload.is_admin ?? false)

      if (!email || !password || !full_name || !ROLES.includes(role)) {
        return json({ error: 'email, password, full_name and a valid role are required' }, 400)
      }
      if (password.length < 8) {
        return json({ error: 'Password must be at least 8 characters' }, 400)
      }

      const { data: created, error: createErr } = await admin.auth.admin.createUser({
        email,
        password,
        email_confirm: true, // admin-provisioned: usable immediately, no email step
      })
      if (createErr) throw createErr

      const { error: profileErr } = await admin.from('profiles').insert({
        id: created.user.id,
        full_name,
        role,
        is_admin,
        is_active: true,
      })
      if (profileErr) {
        // roll back the orphaned auth user so we don't leave a half-created account
        await admin.auth.admin.deleteUser(created.user.id)
        throw profileErr
      }

      return json({ user: { id: created.user.id, email, full_name, role, is_admin } })
    }

    if (action === 'setPassword') {
      const user_id = String(payload.user_id ?? '')
      const password = String(payload.password ?? '')
      if (!user_id || password.length < 8) {
        return json({ error: 'user_id and a password of 8+ characters are required' }, 400)
      }
      const { error } = await admin.auth.admin.updateUserById(user_id, { password })
      if (error) throw error
      return json({ ok: true })
    }

    return json({ error: `Unknown action: ${String(action)}` }, 400)
  } catch (err) {
    const message = err instanceof Error ? err.message : 'Unexpected error'
    return json({ error: message }, 400)
  }
})
