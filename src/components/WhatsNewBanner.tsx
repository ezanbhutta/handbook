import { Link } from 'react-router-dom'
import { useLatestChange } from '@/lib/queries'
import { timeAgo } from '@/lib/format'
import { Icon } from './Icon'

const TYPE_LABEL = { created: 'New', updated: 'Updated', deleted: 'Removed' } as const

// The most recent change the current user is allowed to see. Persists until a
// newer entry replaces it — no expiry (brief §8). Permission-filtered by RLS.
export function WhatsNewBanner() {
  const { data: change, isLoading } = useLatestChange()

  if (isLoading || !change) return null

  const linkable = change.section?.slug && change.type !== 'deleted'

  const inner = (
    <div className="flex items-start gap-3">
      <span className="mt-0.5 grid h-9 w-9 shrink-0 place-items-center rounded-full bg-brand text-brand-fg">
        <Icon name="sparkles" size={18} />
      </span>
      <div className="min-w-0 flex-1">
        <div className="flex items-center gap-2">
          <span className="text-xs font-bold uppercase tracking-wide text-brand">What’s New</span>
          <span className="chip-brand !py-0.5">{TYPE_LABEL[change.type]}</span>
          <span className="text-xs text-muted">{timeAgo(change.created_at)}</span>
        </div>
        <p className="mt-1 font-semibold text-fg">{change.section_title ?? 'Handbook update'}</p>
        <p className="line-clamp-2 text-sm text-fg/80">{change.summary}</p>
      </div>
      {linkable ? (
        <Icon name="chevron-right" size={20} className="mt-2 shrink-0 text-muted" />
      ) : null}
    </div>
  )

  return (
    <section
      aria-label="What's new"
      className="rounded-2xl border border-brand/30 bg-gradient-to-br from-brand-soft/70 to-surface p-4 shadow-sm"
    >
      {linkable ? (
        <Link
          to={`/section/${change.section!.slug}`}
          className="block rounded-xl transition-colors hover:opacity-90"
        >
          {inner}
        </Link>
      ) : (
        inner
      )}
      <div className="mt-3 flex justify-end border-t border-brand/15 pt-2.5">
        <Link
          to="/whats-new"
          className="inline-flex items-center gap-1 text-sm font-medium text-brand hover:underline"
        >
          See all changes
          <Icon name="chevron-right" size={15} />
        </Link>
      </div>
    </section>
  )
}
