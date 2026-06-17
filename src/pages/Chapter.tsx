import { Link, useParams } from 'react-router-dom'
import { useChapter } from '@/lib/queries'
import { Icon } from '@/components/Icon'
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
    <div className="book-page">
      <Link to="/" className="eyebrow inline-flex items-center gap-1.5 hover:underline">
        <Icon name="arrow-left" size={14} />
        Handbook
      </Link>

      <h1 className="mt-3 font-serif text-3xl font-bold leading-tight tracking-tight sm:text-[2.6rem]">
        {chapter.title}
      </h1>
      {chapter.description && (
        <p className="mt-3 font-serif text-xl leading-relaxed text-muted">{chapter.description}</p>
      )}

      <hr className="my-7 border-border" />

      {sections.length === 0 ? (
        <EmptyState icon="book" title="Nothing here yet">
          This chapter doesn’t have any sections you can see right now.
        </EmptyState>
      ) : (
        <>
          <h2 className="eyebrow mb-1">In this chapter</h2>
          <ol className="divide-y divide-border">
            {sections.map((s, i) => (
              <li key={s.id}>
                <Link
                  to={`/section/${s.slug}`}
                  className="group flex items-center gap-4 py-3.5 transition-colors hover:text-brand"
                >
                  <span className="w-6 shrink-0 font-serif text-lg tabular-nums text-muted">
                    {i + 1}
                  </span>
                  <span className="min-w-0 flex-1 font-serif text-lg font-medium">{s.title}</span>
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
          </ol>
        </>
      )}
    </div>
  )
}
