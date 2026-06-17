import { Link } from 'react-router-dom'
import { useChangeLog, type ChangeView } from '@/lib/queries'
import { formatDateTime } from '@/lib/format'
import { Icon, type IconName } from '@/components/Icon'
import { PulseMotif } from '@/components/PulseMotif'
import { LoadingState, ErrorState, EmptyState } from '@/components/States'

const TYPE_META: Record<
  ChangeView['type'],
  { label: string; icon: IconName; node: string; chip: string }
> = {
  created: { label: 'New', icon: 'plus', node: 'bg-success text-white', chip: 'bg-success/15 text-success' },
  updated: { label: 'Updated', icon: 'edit', node: 'bg-brand text-brand-fg', chip: 'bg-brand-soft text-brand' },
  deleted: { label: 'Removed', icon: 'trash', node: 'bg-danger text-white', chip: 'bg-danger-soft text-danger' },
}

function Entry({ entry, last, index }: { entry: ChangeView; last: boolean; index: number }) {
  const meta = TYPE_META[entry.type]
  const linkable = entry.section?.slug && entry.type !== 'deleted'

  const inner = (
    <>
      <div className="flex flex-wrap items-center gap-2">
        <span className="font-serif text-lg font-semibold text-fg">
          {entry.section_title ?? 'Handbook update'}
        </span>
        <span className={`chip !py-0.5 ${meta.chip}`}>{meta.label}</span>
      </div>
      <p className="mt-1 text-sm text-fg/80">{entry.summary}</p>
      <p className="mt-1.5 text-xs text-muted">{formatDateTime(entry.created_at)}</p>
    </>
  )

  return (
    <li
      className="animate-rise relative pl-14"
      style={{ animationDelay: `${Math.min(index * 45, 360)}ms` }}
    >
      {/* Timeline node + connecting rail */}
      <span
        className={`absolute left-3 top-1 grid h-8 w-8 place-items-center rounded-full shadow-soft ring-4 ring-surface ${meta.node}`}
      >
        <Icon name={meta.icon} size={15} />
      </span>
      {!last && <span className="absolute left-7 top-9 -bottom-4 w-px bg-border" aria-hidden="true" />}

      {linkable ? (
        <Link
          to={`/section/${entry.section!.slug}`}
          className="group block rounded-2xl border border-border bg-surface p-4 transition duration-200 hover:-translate-y-0.5 hover:border-brand/40 hover:shadow-soft"
        >
          {inner}
        </Link>
      ) : (
        <div className="rounded-2xl border border-border bg-surface p-4">{inner}</div>
      )}
    </li>
  )
}

export function WhatsNew() {
  const { data: entries = [], isLoading, error } = useChangeLog()

  return (
    <div className="book-page overflow-hidden">
      <header className="cover-aurora relative -mx-6 -mt-10 mb-8 overflow-hidden rounded-t-2xl px-6 pb-8 pt-10 sm:-mx-12 sm:-mt-14 sm:px-12 sm:pb-9 sm:pt-12 lg:-mx-16 lg:px-16">
        <div className="flex items-center gap-3">
          <span className="grid h-12 w-12 shrink-0 place-items-center rounded-2xl bg-brand text-brand-fg shadow-soft">
            <Icon name="sparkles" size={26} />
          </span>
          <div>
            <p className="eyebrow">The handbook, kept current</p>
            <PulseMotif height={13} className="mt-1.5 text-brand" />
          </div>
        </div>
        <h1 className="mt-4 font-serif text-3xl font-bold tracking-tight sm:text-[2.4rem]">
          What’s New
        </h1>
        <p className="mt-2 text-muted">Every recent change you can see, newest first.</p>
      </header>

      {isLoading ? (
        <LoadingState />
      ) : error ? (
        <ErrorState error={error} />
      ) : entries.length === 0 ? (
        <EmptyState icon="sparkles" title="No changes yet">
          When your admin publishes or updates a section, it’ll show up here.
        </EmptyState>
      ) : (
        <ol className="space-y-4">
          {entries.map((e, i) => (
            <Entry key={e.id} entry={e} index={i} last={i === entries.length - 1} />
          ))}
        </ol>
      )}
    </div>
  )
}
