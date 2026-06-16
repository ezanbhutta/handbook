import { Link, useParams } from 'react-router-dom'
import { useChapter } from '@/lib/queries'
import { Icon, chapterIcon } from '@/components/Icon'
import { LoadingState, ErrorState, EmptyState } from '@/components/States'

export function Chapter() {
  const { slug } = useParams<{ slug: string }>()
  const { data, isLoading, error } = useChapter(slug)

  if (isLoading) return <LoadingState />
  if (error) return <ErrorState error={error} />
  if (!data) {
    return (
      <EmptyState icon="book" title="Chapter not found">
        It may have been moved, or you may not have access to it.
      </EmptyState>
    )
  }

  const { chapter, sections } = data

  return (
    <div className="mx-auto max-w-3xl">
      <nav className="mb-4">
        <Link to="/" className="inline-flex items-center gap-1.5 text-sm text-muted hover:text-fg">
          <Icon name="arrow-left" size={16} />
          Home
        </Link>
      </nav>

      <header className="mb-6 flex items-start gap-4">
        <span className="grid h-12 w-12 shrink-0 place-items-center rounded-2xl bg-brand-soft text-brand">
          <Icon name={chapterIcon(chapter.icon)} size={26} />
        </span>
        <div>
          <h1 className="text-2xl font-bold tracking-tight sm:text-3xl">{chapter.title}</h1>
          {chapter.description && <p className="mt-1.5 text-muted">{chapter.description}</p>}
        </div>
      </header>

      {sections.length === 0 ? (
        <EmptyState icon="book" title="Nothing here yet">
          This chapter doesn’t have any sections you can see right now.
        </EmptyState>
      ) : (
        <ul className="space-y-2">
          {sections.map((s) => (
            <li key={s.id}>
              <Link
                to={`/section/${s.slug}`}
                className="group flex items-center gap-3 rounded-xl border border-border bg-surface px-4 py-3.5 transition-colors hover:border-brand/40 hover:bg-surface-2"
              >
                <Icon name="book" size={18} className="shrink-0 text-muted" />
                <span className="min-w-0 flex-1 font-medium text-fg">{s.title}</span>
                {s.show_in_onboarding && (
                  <span className="chip-brand hidden sm:inline-flex">Start here</span>
                )}
                <Icon
                  name="chevron-right"
                  size={18}
                  className="shrink-0 text-muted transition-transform group-hover:translate-x-0.5"
                />
              </Link>
            </li>
          ))}
        </ul>
      )}
    </div>
  )
}
