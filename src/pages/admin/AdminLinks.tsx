import { useState } from 'react'
import { useMutation, useQueryClient } from '@tanstack/react-query'
import {
  useAccessLinks,
  rotateLink,
  setLinkActive,
  createLink,
  linkUrl,
  type AccessLink,
} from '@/lib/links'
import { ALL_ROLES, ROLE_LABELS } from '@/lib/roles'
import type { UserRole } from '@/lib/database.types'
import { Icon } from '@/components/Icon'
import { LoadingState } from '@/components/States'

export function AdminLinks() {
  const qc = useQueryClient()
  const { data: links = [], isLoading } = useAccessLinks()
  const invalidate = () => qc.invalidateQueries({ queryKey: ['admin', 'links'] })

  const rotate = useMutation({
    mutationFn: (token: string) => rotateLink(token),
    onSuccess: invalidate,
  })
  const toggle = useMutation({
    mutationFn: ({ token, active }: { token: string; active: boolean }) =>
      setLinkActive(token, active),
    onSuccess: invalidate,
  })
  const create = useMutation({
    mutationFn: (role: UserRole) => createLink(role, `${ROLE_LABELS[role]} team link`),
    onSuccess: invalidate,
  })

  if (isLoading) return <LoadingState />

  const rolesWithout = ALL_ROLES.filter((r) => !links.some((l) => l.role === r))

  return (
    <div>
      <div className="mb-5 rounded-2xl border border-brand/30 bg-brand-soft/40 p-4">
        <div className="flex items-start gap-3">
          <Icon name="link" size={22} className="mt-0.5 shrink-0 text-brand" />
          <div className="text-sm">
            <p className="font-semibold text-fg">Share one link per role — no login needed.</p>
            <p className="mt-1 text-muted">
              Anyone with a link sees the common handbook plus that role’s sections. Treat links
              like keys: if one leaks, <strong>rotate</strong> it to instantly cut off the old one.
            </p>
          </div>
        </div>
      </div>

      <ul className="space-y-3">
        {links.map((link) => (
          <LinkRow
            key={link.token}
            link={link}
            onRotate={() => {
              if (
                window.confirm(
                  `Rotate the ${ROLE_LABELS[link.role]} link? The current link will stop working immediately and you'll need to reshare the new one.`,
                )
              )
                rotate.mutate(link.token)
            }}
            onToggle={() => toggle.mutate({ token: link.token, active: !link.is_active })}
            busy={rotate.isPending || toggle.isPending}
          />
        ))}
      </ul>

      {rolesWithout.length > 0 && (
        <div className="mt-6">
          <h2 className="mb-2 text-sm font-semibold uppercase tracking-wide text-muted">
            Roles without a link
          </h2>
          <div className="flex flex-wrap gap-2">
            {rolesWithout.map((r) => (
              <button
                key={r}
                className="btn-secondary"
                disabled={create.isPending}
                onClick={() => create.mutate(r)}
              >
                <Icon name="plus" size={16} /> {ROLE_LABELS[r]}
              </button>
            ))}
          </div>
        </div>
      )}
    </div>
  )
}

function LinkRow({
  link,
  onRotate,
  onToggle,
  busy,
}: {
  link: AccessLink
  onRotate: () => void
  onToggle: () => void
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
      /* clipboard blocked — the input is selectable as a fallback */
    }
  }

  return (
    <li className="rounded-2xl border border-border bg-surface p-4">
      <div className="mb-2.5 flex items-center justify-between gap-3">
        <div className="flex items-center gap-2">
          <span className="grid h-9 w-9 place-items-center rounded-xl bg-brand-soft text-brand">
            <Icon name="badge" size={18} />
          </span>
          <div>
            <p className="font-semibold leading-tight">{ROLE_LABELS[link.role]}</p>
            {link.label && <p className="text-xs text-muted">{link.label}</p>}
          </div>
        </div>
        <span className={`chip ${link.is_active ? '!bg-success/15 !text-success' : '!bg-danger-soft !text-danger'}`}>
          {link.is_active ? 'Active' : 'Off'}
        </span>
      </div>

      <div className="flex items-center gap-1.5">
        <input
          readOnly
          value={url}
          onFocus={(e) => e.currentTarget.select()}
          className="input min-h-[40px] flex-1 font-mono text-xs"
          aria-label={`${ROLE_LABELS[link.role]} link`}
        />
        <button
          className="btn-secondary !min-h-[40px] !px-3"
          onClick={copy}
          aria-label="Copy link"
        >
          <Icon name={copied ? 'check' : 'copy'} size={16} />
          <span className="hidden sm:inline">{copied ? 'Copied' : 'Copy'}</span>
        </button>
      </div>

      <div className="mt-2.5 flex flex-wrap gap-2">
        <button className="btn-ghost !min-h-[38px] !px-2.5 text-xs" disabled={busy} onClick={onRotate}>
          <Icon name="rotate" size={15} /> Rotate
        </button>
        <button className="btn-ghost !min-h-[38px] !px-2.5 text-xs" disabled={busy} onClick={onToggle}>
          <Icon name={link.is_active ? 'eye-off' : 'eye'} size={15} />
          {link.is_active ? 'Turn off' : 'Turn on'}
        </button>
      </div>
    </li>
  )
}
