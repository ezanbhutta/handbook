import { useEffect } from 'react'
import { Link, useParams, useLocation } from 'react-router-dom'
import { useAccess } from '@/lib/access'
import { useChapter, useNavigation } from '@/lib/queries'
import { driveEmbedUrl } from '@/lib/video'
import { chapterAccent, chapterNumber } from '@/lib/accent'
import { setActiveSection } from '@/lib/scrollspy'
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

  // Scroll spy: as the reader scrolls, mark the section under the top of the
  // viewport active, so the sidebar highlight follows along. rAF-throttled, and
  // it only publishes when the active section actually changes.
  useEffect(() => {
    if (!data) return
    let raf = 0
    const compute = () => {
      raf = 0
      const secs = Array.from(document.querySelectorAll<HTMLElement>('section[id^="s-"]'))
      if (!secs.length) return
      let currentId = secs[0].id
      for (const s of secs) {
        if (s.getBoundingClientRect().top - 120 <= 0) currentId = s.id
        else break
      }
      setActiveSection(currentId.slice(2))
    }
    const onScroll = () => {
      if (!raf) raf = requestAnimationFrame(compute)
    }
    compute()
    window.addEventListener('scroll', onScroll, { passive: true })
    window.addEventListener('resize', onScroll, { passive: true })
    return () => {
      window.removeEventListener('scroll', onScroll)
      window.removeEventListener('resize', onScroll)
      if (raf) cancelAnimationFrame(raf)
      setActiveSection('')
    }
  }, [data, slug])

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
  const accent = chapterAccent(order >= 0 ? order : 0)
  const label = order >= 0 ? chapterNumber(order) : null
  const prevChapter = order > 0 ? chapters[order - 1] : null
  const nextChapter = order >= 0 && order < chapters.length - 1 ? chapters[order + 1] : null

  return (
    <>
      <ReadingProgress />
      <article className="book-page">
        <Link to="/" className="eyebrow inline-flex items-center gap-1.5 hover:underline">
          <Icon name="arrow-left" size={14} />
          Handbook
        </Link>
        <header className="mt-5">
          <span
            className="mb-6 block h-1 w-12 rounded-full"
            style={{ background: accent }}
            aria-hidden="true"
          />
          <p className="eyebrow">{label ? `Chapter ${label}` : 'Chapter'}</p>
          <h1 className="mt-3 font-serif text-[2.5rem] font-medium leading-[1.06] tracking-tight sm:text-[3.25rem]">
            {chapter.title}
          </h1>
          {chapter.description && (
            <p className="mt-4 max-w-2xl font-serif text-xl italic leading-relaxed text-muted">
              {chapter.description}
            </p>
          )}
          {sections.length > 0 && (
            <p className="mt-6 flex items-center gap-3 text-sm text-muted">
              <span>
                {sections.length} {sections.length === 1 ? 'section' : 'sections'}
              </span>
              <span className="h-1 w-1 rounded-full bg-muted/40" />
              <span>{totalRead} min read</span>
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
                <hr className={`border-border/70 ${i === 0 ? 'mt-12' : 'mt-16'}`} />
                <div className="mb-6 mt-9 flex items-start justify-between gap-3">
                  <div className="flex items-baseline gap-3.5">
                    <span
                      className="shrink-0 font-serif text-base tabular-nums"
                      style={{ color: accent }}
                    >
                      {String(i + 1).padStart(2, '0')}
                    </span>
                    <h2 className="font-serif text-2xl font-medium leading-tight tracking-tight sm:text-[1.9rem]">
                      {s.title}
                    </h2>
                  </div>
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
                  <Markdown lead={i === 0}>{s.body}</Markdown>
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
