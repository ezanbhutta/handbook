import { useState } from 'react'
import { useMutation, useQueryClient } from '@tanstack/react-query'
import {
  useAdminRoster,
  createRosterMember,
  updateRosterMember,
  deleteRosterMember,
  ROSTER_ROLES,
  ROSTER_SHIFTS,
  OFF_DAYS,
  type RosterInput,
  type RosterRow,
} from '@/lib/roster'
import { Icon } from '@/components/Icon'
import { Modal } from '@/components/Modal'
import { LoadingState, InlineError, Spinner } from '@/components/States'

export function AdminRoster() {
  const qc = useQueryClient()
  const { data: roster = [], isLoading } = useAdminRoster()
  const [editing, setEditing] = useState<RosterRow | 'new' | null>(null)

  const invalidate = () => {
    void qc.invalidateQueries({ queryKey: ['admin', 'roster'] })
    void qc.invalidateQueries({ queryKey: ['roster'] })
  }

  const remove = useMutation({
    mutationFn: (id: string) => deleteRosterMember(id),
    onSuccess: invalidate,
  })

  return (
    <div>
      <div className="mb-2 flex items-center justify-between gap-3">
        <p className="text-sm text-muted">
          {roster.length} {roster.length === 1 ? 'person' : 'people'} on the roster
        </p>
        <button className="btn-primary" onClick={() => setEditing('new')}>
          <Icon name="plus" size={18} /> Add person
        </button>
      </div>
      <p className="mb-4 text-xs text-muted">
        This roster drives the Company Hierarchy in the handbook. Removing someone here removes them
        from the handbook too.
      </p>

      {isLoading ? (
        <LoadingState />
      ) : (
        <ul className="space-y-2">
          {roster.map((m) => (
            <li
              key={m.id}
              className="flex items-center gap-3 rounded-2xl border border-border bg-surface p-3"
            >
              <div className="min-w-0 flex-1">
                <p className="flex items-center gap-2 truncate font-semibold">
                  {m.name}
                  {!m.active && (
                    <span className="chip !bg-surface-2 !py-0.5 text-xs text-muted">Hidden</span>
                  )}
                </p>
                <p className="truncate text-xs text-muted">
                  {m.role}
                  {m.shift ? ` · ${m.shift}` : ''}
                  {m.off_day ? ` · Off ${m.off_day}` : ''}
                </p>
              </div>
              <button
                aria-label={`Edit ${m.name}`}
                onClick={() => setEditing(m)}
                className="grid h-10 w-10 place-items-center rounded-xl text-muted hover:bg-surface-2"
              >
                <Icon name="edit" size={18} />
              </button>
              <button
                aria-label={`Remove ${m.name}`}
                onClick={() => {
                  if (
                    window.confirm(
                      `Remove "${m.name}" from the roster? They will no longer appear anywhere in the handbook.`,
                    )
                  ) {
                    remove.mutate(m.id)
                  }
                }}
                className="grid h-10 w-10 place-items-center rounded-xl text-danger hover:bg-danger-soft/50"
              >
                <Icon name="trash" size={18} />
              </button>
            </li>
          ))}
        </ul>
      )}

      {editing && (
        <RosterForm
          member={editing === 'new' ? null : editing}
          nextOrder={roster.reduce((m, r) => Math.max(m, r.order_index), 0) + 1}
          onClose={() => setEditing(null)}
          onSaved={() => {
            invalidate()
            setEditing(null)
          }}
        />
      )}
    </div>
  )
}

function RosterForm({
  member,
  nextOrder,
  onClose,
  onSaved,
}: {
  member: RosterRow | null
  nextOrder: number
  onClose: () => void
  onSaved: () => void
}) {
  const [name, setName] = useState(member?.name ?? '')
  const [role, setRole] = useState<string>(member?.role ?? 'CSR')
  const [shift, setShift] = useState<string>(member?.shift ?? '')
  const [offDay, setOffDay] = useState<string>(member?.off_day ?? '')
  const [active, setActive] = useState<boolean>(member?.active ?? true)
  const [error, setError] = useState('')

  const save = useMutation({
    mutationFn: async () => {
      const input: RosterInput = {
        name: name.trim(),
        role,
        shift: shift || null,
        off_day: offDay || null,
        order_index: member?.order_index ?? nextOrder,
        active,
      }
      if (!input.name) throw new Error('Name is required.')
      if (member) await updateRosterMember(member.id, input)
      else await createRosterMember(input)
    },
    onSuccess: onSaved,
    onError: (e) => setError(e instanceof Error ? e.message : 'Could not save.'),
  })

  return (
    <Modal
      title={member ? 'Edit person' : 'Add person'}
      onClose={onClose}
      footer={
        <>
          <button className="btn-secondary" onClick={onClose}>
            Cancel
          </button>
          <button className="btn-primary" disabled={save.isPending} onClick={() => save.mutate()}>
            {save.isPending ? <Spinner /> : null}
            {member ? 'Save changes' : 'Add person'}
          </button>
        </>
      }
    >
      <div className="space-y-4">
        <div>
          <label className="label" htmlFor="r-name">Name</label>
          <input
            id="r-name"
            className="input"
            value={name}
            onChange={(e) => setName(e.target.value)}
            placeholder="e.g. Ezan"
          />
        </div>
        <div>
          <label className="label" htmlFor="r-role">Role</label>
          <select id="r-role" className="input" value={role} onChange={(e) => setRole(e.target.value)}>
            {ROSTER_ROLES.map((r) => (
              <option key={r} value={r}>{r}</option>
            ))}
          </select>
        </div>
        <div>
          <label className="label" htmlFor="r-shift">Shift</label>
          <select id="r-shift" className="input" value={shift} onChange={(e) => setShift(e.target.value)}>
            <option value="">No shift</option>
            {ROSTER_SHIFTS.map((s) => (
              <option key={s} value={s}>{s}</option>
            ))}
          </select>
          <p className="mt-1 hint">CSRs and shift leads sit under their shift. Leave blank for the CEO or PM.</p>
        </div>
        <div>
          <label className="label" htmlFor="r-off">Day off</label>
          <select id="r-off" className="input" value={offDay} onChange={(e) => setOffDay(e.target.value)}>
            <option value="">Not set</option>
            {OFF_DAYS.map((d) => (
              <option key={d} value={d}>{d}</option>
            ))}
          </select>
        </div>
        <label className="flex items-center gap-2.5 text-sm">
          <input type="checkbox" checked={active} onChange={(e) => setActive(e.target.checked)} />
          Show in the handbook
        </label>
        {error && <InlineError>{error}</InlineError>}
      </div>
    </Modal>
  )
}
