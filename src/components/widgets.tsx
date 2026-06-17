import { Icon, type IconName } from './Icon'

// Visual blocks embedded in section markdown via fenced code blocks, e.g.
//   ```orgchart
//   CEO | Abdul Haseeb | Final calls
//   ```
// Each line is pipe-delimited. Parsing is intentionally simple so content stays
// easy to write in the authoring screen.

function rows(raw: string): string[][] {
  return raw
    .trim()
    .split('\n')
    .map((line) => line.split('|').map((c) => c.trim()))
    .filter((r) => r[0])
}

function initials(name: string): string {
  const parts = name.trim().split(/\s+/).filter(Boolean)
  const first = parts[0]?.[0] ?? ''
  const last = parts.length > 1 ? parts[parts.length - 1][0] : ''
  return (first + last).toUpperCase()
}

function people(list: string | undefined): string[] {
  return (list ?? '')
    .split(',')
    .map((p) => p.trim())
    .filter(Boolean)
}

// A top-down org chart: each level is a centred card with avatar chips for the
// people, joined by a clean connector. Scales from one column on phones up.
export function OrgChart({ raw }: { raw: string }) {
  const levels = rows(raw)
  return (
    <div className="my-8 flex flex-col items-center">
      {levels.map((lvl, i) => {
        const team = people(lvl[1])
        return (
          <div key={i} className="flex w-full flex-col items-center">
            <div className="relative w-full max-w-md overflow-hidden rounded-2xl border border-brand/20 bg-surface text-center shadow-soft transition duration-200 hover:-translate-y-0.5 hover:shadow-brand">
              <div className="h-1.5 w-full bg-gradient-to-r from-brand via-brand/70 to-brand/40" />
              <div className="p-5">
                <div className="flex items-center justify-center gap-2">
                  <span className="grid h-6 w-6 shrink-0 place-items-center rounded-full bg-brand-soft text-[11px] font-bold text-brand">
                    {i + 1}
                  </span>
                  <p className="font-serif text-xl font-bold leading-tight text-fg">{lvl[0]}</p>
                </div>
                {team.length > 0 && (
                  <div className="mt-3 flex flex-wrap justify-center gap-1.5">
                    {team.map((p) => (
                      <span
                        key={p}
                        className="inline-flex items-center gap-1.5 rounded-full border border-brand/20 bg-brand-soft/50 py-1 pl-1 pr-2.5 text-sm font-medium text-brand"
                      >
                        <span className="grid h-5 w-5 shrink-0 place-items-center rounded-full bg-brand text-[10px] font-bold text-brand-fg">
                          {initials(p)}
                        </span>
                        {p}
                      </span>
                    ))}
                  </div>
                )}
                {lvl[2] && (
                  <p className="mx-auto mt-3 max-w-sm text-sm leading-relaxed text-muted">{lvl[2]}</p>
                )}
              </div>
            </div>
            {i < levels.length - 1 && (
              <div className="flex h-8 flex-col items-center justify-center" aria-hidden="true">
                <span className="h-full w-0.5 rounded bg-gradient-to-b from-brand/50 to-brand/15" />
              </div>
            )}
          </div>
        )
      })}
    </div>
  )
}

// Colourful per-shift cards: Shift | Hours | Leader | Member, Member, …
const SHIFT_THEME: Record<string, { color: string; icon: IconName }> = {
  morning: { color: '#F59E0B', icon: 'sun' },
  evening: { color: '#0EA5E9', icon: 'sun' },
  night: { color: '#7229FF', icon: 'moon' },
}

export function ShiftCards({ raw }: { raw: string }) {
  const data = rows(raw)
  return (
    <div className="my-6 grid gap-3 sm:grid-cols-2 lg:grid-cols-3">
      {data.map((s, i) => {
        const theme = SHIFT_THEME[s[0]?.toLowerCase()] ?? { color: '#7229FF', icon: 'calendar' as IconName }
        const members = (s[3] ?? '')
          .split(',')
          .map((m) => m.trim())
          .filter(Boolean)
        return (
          <div
            key={i}
            className="overflow-hidden rounded-2xl border border-border bg-surface shadow-soft transition duration-200 hover:-translate-y-0.5 hover:shadow-brand"
          >
            <div className="h-1.5" style={{ background: theme.color }} />
            <div className="p-4">
              <div className="flex items-center gap-2">
                <span
                  className="grid h-8 w-8 place-items-center rounded-lg text-white"
                  style={{ background: theme.color }}
                >
                  <Icon name={theme.icon} size={17} />
                </span>
                <div>
                  <p className="font-serif text-lg font-bold leading-none">{s[0]}</p>
                  {s[1] && <p className="mt-0.5 text-xs text-muted">{s[1]}</p>}
                </div>
              </div>
              {s[2] && (
                <p className="mt-3 text-sm">
                  <span className="text-muted">Lead: </span>
                  <span className="font-medium">{s[2]}</span>
                </p>
              )}
              {members.length > 0 && (
                <div className="mt-3 flex flex-wrap gap-1.5">
                  {members.map((m) => (
                    <span
                      key={m}
                      className="inline-flex items-center gap-1.5 rounded-full py-1 pl-1 pr-2.5 text-sm font-medium"
                      style={{ backgroundColor: `${theme.color}16`, color: theme.color }}
                    >
                      <span
                        className="grid h-5 w-5 shrink-0 place-items-center rounded-full text-[10px] font-bold text-white"
                        style={{ background: theme.color }}
                      >
                        {initials(m)}
                      </span>
                      {m}
                    </span>
                  ))}
                </div>
              )}
            </div>
          </div>
        )
      })}
    </div>
  )
}

// A row of stat tiles: Value | Label
export function Stats({ raw }: { raw: string }) {
  const data = rows(raw)
  const cols = data.length === 4 ? 'sm:grid-cols-4' : data.length === 2 ? 'sm:grid-cols-2' : 'sm:grid-cols-3'
  return (
    <div className={`my-6 grid grid-cols-2 gap-3 ${cols}`}>
      {data.map((s, i) => (
        <div
          key={i}
          className="rounded-2xl border border-border bg-gradient-to-br from-brand-soft/50 to-surface p-4 text-center shadow-soft transition duration-200 hover:-translate-y-0.5 hover:shadow-brand"
        >
          <p className="font-serif text-3xl font-bold leading-none text-brand">{s[0]}</p>
          {s[1] && <p className="mt-1.5 text-sm text-muted">{s[1]}</p>}
        </div>
      ))}
    </div>
  )
}

// A vertical numbered step flow: Title | Description
export function Steps({ raw }: { raw: string }) {
  const data = rows(raw)
  return (
    <ol className="my-6">
      {data.map((s, i) => (
        <li key={i} className="flex gap-4">
          <div className="flex flex-col items-center">
            <span className="grid h-9 w-9 shrink-0 place-items-center rounded-full bg-gradient-to-br from-brand to-brand/70 text-sm font-bold text-brand-fg shadow-soft ring-4 ring-brand-soft/50">
              {i + 1}
            </span>
            {i < data.length - 1 && (
              <span className="my-1.5 w-0.5 grow rounded bg-gradient-to-b from-brand/40 to-border" />
            )}
          </div>
          <div className="pb-7 pt-1">
            <p className="font-semibold text-fg">{s[0]}</p>
            {s[1] && <p className="mt-1 text-sm leading-relaxed text-muted">{s[1]}</p>}
          </div>
        </li>
      ))}
    </ol>
  )
}

// A checklist with green ticks: one item per line.
export function Checklist({ raw }: { raw: string }) {
  const data = rows(raw)
  return (
    <ul className="my-6 space-y-2">
      {data.map((item, i) => (
        <li
          key={i}
          className="flex items-start gap-3 rounded-xl border border-border bg-surface-2/40 p-3"
        >
          <span className="mt-0.5 grid h-6 w-6 shrink-0 place-items-center rounded-full bg-success/15 text-success">
            <Icon name="check" size={14} />
          </span>
          <span className="text-fg/90">{item[0]}</span>
        </li>
      ))}
    </ul>
  )
}

// A styled spec / definition list: Label | Value
export function KeyValue({ raw }: { raw: string }) {
  const data = rows(raw)
  return (
    <dl className="my-6 divide-y divide-border overflow-hidden rounded-2xl border border-border">
      {data.map((r, i) => (
        <div key={i} className="flex items-center justify-between gap-4 px-4 py-3">
          <dt className="text-sm text-muted">{r[0]}</dt>
          <dd className="text-right font-medium text-fg">{r[1]}</dd>
        </div>
      ))}
    </dl>
  )
}

// Do / don't comparison cards: [Label] | Say/Do | Not.
export function DoDont({ raw }: { raw: string }) {
  const data = rows(raw)
  return (
    <div className="my-6 space-y-3">
      {data.map((r, i) => {
        const hasLabel = r.length >= 3
        const label = hasLabel ? r[0] : ''
        const good = hasLabel ? r[1] : r[0]
        const bad = hasLabel ? r[2] : r[1]
        return (
          <div key={i} className="overflow-hidden rounded-2xl border border-border bg-surface">
            {label && <div className="border-b border-border bg-surface-2/60 px-4 py-2 font-medium">{label}</div>}
            <div className="grid divide-y divide-border sm:grid-cols-2 sm:divide-x sm:divide-y-0">
              <div className="p-3.5">
                <span className="chip !bg-success/15 !text-success">
                  <Icon name="check" size={13} /> Do
                </span>
                <p className="mt-1.5 text-sm text-fg/90">{good}</p>
              </div>
              <div className="p-3.5">
                <span className="chip !bg-danger-soft !text-danger">
                  <Icon name="close" size={13} /> Not
                </span>
                <p className="mt-1.5 text-sm text-muted">{bad}</p>
              </div>
            </div>
          </div>
        )
      })}
    </div>
  )
}

const WIDGETS: Record<string, (raw: string) => JSX.Element> = {
  orgchart: (raw) => <OrgChart raw={raw} />,
  shiftcards: (raw) => <ShiftCards raw={raw} />,
  stats: (raw) => <Stats raw={raw} />,
  steps: (raw) => <Steps raw={raw} />,
  checklist: (raw) => <Checklist raw={raw} />,
  keyvalue: (raw) => <KeyValue raw={raw} />,
  dodont: (raw) => <DoDont raw={raw} />,
}

// Returns a widget renderer for a `language-xxx` className, or null.
export function widgetFor(className: string | undefined): ((raw: string) => JSX.Element) | null {
  const match = /language-(\w+)/.exec(className ?? '')
  const name = match?.[1]
  return name && name in WIDGETS ? WIDGETS[name] : null
}
