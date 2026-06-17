import { useMemo } from 'react'
import { Link, useParams } from 'react-router-dom'
import { useAccess } from '@/lib/access'
import { useSection, useNavigation } from '@/lib/queries'
import { driveEmbedUrl } from '@/lib/video'
import { formatDate } from '@/lib/format'
import { Markdown } from '@/components/Markdown'
import { Icon } from '@/components/Icon'
import { VisibilityBadge } from '@/components/Visibility'
import { ReadingProgress } from '@/components/ReadingProgress'
import { LoadingState, ErrorState, EmptyState } from '@/components/States'

function readTime(body: string): number {
  const words = body.trim() ? body.trim().split(/\s+/).length : 0
  return Math.max(1, Math.round(words / 200))
}

export function Section() {
  const { slug } = useParams<{ slug: string }>()
  const { isAdmin } = useAccess()
  const { data: section, isLoading, error } = useSection(slug)
  const { data: chapters = [] } = useNavigation()

  // Flatten the nav into a linear reading order for prev/next (turn the page).
  const { prev, next } = useMemo(() => {
    const flat = chapters.flatMap((c) => c.sections.map((s) => ({ slug: s.slug, title: s.title })))
    const i = flat.findIndex((s) => s.slug === slug)
    return {
      prev: i > 0 ? flat[i - 1] : null,
      next: i >= 0 && i < flat.length - 1 ? flat[i + 1] : null,
    }
  }, [chapters, slug])

  if (isLoading) return <LoadingState />
  if (error) return <ErrorState error={error} />
  if (!section) {
    return (
      <EmptyState icon="lock" title="Section not available">
        This section doesn’t exist, or your role doesn’t have access to it.
      </EmptyState>
    )
  }

  const embed = driveEmbedUrl(section.video_url)

  return (
    <>
      <ReadingProgress />
      <article className="book-page">
        <div className="mb-3 flex items-center justify-between gap-3">
          {section.chapters ? (
            <Link to={`/chapter/${section.chapters.slug}`} className="eyebrow hover:underline">
              {section.chapters.title}
            </Link>
          ) : (
            <span className="eyebrow">Handbook</span>
          )}
          {isAdmin && (
            <Link
              to={`/admin/sections/${section.id}/edit`}
              className="btn-secondary shrink-0 !min-h-[36px] !px-3 text-xs"
            >
              <Icon name="edit" size={15} />
              Edit
            </Link>
          )}
        </div>

        <h1 className="font-serif text-3xl font-bold leading-tight tracking-tight sm:text-[2.6rem]">
          {section.title}
        </h1>

        <div className="mt-3.5 flex flex-wrap items-center gap-x-3 gap-y-1.5 text-sm text-muted">
          <span className="inline-flex items-center gap-1.5">
            <Icon name="book" size={15} />
            {readTime(section.body)} min read
          </span>
          <span aria-hidden="true">·</span>
          <span>Updated {formatDate(section.updated_at)}</span>
          {isAdmin && <VisibilityBadge roles={section.allowed_roles} />}
        </div>

        <hr className="my-7 border-border" />

        {embed ? (
          <div className="mb-6 overflow-hidden rounded-2xl border border-border bg-black">
            <div className="aspect-video">
              <iframe
                src={embed}
                title={`${section.title} — video`}
                allow="autoplay; encrypted-media"
                allowFullScreen
                className="h-full w-full"
              />
            </div>
          </div>
        ) : section.video_url ? (
          <a
            href={section.video_url}
            target="_blank"
            rel="noopener noreferrer"
            className="mb-6 flex items-center gap-3 rounded-xl border border-border bg-surface-2 px-4 py-3 transition-colors hover:bg-border"
          >
            <Icon name="video" className="text-brand" />
            <span className="flex-1 font-medium">Watch the video</span>
            <Icon name="external" size={18} className="text-muted" />
          </a>
        ) : null}

        {section.body.trim() ? (
          <Markdown>{section.body}</Markdown>
        ) : (
          <p className="text-muted">This section doesn’t have written content yet.</p>
        )}

        {(prev || next) && (
          <nav className="mt-12 grid gap-3 border-t border-border pt-6 sm:grid-cols-2">
            {prev ? (
              <Link
                to={`/section/${prev.slug}`}
                className="group flex items-center gap-3 rounded-xl border border-border bg-surface-2/60 p-3.5 transition-colors hover:border-brand/40 hover:bg-surface-2"
              >
                <Icon name="arrow-left" size={18} className="shrink-0 text-muted" />
                <span className="min-w-0">
                  <span className="block text-xs uppercase tracking-wide text-muted">Previous</span>
                  <span className="block truncate font-medium">{prev.title}</span>
                </span>
              </Link>
            ) : (
              <span />
            )}
            {next && (
              <Link
                to={`/section/${next.slug}`}
                className="group flex items-center gap-3 rounded-xl border border-border bg-surface-2/60 p-3.5 text-right transition-colors hover:border-brand/40 hover:bg-surface-2 sm:justify-end"
              >
                <span className="min-w-0">
                  <span className="block text-xs uppercase tracking-wide text-muted">Next</span>
                  <span className="block truncate font-medium">{next.title}</span>
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
