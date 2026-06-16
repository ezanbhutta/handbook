import { Icon, type IconName } from '@/components/Icon'

// Phase 2 stub (brief §6, §11). The page exists now so the route and nav are
// stable; the Gap Report and corrections queue get wired up once content exists.
const PLANNED: { icon: IconName; title: string; desc: string }[] = [
  {
    icon: 'search',
    title: 'Search Gap Report',
    desc: 'Top searches that returned nothing or were never clicked — straight from the silent search log we already collect.',
  },
  {
    icon: 'sparkles',
    title: 'Conflict check on publish',
    desc: 'An Edge Function sends a draft + related sections to the Anthropic API and flags contradictions in plain English. You decide.',
  },
  {
    icon: 'edit',
    title: 'Corrections queue',
    desc: 'Staff flag a section as outdated or unclear; suggestions land here for you to action.',
  },
  {
    icon: 'book',
    title: 'Knowledge dump → draft',
    desc: 'Paste raw experience; it’s classified into a chapter and proposed as a draft section for review.',
  },
]

export function AdminInsights() {
  return (
    <div>
      <div className="mb-6 flex items-start gap-3 rounded-2xl border border-brand/30 bg-brand-soft/40 p-4">
        <Icon name="sparkles" size={22} className="mt-0.5 shrink-0 text-brand" />
        <div>
          <h2 className="font-bold">Intelligence layer — Phase 2</h2>
          <p className="mt-1 text-sm text-muted">
            Phase 1 already logs every search silently, so this report has data waiting the moment
            it’s switched on. These build on top of the shipping core.
          </p>
        </div>
      </div>

      <div className="grid gap-3 sm:grid-cols-2">
        {PLANNED.map((f) => (
          <div key={f.title} className="rounded-2xl border border-dashed border-border bg-surface p-4">
            <div className="flex items-center gap-2.5">
              <span className="grid h-9 w-9 place-items-center rounded-xl bg-surface-2 text-muted">
                <Icon name={f.icon} size={18} />
              </span>
              <h3 className="font-semibold">{f.title}</h3>
            </div>
            <p className="mt-2 text-sm text-muted">{f.desc}</p>
            <span className="chip mt-3">Planned</span>
          </div>
        ))}
      </div>
    </div>
  )
}
