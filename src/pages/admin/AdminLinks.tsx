import { useState } from 'react'
import { useMutation, useQueryClient } from '@tanstack/react-query'
import {
  useAccessLinks,
  rotateLink,
  setLinkActive,
  createLink,
  deleteLink,
  linkUrl,
  type AccessLink,
} from '@/lib/links'
import { ALL_ROLES, ROLE_LABELS } from '@/lib/roles'
import type { UserRole } from '@/lib/database.types'
import { Icon } from '@/components/Icon'
import { Modal } from '@/components/Modal'
import { LoadingState, InlineError, Spinner } from '@/components/States'

export function AdminLinks() {
  const qc = useQueryClient()
  const { data: links = [], isLoading } = useAccessLinks()
  const [adding, setAdding] = useState<UserRole | null>(null)
  const invalidate = () => qc.invalidateQueries({ queryKey: ['admin', 'links'] })

  const rotate = useMutation({ mutationFn: (t: string) => rotateLink(t), onSuccess: invalidate })
  const toggle = useMutation({
    mutationFn: ({ token, active }: { token: string; active: boolean }) => setLinkActive(token, active),
    onSuccess: invalidate,
  })
  const remove = useMutation({ mutationFn: (t: string) => deleteLink(t), onSuccess: invalidate })

  if (isLoading) return <LoadingState />

  return (
    <div>
      <div className="mb-5 rounded-2xl border border-brand/30 bg-brand-soft/40 p-4">
        <div className="flex items-start gap-3">
          <Icon name="link" size={22} className="mt-0.5 shrink-0 text-brand" />
          <div className="text-sm">
            <p className="font-semibold text-fg">Give each person their own link.</p>
            <p className="mt-1 text-muted">
              A link opens the common handbook plus that role’s sections — no login. Because each
              person has their own, if one leaks you just <strong>turn off that one link</strong>.
              Everyone else keeps working, untouched.
            </p>
          </div>
        </div>
      </div>

      <div className="space-y-6">
        {ALL_ROLES.map((role) => {
          const roleLinks = links.filter((l) => l.role === role)
          return (
            <section key={role}>
              <div className="mb-2 flex items-center justify-between gap-2">
                <h2 className="text-sm font-semibold uppercase tracking-wide text-muted">
                  {ROLE_LABELS[role]}
                  <span className="ml-2 font-normal normal-case text-muted/70">
                    {roleLinks.length} {roleLinks.length === 1 ? 'link' : 'links'}
                  </span>
                </h2>
                <button className="btn-ghost !min-h-[36px] !px-2.5 text-xs" onClick={() => setAdding(role)}>
                  <Icon name="plus" size={15} /> Add person
                </button>
              </div>

              {roleLinks.length === 0 ? (
                <p className="rounded-xl border border-dashed border-border px-4 py-3 text-sm text-muted">
                  No links yet. Add one per teammate in this role.
                </p>
              ) : (
                <ul className="space-y-2.5">
                  {roleLinks.map((link) => (
                    <LinkRow
                      key={link.token}
                      link={link}
                      busy={rotate.isPending || toggle.isPending || remove.isPending}
                      onRotate={() => {
                        if (
                          window.confirm(
                            `Reset ${link.label || 'this link'}? Their current link stops working and you'll send them the new one. No one else is affected.`,
                          )
                        )
                          rotate.mutate(link.token)
                      }}
                      onToggle={() => toggle.mutate({ token: link.token, active: !link.is_active })}
                      onDelete={() => {
                        if (window.confirm(`Delete ${link.label || 'this link'} for good?`))
                          remove.mutate(link.token)
                      }}
                    />
                  ))}
                </ul>
              )}
            </section>
          )
        })}
      </div>

      {adding && (
        <AddLinkModal
          role={adding}
          onClose={() => setAdding(null)}
          onCreated={() => {
            invalidate()
            setAdding(null)
          }}
        />
      )}
    </div>
  )
}

function AddLinkModal({
  role,
  onClose,
  onCreated,
}: {
  role: UserRole
  onClose: () => void
  onCreated: () => void
}) {
  const [name, setName] = useState('')
  const [selectedRole, setSelectedRole] = useState<UserRole>(role)
  const [error, setError] = useState('')

  const create = useMutation({
    mutationFn: () => createLink(selectedRole, name),
    onSuccess: onCreated,
    onError: (e) => setError(e instanceof Error ? e.message : 'Could not create the link.'),
  })

  return (
    <Modal
      title="Add a person’s link"
      onClose={onClose}
      footer={
        <>
          <button className="btn-secondary" onClick={onClose}>
            Cancel
          </button>
          <button
            className="btn-primary"
            disabled={create.isPending || !name.trim()}
            onClick={() => {
              setError('')
              create.mutate()
            }}
          >
            {create.isPending ? <Spinner /> : <Icon name="link" size={18} />}
            Create link
          </button>
        </>
      }
    >
      <div className="space-y-4">
        <div>
          <label className="label" htmlFor="lk-name">Person’s name</label>
          <input
            id="lk-name"
            className="input"
            value={name}
            autoFocus
            onChange={(e) => setName(e.target.value)}
            placeholder="e.g. Ayesha Khan"
          />
          <p className="mt-1 hint">Just a label so you know whose link this is.</p>
        </div>
        <div>
          <label className="label" htmlFor="lk-role">Role</label>
          <select
            id="lk-role"
            className="input"
            value={selectedRole}
            onChange={(e) => setSelectedRole(e.target.value as UserRole)}
          >
            {ALL_ROLES.map((r) => (
              <option key={r} value={r}>
                {ROLE_LABELS[r]}
              </option>
            ))}
          </select>
        </div>
        {error && <InlineError>{error}</InlineError>}
      </div>
    </Modal>
  )
}

function LinkRow({
  link,
  onRotate,
  onToggle,
  onDelete,
  busy,
}: {
  link: AccessLink
  onRotate: () => void
  onToggle: () => void
  onDelete: () => void
  busy: boolean
}) {
  const [copied, setCopied] = useState(false)
  const url = linkUrl(link.token)

  async function copy() {
    try {
      await navigator.clipboard.writeText(url)
      setCopied(true)
      setTimeout(() => setCopied(false), 1500)
    } catch {
      /* clipboard blocked — the field is selectable as a fallback */
    }
  }

  return (
    <li className="rounded-2xl border border-border bg-surface p-4">
      <div className="mb-2.5 flex items-center justify-between gap-3">
        <div className="flex items-center gap-2.5">
          <span className="grid h-9 w-9 place-items-center rounded-xl bg-brand-soft text-brand">
            <Icon name="users" size={18} />
          </span>
          <p className="font-semibold leading-tight">{link.label || 'Unnamed link'}</p>
        </div>
        <span
          className={`chip ${link.is_active ? '!bg-success/15 !text-success' : '!bg-danger-soft !text-danger'}`}
        >
          {link.is_active ? 'Active' : 'Off'}
        </span>
      </div>

      <div className="flex items-center gap-1.5">
        <input
          readOnly
          value={url}
          onFocus={(e) => e.currentTarget.select()}
          className="input min-h-[40px] flex-1 font-mono text-xs"
          aria-label={`Link for ${link.label || 'teammate'}`}
        />
        <button className="btn-secondary !min-h-[40px] !px-3" onClick={copy} aria-label="Copy link">
          <Icon name={copied ? 'check' : 'copy'} size={16} />
          <span className="hidden sm:inline">{copied ? 'Copied' : 'Copy'}</span>
        </button>
      </div>

      <div className="mt-2.5 flex flex-wrap gap-2">
        <button className="btn-ghost !min-h-[38px] !px-2.5 text-xs" disabled={busy} onClick={onToggle}>
          <Icon name={link.is_active ? 'eye-off' : 'eye'} size={15} />
          {link.is_active ? 'Turn off' : 'Turn on'}
        </button>
        <button className="btn-ghost !min-h-[38px] !px-2.5 text-xs" disabled={busy} onClick={onRotate}>
          <Icon name="rotate" size={15} /> Reset link
        </button>
        <button
          className="btn-ghost !min-h-[38px] !px-2.5 text-xs text-danger"
          disabled={busy}
          onClick={onDelete}
        >
          <Icon name="trash" size={15} /> Delete
        </button>
      </div>
    </li>
  )
}
