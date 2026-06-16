import { Link } from 'react-router-dom'
import { useChangeLog, type ChangeLogEntryWithSlug } from '@/lib/queries'
import { formatDateTime } from '@/lib/format'
import { Icon } from '@/components/Icon'
import { LoadingState, ErrorState, EmptyState } from '@/components/States'

const TYPE_META = {
  created: { label: 'New', icon: 'plus', cls: 'bg-success/15 text-success' },
  updated: { label: 'Updated', icon: 'edit', cls: 'bg-brand-soft text-brand' },
  deleted: { label: 'Removed', icon: 'trash', cls: 'bg-danger-soft text-danger' },
} as const

function Entry({ entry }: { entry: ChangeLogEntryWithSlug }) {
  const meta = TYPE_META[entry.type]
  const linkable = entry.section?.slug && entry.type !== 'deleted'

  const body = (
    <div className="flex gap-3.5">
      <span
        className={`mt-0.5 grid h-9 w-9 shrink-0 place-items-center rounded-full ${meta.cls}`}
      >
        <Icon name={meta.icon} size={16} />
      </span>
      <div className="min-w-0 flex-1">
        <div className="flex flex-wrap items-center gap-2">
          <span className="font-semibold text-fg">
            {entry.section_title ?? 'Handbook update'}
          </span>
          <span className={`chip !py-0.5 ${meta.cls}`}>{meta.label}</span>
        </div>
        <p className="mt-0.5 text-sm text-fg/80">{entry.summary}</p>
        <p className="mt-1 text-xs text-muted">{formatDateTime(entry.created_at)}</p>
      </div>
      {linkable && <Icon name="chevron-right" size={18} className="mt-2 shrink-0 text-muted" />}
    </div>
  )

  return (
    <li>
      {linkable ? (
        <Link
          to={`/section/${entry.section!.slug}`}
          className="block rounded-2xl border border-border bg-surface p-4 transition-colors hover:border-brand/40 hover:bg-surface-2"
        >
          {body}
        </Link>
      ) : (
        <div className="rounded-2xl border border-border bg-surface p-4">{body}</div>
      )}
    </li>
  )
}

export function WhatsNew() {
  const { data: entries = [], isLoading, error } = useChangeLog()

  return (
    <div className="mx-auto max-w-3xl">
      <header className="mb-6 flex items-start gap-4">
        <span className="grid h-12 w-12 shrink-0 place-items-center rounded-2xl bg-brand-soft text-brand">
          <Icon name="sparkles" size={26} />
        </span>
        <div>
          <h1 className="text-2xl font-bold tracking-tight sm:text-3xl">What’s New</h1>
          <p className="mt-1.5 text-muted">
            Every recent change to the handbook you can see, newest first.
          </p>
        </div>
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
        <ul className="space-y-3">
          {entries.map((e) => (
            <Entry key={e.id} entry={e} />
          ))}
        </ul>
      )}
    </div>
  )
}
