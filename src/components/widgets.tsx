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

function chips(list: string | undefined) {
  if (!list) return null
  return (
    <div className="mt-1.5 flex flex-wrap justify-center gap-1">
      {list
        .split(',')
        .map((p) => p.trim())
        .filter(Boolean)
        .map((p) => (
          <span key={p} className="chip-brand">
            {p}
          </span>
        ))}
    </div>
  )
}

// A top-down org chart: each level is a card, joined by a connector line.
export function OrgChart({ raw }: { raw: string }) {
  const levels = rows(raw)
  return (
    <div className="my-7 flex flex-col items-center">
      {levels.map((lvl, i) => (
        <div key={i} className="flex w-full flex-col items-center">
          <div className="w-full max-w-sm rounded-2xl border border-brand/30 bg-gradient-to-br from-brand-soft/70 to-surface p-4 text-center shadow-soft">
            <p className="font-serif text-lg font-bold text-fg">{lvl[0]}</p>
            {chips(lvl[1])}
            {lvl[2] && <p className="mt-2 text-sm text-muted">{lvl[2]}</p>}
          </div>
          {i < levels.length - 1 && (
            <div className="flex flex-col items-center" aria-hidden="true">
              <span className="h-6 w-px bg-brand/40" />
              <span className="-mt-1 h-2 w-2 rounded-full bg-brand/50" />
            </div>
          )}
        </div>
      ))}
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
    <div className="my-6 grid gap-3 sm:grid-cols-3">
      {data.map((s, i) => {
        const theme = SHIFT_THEME[s[0]?.toLowerCase()] ?? { color: 'rgb(114 41 255)', icon: 'calendar' as IconName }
        const members = (s[3] ?? '')
          .split(',')
          .map((m) => m.trim())
          .filter(Boolean)
        return (
          <div key={i} className="overflow-hidden rounded-2xl border border-border bg-surface shadow-soft">
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
                <ul className="mt-2 space-y-0.5">
                  {members.map((m) => (
                    <li key={m} className="flex items-center gap-2 text-sm text-fg/90">
                      <span className="h-1.5 w-1.5 shrink-0 rounded-full" style={{ background: theme.color }} />
                      {m}
                    </li>
                  ))}
                </ul>
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
  return (
    <div className="my-6 grid gap-3 sm:grid-cols-3">
      {data.map((s, i) => (
        <div
          key={i}
          className="rounded-2xl border border-border bg-gradient-to-br from-brand-soft/50 to-surface p-4 text-center shadow-soft"
        >
          <p className="font-serif text-3xl font-bold text-brand">{s[0]}</p>
          {s[1] && <p className="mt-1 text-sm text-muted">{s[1]}</p>}
        </div>
      ))}
    </div>
  )
}

const WIDGETS: Record<string, (raw: string) => JSX.Element> = {
  orgchart: (raw) => <OrgChart raw={raw} />,
  shiftcards: (raw) => <ShiftCards raw={raw} />,
  stats: (raw) => <Stats raw={raw} />,
}

// Returns a widget renderer for a `language-xxx` className, or null.
export function widgetFor(className: string | undefined): ((raw: string) => JSX.Element) | null {
  const match = /language-(\w+)/.exec(className ?? '')
  const name = match?.[1]
  return name && name in WIDGETS ? WIDGETS[name] : null
}
