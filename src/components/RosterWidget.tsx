import { useRoster } from '@/lib/roster'
import { Icon, type IconName } from './Icon'

// Renders the team live from the roster table: a hierarchy by role, then a card
// per shift listing its lead and members with their day off. Because it reads
// the roster, removing someone there removes them here too.

const SHIFT_META: Record<string, { color: string; hours: string; icon: IconName }> = {
  Morning: { color: '#F59E0B', hours: '9:00 AM to 5:00 PM', icon: 'sun' },
  Evening: { color: '#0EA5E9', hours: '5:00 PM to 1:00 AM', icon: 'sun' },
  Night: { color: '#7229FF', hours: '1:00 AM to 9:00 AM', icon: 'moon' },
}
const SHIFT_ORDER = ['Morning', 'Evening', 'Night']

const LEVELS = [
  { roles: ['CEO'], label: 'CEO and Founder', note: 'Final calls, scores, and the big decisions.' },
  {
    roles: ['Team Leader', 'Senior'],
    label: 'Team Leaders and Seniors',
    note: 'Run the shifts, handle escalations and cancellations, and coach the team.',
  },
  {
    roles: ['Project Manager'],
    label: 'Project Manager',
    note: 'Keeps work moving between the CSRs and the designers.',
  },
  { roles: ['CSR'], label: 'CSRs', note: 'Own the client conversation and the order, start to finish.' },
]

export function RosterWidget() {
  const { data: roster = [], isLoading } = useRoster()

  if (isLoading) {
    return <div className="my-8 h-48 animate-pulse rounded-2xl bg-surface-2" />
  }

  const byRoles = (roles: string[]) => roster.filter((r) => roles.includes(r.role))
  const csrCount = byRoles(['CSR']).length

  const levels = LEVELS.map((l) => ({
    ...l,
    isCsr: l.roles.includes('CSR'),
    people: l.roles.includes('CSR') ? [] : byRoles(l.roles),
  })).filter((l) => l.isCsr || l.people.length > 0)

  return (
    <div className="my-8 space-y-8">
      {/* Hierarchy */}
      <div className="flex flex-col items-center">
        {levels.map((lvl, i) => (
          <div key={lvl.label} className="flex w-full flex-col items-center">
            <div className="relative w-full max-w-md overflow-hidden rounded-2xl border border-brand/20 bg-surface text-center shadow-soft">
              <div className="h-1.5 w-full bg-gradient-to-r from-brand via-brand/70 to-brand/40" />
              <div className="p-5">
                <p className="font-serif text-xl font-bold leading-tight text-fg">{lvl.label}</p>
                {lvl.people.length > 0 && (
                  <div className="mt-3 flex flex-wrap justify-center gap-1.5">
                    {lvl.people.map((p) => (
                      <span
                        key={p.id}
                        className="inline-flex items-center rounded-full border border-brand/20 bg-brand-soft/50 px-3 py-1 text-sm font-medium text-brand"
                      >
                        {p.name}
                      </span>
                    ))}
                  </div>
                )}
                {lvl.isCsr && csrCount > 0 && (
                  <p className="mt-2 text-sm font-semibold text-brand">
                    {csrCount} across three shifts
                  </p>
                )}
                <p className="mx-auto mt-3 max-w-sm text-sm leading-relaxed text-muted">{lvl.note}</p>
              </div>
            </div>
            {i < levels.length - 1 && (
              <div className="flex h-8 flex-col items-center justify-center" aria-hidden="true">
                <span className="h-full w-0.5 rounded bg-gradient-to-b from-brand/50 to-brand/15" />
              </div>
            )}
          </div>
        ))}
      </div>

      {/* Shifts */}
      <div className="grid gap-3 sm:grid-cols-2 lg:grid-cols-3">
        {SHIFT_ORDER.map((shift) => {
          const meta = SHIFT_META[shift]
          const leads = roster.filter(
            (r) => r.shift === shift && (r.role === 'Team Leader' || r.role === 'Senior'),
          )
          const members = roster.filter((r) => r.shift === shift && r.role === 'CSR')
          if (!leads.length && !members.length) return null
          return (
            <div
              key={shift}
              className="overflow-hidden rounded-2xl border border-border bg-surface shadow-soft transition duration-200 hover:-translate-y-0.5 hover:shadow-brand"
            >
              <div className="h-1.5" style={{ background: meta.color }} />
              <div className="p-4">
                <div className="flex items-center gap-2">
                  <span
                    className="grid h-8 w-8 place-items-center rounded-lg text-white"
                    style={{ background: meta.color }}
                  >
                    <Icon name={meta.icon} size={17} />
                  </span>
                  <div>
                    <p className="font-serif text-lg font-bold leading-none">{shift}</p>
                    <p className="mt-0.5 text-xs text-muted">{meta.hours}</p>
                  </div>
                </div>
                {leads.length > 0 && (
                  <p className="mt-3 text-sm">
                    <span className="text-muted">Lead: </span>
                    <span className="font-medium">{leads.map((l) => l.name).join(', ')}</span>
                  </p>
                )}
                {members.length > 0 && (
                  <ul className="mt-2 space-y-1.5">
                    {members.map((m) => (
                      <li key={m.id} className="flex items-center justify-between gap-2 text-sm">
                        <span className="flex items-center gap-2 text-fg/90">
                          <span
                            className="h-1.5 w-1.5 shrink-0 rounded-full"
                            style={{ background: meta.color }}
                          />
                          {m.name}
                        </span>
                        {m.off_day && (
                          <span className="shrink-0 rounded-full bg-surface-2 px-2 py-0.5 text-xs text-muted">
                            Off {m.off_day}
                          </span>
                        )}
                      </li>
                    ))}
                  </ul>
                )}
              </div>
            </div>
          )
        })}
      </div>
    </div>
  )
}
