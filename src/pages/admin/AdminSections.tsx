import { Link } from 'react-router-dom'
import { useMutation, useQueryClient } from '@tanstack/react-query'
import { useAuth } from '@/lib/auth'
import {
  useAdminChapters,
  useAdminSections,
  updateSectionOrder,
  deleteSection,
  type AdminSectionRow,
} from '@/lib/admin'
import { Icon } from '@/components/Icon'
import { VisibilityBadge } from '@/components/Visibility'
import { LoadingState, EmptyState } from '@/components/States'

export function AdminSections() {
  const qc = useQueryClient()
  const { profile } = useAuth()
  const { data: chapters = [], isLoading: chaptersLoading } = useAdminChapters()
  const { data: sections = [], isLoading } = useAdminSections()

  const invalidate = () => {
    void qc.invalidateQueries({ queryKey: ['admin', 'sections'] })
    void qc.invalidateQueries({ queryKey: ['navigation'] })
  }

  const reorder = useMutation({
    mutationFn: async ({ a, b }: { a: AdminSectionRow; b: AdminSectionRow }) => {
      await updateSectionOrder(a.id, b.order_index)
      await updateSectionOrder(b.id, a.order_index)
    },
    onSuccess: invalidate,
  })

  const remove = useMutation({
    mutationFn: (s: AdminSectionRow) => deleteSection(s, profile!.id),
    onSuccess: () => {
      invalidate()
      void qc.invalidateQueries({ queryKey: ['change_log'] })
    },
  })

  if (isLoading || chaptersLoading) return <LoadingState />

  return (
    <div>
      <div className="mb-4 flex items-center justify-between">
        <p className="text-sm text-muted">
          {sections.length} {sections.length === 1 ? 'section' : 'sections'}
        </p>
        <Link to="/admin/sections/new" className="btn-primary">
          <Icon name="plus" size={18} /> New section
        </Link>
      </div>

      {sections.length === 0 ? (
        <EmptyState icon="book" title="No sections yet">
          Create your first section to start filling the handbook.
        </EmptyState>
      ) : (
        <div className="space-y-6">
          {chapters.map((chapter) => {
            const rows = sections
              .filter((s) => s.chapter_id === chapter.id)
              .sort((a, b) => a.order_index - b.order_index)
            if (rows.length === 0) return null
            return (
              <section key={chapter.id}>
                <h2 className="mb-2 px-1 text-sm font-semibold uppercase tracking-wide text-muted">
                  {chapter.title}
                </h2>
                <ul className="space-y-2">
                  {rows.map((s, i) => (
                    <li
                      key={s.id}
                      className="flex items-center gap-2 rounded-2xl border border-border bg-surface p-3"
                    >
                      <div className="flex flex-col">
                        <button
                          aria-label="Move up"
                          disabled={i === 0 || reorder.isPending}
                          onClick={() => reorder.mutate({ a: s, b: rows[i - 1] })}
                          className="grid h-6 w-7 place-items-center rounded text-muted hover:bg-surface-2 disabled:opacity-30"
                        >
                          <Icon name="arrow-up" size={15} />
                        </button>
                        <button
                          aria-label="Move down"
                          disabled={i === rows.length - 1 || reorder.isPending}
                          onClick={() => reorder.mutate({ a: s, b: rows[i + 1] })}
                          className="grid h-6 w-7 place-items-center rounded text-muted hover:bg-surface-2 disabled:opacity-30"
                        >
                          <Icon name="arrow-down" size={15} />
                        </button>
                      </div>

                      <div className="min-w-0 flex-1">
                        <div className="flex items-center gap-2">
                          <p className="truncate font-medium">{s.title}</p>
                          {s.show_in_onboarding && (
                            <Icon name="badge" size={15} className="shrink-0 text-brand" />
                          )}
                        </div>
                        <div className="mt-1">
                          <VisibilityBadge roles={s.allowed_roles} />
                        </div>
                      </div>

                      <Link
                        to={`/admin/sections/${s.id}/edit`}
                        aria-label={`Edit ${s.title}`}
                        className="grid h-10 w-10 place-items-center rounded-xl text-muted hover:bg-surface-2"
                      >
                        <Icon name="edit" size={18} />
                      </Link>
                      <button
                        aria-label={`Delete ${s.title}`}
                        onClick={() => {
                          if (window.confirm(`Delete "${s.title}"? This cannot be undone.`)) {
                            remove.mutate(s)
                          }
                        }}
                        className="grid h-10 w-10 place-items-center rounded-xl text-danger hover:bg-danger-soft/50"
                      >
                        <Icon name="trash" size={18} />
                      </button>
                    </li>
                  ))}
                </ul>
              </section>
            )
          })}
        </div>
      )}
    </div>
  )
}
