import { useState } from 'react'
import { useMutation, useQueryClient } from '@tanstack/react-query'
import { useAuth } from '@/lib/auth'
import {
  useUsers,
  createUser,
  setUserRole,
  setUserActive,
  setUserPassword,
  type ManagedUser,
  type CreateUserInput,
} from '@/lib/admin'
import type { UserRole } from '@/lib/database.types'
import { ALL_ROLES, ROLE_LABELS } from '@/lib/roles'
import { Icon } from '@/components/Icon'
import { Modal } from '@/components/Modal'
import { LoadingState, ErrorState, InlineError, Spinner } from '@/components/States'

export function AdminUsers() {
  const qc = useQueryClient()
  const { profile } = useAuth()
  const { data: users = [], isLoading, error } = useUsers()
  const [creating, setCreating] = useState(false)
  const [resetting, setResetting] = useState<ManagedUser | null>(null)

  const invalidate = () => qc.invalidateQueries({ queryKey: ['admin', 'users'] })

  const role = useMutation({
    mutationFn: ({ id, role }: { id: string; role: UserRole }) => setUserRole(id, role),
    onSuccess: invalidate,
  })
  const active = useMutation({
    mutationFn: ({ id, value }: { id: string; value: boolean }) => setUserActive(id, value),
    onSuccess: invalidate,
  })

  if (error) {
    return (
      <div className="space-y-4">
        <ErrorState error={error} />
        <p className="text-center text-sm text-muted">
          The user list comes from the <code className="font-mono">admin-users</code> Edge Function.
          Deploy it with <code className="font-mono">supabase functions deploy admin-users</code>.
        </p>
      </div>
    )
  }

  return (
    <div>
      <div className="mb-4 flex items-center justify-between">
        <p className="text-sm text-muted">
          {users.length} {users.length === 1 ? 'account' : 'accounts'}
        </p>
        <button className="btn-primary" onClick={() => setCreating(true)}>
          <Icon name="plus" size={18} /> Add user
        </button>
      </div>

      {isLoading ? (
        <LoadingState />
      ) : (
        <ul className="space-y-2">
          {users.map((u) => {
            const isSelf = u.id === profile?.id
            return (
              <li
                key={u.id}
                className="flex flex-wrap items-center gap-3 rounded-2xl border border-border bg-surface p-3.5"
              >
                <div className="min-w-0 flex-1">
                  <div className="flex items-center gap-2">
                    <p className="truncate font-semibold">{u.full_name}</p>
                    {u.is_admin && <span className="chip-brand">Admin</span>}
                    {!u.is_active && <span className="chip !bg-danger-soft !text-danger">Inactive</span>}
                  </div>
                  <p className="truncate text-sm text-muted">{u.email ?? '—'}</p>
                </div>

                <select
                  aria-label={`Role for ${u.full_name}`}
                  className="input !min-h-[40px] !w-auto py-0 text-sm"
                  value={u.role}
                  disabled={isSelf || role.isPending}
                  onChange={(e) => role.mutate({ id: u.id, role: e.target.value as UserRole })}
                >
                  {ALL_ROLES.map((r) => (
                    <option key={r} value={r}>
                      {ROLE_LABELS[r]}
                    </option>
                  ))}
                </select>

                <button
                  className="btn-ghost !min-h-[40px] !px-2.5 text-xs"
                  onClick={() => setResetting(u)}
                >
                  <Icon name="lock" size={16} /> Password
                </button>

                <button
                  aria-label={u.is_active ? 'Deactivate' : 'Activate'}
                  title={isSelf ? "You can't deactivate yourself" : undefined}
                  disabled={isSelf || active.isPending}
                  onClick={() => active.mutate({ id: u.id, value: !u.is_active })}
                  className={`relative h-6 w-11 shrink-0 rounded-full transition-colors disabled:opacity-40 ${
                    u.is_active ? 'bg-success' : 'bg-border'
                  }`}
                >
                  <span
                    className={`absolute top-0.5 h-5 w-5 rounded-full bg-white shadow transition-transform ${
                      u.is_active ? 'translate-x-[22px]' : 'translate-x-0.5'
                    }`}
                  />
                </button>
              </li>
            )
          })}
        </ul>
      )}

      {creating && (
        <CreateUserModal
          onClose={() => setCreating(false)}
          onCreated={() => {
            invalidate()
            setCreating(false)
          }}
        />
      )}
      {resetting && (
        <ResetPasswordModal user={resetting} onClose={() => setResetting(null)} />
      )}
    </div>
  )
}

function CreateUserModal({ onClose, onCreated }: { onClose: () => void; onCreated: () => void }) {
  const [form, setForm] = useState<CreateUserInput>({
    email: '',
    password: '',
    full_name: '',
    role: 'csr',
    is_admin: false,
  })
  const [error, setError] = useState('')

  const create = useMutation({
    mutationFn: () => createUser(form),
    onSuccess: onCreated,
    onError: (e) => setError(e instanceof Error ? e.message : 'Could not create the account.'),
  })

  function submit() {
    setError('')
    if (!form.full_name.trim() || !form.email.trim()) return setError('Name and email are required.')
    if (form.password.length < 8) return setError('Password must be at least 8 characters.')
    create.mutate()
  }

  return (
    <Modal
      title="Add user"
      onClose={onClose}
      footer={
        <>
          <button className="btn-secondary" onClick={onClose}>
            Cancel
          </button>
          <button className="btn-primary" disabled={create.isPending} onClick={submit}>
            {create.isPending ? <Spinner /> : null}
            Create account
          </button>
        </>
      }
    >
      <div className="space-y-4">
        <div>
          <label className="label" htmlFor="nu-name">Full name</label>
          <input
            id="nu-name"
            className="input"
            value={form.full_name}
            onChange={(e) => setForm({ ...form, full_name: e.target.value })}
            placeholder="Ayesha Khan"
          />
        </div>
        <div>
          <label className="label" htmlFor="nu-email">Email</label>
          <input
            id="nu-email"
            type="email"
            className="input"
            value={form.email}
            onChange={(e) => setForm({ ...form, email: e.target.value })}
            placeholder="ayesha@haseebmadeit.com"
          />
        </div>
        <div>
          <label className="label" htmlFor="nu-pass">Temporary password</label>
          <input
            id="nu-pass"
            type="text"
            className="input font-mono"
            value={form.password}
            onChange={(e) => setForm({ ...form, password: e.target.value })}
            placeholder="At least 8 characters"
          />
          <p className="mt-1 hint">Share this with the new hire; they can change it later.</p>
        </div>
        <div>
          <label className="label" htmlFor="nu-role">Role</label>
          <select
            id="nu-role"
            className="input"
            value={form.role}
            onChange={(e) => setForm({ ...form, role: e.target.value as UserRole })}
          >
            {ALL_ROLES.map((r) => (
              <option key={r} value={r}>
                {ROLE_LABELS[r]}
              </option>
            ))}
          </select>
        </div>
        <label className="flex cursor-pointer items-center justify-between rounded-xl border border-border p-3">
          <span>
            <span className="block font-medium">Make admin</span>
            <span className="block text-xs text-muted">Full author &amp; approve power.</span>
          </span>
          <input
            type="checkbox"
            className="h-5 w-5 accent-brand"
            checked={form.is_admin}
            onChange={(e) => setForm({ ...form, is_admin: e.target.checked })}
          />
        </label>
        {error && <InlineError>{error}</InlineError>}
      </div>
    </Modal>
  )
}

function ResetPasswordModal({ user, onClose }: { user: ManagedUser; onClose: () => void }) {
  const [password, setPassword] = useState('')
  const [error, setError] = useState('')
  const [done, setDone] = useState(false)

  const save = useMutation({
    mutationFn: () => setUserPassword(user.id, password),
    onSuccess: () => setDone(true),
    onError: (e) => setError(e instanceof Error ? e.message : 'Could not set the password.'),
  })

  return (
    <Modal
      title={`Set password — ${user.full_name}`}
      onClose={onClose}
      footer={
        done ? (
          <button className="btn-primary" onClick={onClose}>
            Done
          </button>
        ) : (
          <>
            <button className="btn-secondary" onClick={onClose}>
              Cancel
            </button>
            <button
              className="btn-primary"
              disabled={save.isPending || password.length < 8}
              onClick={() => {
                setError('')
                save.mutate()
              }}
            >
              {save.isPending ? <Spinner /> : null}
              Set password
            </button>
          </>
        )
      }
    >
      {done ? (
        <p className="flex items-center gap-2 text-sm text-success">
          <Icon name="check" size={18} /> Password updated. Share the new password with {user.full_name}.
        </p>
      ) : (
        <div className="space-y-3">
          <div>
            <label className="label" htmlFor="rp-pass">New password</label>
            <input
              id="rp-pass"
              type="text"
              className="input font-mono"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              placeholder="At least 8 characters"
            />
          </div>
          {error && <InlineError>{error}</InlineError>}
        </div>
      )}
    </Modal>
  )
}
