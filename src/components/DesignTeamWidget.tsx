import { useRoster, type RosterMember } from '@/lib/roster'

// Lists the design team live from the roster, grouped by craft, with each
// person's working time when it is set. Reads the same roster the admin edits,
// so adding, editing, or removing a designer updates this immediately.
const SPECIALTY_ORDER = ['Branding', 'Logo', 'Animation', 'PPT Designer', 'Canva Designer']

export function DesignTeamWidget() {
  const { data: roster = [], isLoading } = useRoster()

  if (isLoading) {
    return <div className="my-6 h-40 animate-pulse rounded-2xl bg-surface-2" />
  }

  const designers = roster.filter((r) => r.role === 'Designer')
  if (!designers.length) return null

  const groups = new Map<string, RosterMember[]>()
  for (const d of designers) {
    const key = d.specialty?.trim() || 'Design'
    if (!groups.has(key)) groups.set(key, [])
    groups.get(key)!.push(d)
  }
  const ordered = [...groups.entries()].sort((a, b) => {
    const ia = SPECIALTY_ORDER.indexOf(a[0])
    const ib = SPECIALTY_ORDER.indexOf(b[0])
    return (ia === -1 ? 99 : ia) - (ib === -1 ? 99 : ib)
  })

  return (
    <div className="my-6 grid gap-3 sm:grid-cols-2">
      {ordered.map(([specialty, members]) => (
        <div key={specialty} className="overflow-hidden rounded-2xl border border-border bg-surface shadow-soft">
          <div className="border-b border-border bg-brand-soft/40 px-4 py-2.5">
            <p className="font-serif text-base font-bold text-brand">{specialty}</p>
            <p className="text-xs text-muted">
              {members.length} {members.length === 1 ? 'designer' : 'designers'}
            </p>
          </div>
          <ul className="divide-y divide-border">
            {members.map((m) => (
              <li key={m.id} className="flex items-center justify-between gap-2 px-4 py-2 text-sm">
                <span className="font-medium text-fg">{m.name}</span>
                {m.working_time && (
                  <span className="shrink-0 rounded-full bg-surface-2 px-2 py-0.5 text-xs text-muted">
                    {m.working_time}
                  </span>
                )}
              </li>
            ))}
          </ul>
        </div>
      ))}
    </div>
  )
}
