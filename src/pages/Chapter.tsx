import { useEffect } from 'react'
import { Link, useParams, useLocation } from 'react-router-dom'
import { useAccess } from '@/lib/access'
import { useChapter, useNavigation } from '@/lib/queries'
import { driveEmbedUrl } from '@/lib/video'
import { Markdown } from '@/components/Markdown'
import { Icon } from '@/components/Icon'
import { ReadingProgress } from '@/components/ReadingProgress'
import { LoadingState, ErrorState, EmptyState } from '@/components/States'

function readTime(text: string): number {
  const words = text.trim() ? text.trim().split(/\s+/).length : 0
  return Math.max(1, Math.round(words / 200))
}

export function Chapter() {
  const { slug } = useParams<{ slug: string }>()
  const location = useLocation()
  const { isAdmin } = useAccess()
  const { data, isLoading, error } = useChapter(slug)
  const { data: chapters = [] } = useNavigation()

  // Jump to a section anchor (from the sidebar, search, or a deep link), or to
  // the top when opening a chapter fresh.
  useEffect(() => {
    if (!data) return
    const id = location.hash.replace('#', '')
    if (id) {
      const el = document.getElementById(id)
      if (el) requestAnimationFrame(() => el.scrollIntoView({ behavior: 'smooth', block: 'start' }))
    } else {
      window.scrollTo({ top: 0 })
    }
  }, [data, location.hash, location.key])

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
  const totalRead = readTime(sections.map((s) => s.body).join(' '))

  // Previous / next chapter, to turn the page.
  const order = chapters.findIndex((c) => c.slug === chapter.slug)
  const prevChapter = order > 0 ? chapters[order - 1] : null
  const nextChapter = order >= 0 && order < chapters.length - 1 ? chapters[order + 1] : null

  return (
    <>
      <ReadingProgress />
      <article className="book-page">
        <header>
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
          {sections.length > 0 && (
            <p className="mt-3 text-sm text-muted">
              {sections.length} {sections.length === 1 ? 'section' : 'sections'} · {totalRead} min read
            </p>
          )}
        </header>

        {sections.length === 0 ? (
          <div className="mt-8">
            <EmptyState icon="book" title="Nothing here yet">
              This chapter doesn’t have any sections you can see right now.
            </EmptyState>
          </div>
        ) : (
          sections.map((s, i) => {
            const embed = driveEmbedUrl(s.video_url)
            return (
              <section key={s.id} id={`s-${s.slug}`} className="scroll-mt-24">
                <hr className={`border-border ${i === 0 ? 'my-7' : 'my-10'}`} />
                <div className="flex items-start justify-between gap-3">
                  <h2 className="font-serif text-2xl font-bold leading-tight tracking-tight sm:text-3xl">
                    {s.title}
                  </h2>
                  {isAdmin && (
                    <Link
                      to={`/admin/sections/${s.id}/edit`}
                      className="btn-secondary shrink-0 !min-h-[34px] !px-2.5 text-xs"
                      aria-label={`Edit ${s.title}`}
                    >
                      <Icon name="edit" size={14} />
                      Edit
                    </Link>
                  )}
                </div>

                {embed ? (
                  <div className="my-5 overflow-hidden rounded-2xl border border-border bg-black">
                    <div className="aspect-video">
                      <iframe
                        src={embed}
                        title={`${s.title} — video`}
                        allow="autoplay; encrypted-media"
                        allowFullScreen
                        className="h-full w-full"
                      />
                    </div>
                  </div>
                ) : s.video_url ? (
                  <a
                    href={s.video_url}
                    target="_blank"
                    rel="noopener noreferrer"
                    className="my-5 flex items-center gap-3 rounded-xl border border-border bg-surface-2 px-4 py-3 transition-colors hover:bg-border"
                  >
                    <Icon name="video" className="text-brand" />
                    <span className="flex-1 font-medium">Watch the video</span>
                    <Icon name="external" size={18} className="text-muted" />
                  </a>
                ) : null}

                {s.body.trim() ? (
                  <Markdown>{s.body}</Markdown>
                ) : (
                  <p className="text-muted">This section doesn’t have written content yet.</p>
                )}
              </section>
            )
          })
        )}

        {(prevChapter || nextChapter) && (
          <nav className="mt-12 grid gap-3 border-t border-border pt-6 sm:grid-cols-2">
            {prevChapter ? (
              <Link
                to={`/chapter/${prevChapter.slug}`}
                className="flex items-center gap-3 rounded-xl border border-border bg-surface-2/60 p-3.5 transition-colors hover:border-brand/40 hover:bg-surface-2"
              >
                <Icon name="arrow-left" size={18} className="shrink-0 text-muted" />
                <span className="min-w-0">
                  <span className="block text-xs uppercase tracking-wide text-muted">Previous chapter</span>
                  <span className="block truncate font-medium">{prevChapter.title}</span>
                </span>
              </Link>
            ) : (
              <span />
            )}
            {nextChapter && (
              <Link
                to={`/chapter/${nextChapter.slug}`}
                className="flex items-center gap-3 rounded-xl border border-border bg-surface-2/60 p-3.5 text-right transition-colors hover:border-brand/40 hover:bg-surface-2 sm:justify-end"
              >
                <span className="min-w-0">
                  <span className="block text-xs uppercase tracking-wide text-muted">Next chapter</span>
                  <span className="block truncate font-medium">{nextChapter.title}</span>
                </span>
                <Icon name="chevron-right" size={18} className="shrink-0 text-muted" />
              </Link>
            )}
          </nav>
        )}
      </article>
    </>
  )
}
