import { Link } from 'react-router-dom'
import { useAdminChapters, useAdminSections } from '@/lib/admin'
import { useChangeLog } from '@/lib/queries'
import { formatDateTime } from '@/lib/format'
import { Icon, type IconName } from '@/components/Icon'

function StatCard({ icon, label, value, to }: { icon: IconName; label: string; value: number | string; to: string }) {
  return (
    <Link
      to={to}
      className="flex items-center gap-3 rounded-2xl border border-border bg-surface p-4 transition-colors hover:border-brand/40 hover:bg-surface-2"
    >
      <span className="grid h-11 w-11 place-items-center rounded-xl bg-brand-soft text-brand">
        <Icon name={icon} size={22} />
      </span>
      <div>
        <p className="text-2xl font-bold leading-none">{value}</p>
        <p className="text-sm text-muted">{label}</p>
      </div>
    </Link>
  )
}

export function AdminHome() {
  const { data: chapters = [] } = useAdminChapters()
  const { data: sections = [] } = useAdminSections()
  const { data: changes = [] } = useChangeLog()

  return (
    <div className="space-y-7">
      <section>
        <h2 className="sr-only">Overview</h2>
        <div className="grid gap-3 sm:grid-cols-3">
          <StatCard icon="list" label="Chapters" value={chapters.length} to="/admin/chapters" />
          <StatCard icon="book" label="Sections" value={sections.length} to="/admin/sections" />
          <StatCard icon="sparkles" label="Changes logged" value={changes.length} to="/whats-new" />
        </div>
      </section>

      <section>
        <h2 className="mb-3 text-sm font-semibold uppercase tracking-wide text-muted">
          Quick actions
        </h2>
        <div className="flex flex-wrap gap-2.5">
          <Link to="/admin/sections/new" className="btn-primary">
            <Icon name="plus" size={18} /> New section
          </Link>
          <Link to="/admin/chapters" className="btn-secondary">
            <Icon name="list" size={18} /> Manage chapters
          </Link>
          <Link to="/admin/users" className="btn-secondary">
            <Icon name="users" size={18} /> Add a user
          </Link>
        </div>
      </section>

      <section>
        <h2 className="mb-3 text-sm font-semibold uppercase tracking-wide text-muted">
          Recent changes
        </h2>
        {changes.length === 0 ? (
          <p className="text-sm text-muted">No changes yet. Publish a section to get started.</p>
        ) : (
          <ul className="divide-y divide-border overflow-hidden rounded-2xl border border-border bg-surface">
            {changes.slice(0, 8).map((c) => (
              <li key={c.id} className="flex items-center gap-3 px-4 py-3">
                <span className="chip shrink-0">{c.type}</span>
                <span className="min-w-0 flex-1 truncate text-sm font-medium">
                  {c.section_title ?? 'Update'}
                </span>
                <span className="shrink-0 text-xs text-muted">{formatDateTime(c.created_at)}</span>
              </li>
            ))}
          </ul>
        )}
      </section>
    </div>
  )
}
