import { Link, useParams } from 'react-router-dom'
import { useAuth } from '@/lib/auth'
import { useSection } from '@/lib/queries'
import { driveEmbedUrl } from '@/lib/video'
import { formatDate } from '@/lib/format'
import { Markdown } from '@/components/Markdown'
import { Icon } from '@/components/Icon'
import { VisibilityBadge } from '@/components/Visibility'
import { LoadingState, ErrorState, EmptyState } from '@/components/States'

export function Section() {
  const { slug } = useParams<{ slug: string }>()
  const { isAdmin } = useAuth()
  const { data: section, isLoading, error } = useSection(slug)

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
    <article className="mx-auto max-w-3xl">
      <nav className="mb-4 flex items-center gap-1.5 text-sm text-muted">
        <Link to="/" className="hover:text-fg">
          Home
        </Link>
        {section.chapters && (
          <>
            <Icon name="chevron-right" size={14} />
            <Link to={`/chapter/${section.chapters.slug}`} className="truncate hover:text-fg">
              {section.chapters.title}
            </Link>
          </>
        )}
      </nav>

      <header className="mb-5">
        <div className="flex items-start justify-between gap-3">
          <h1 className="text-2xl font-bold tracking-tight sm:text-3xl">{section.title}</h1>
          {isAdmin && (
            <Link
              to={`/admin/sections/${section.id}/edit`}
              className="btn-secondary shrink-0 !min-h-[40px] !px-3 text-xs"
            >
              <Icon name="edit" size={16} />
              Edit
            </Link>
          )}
        </div>
        {isAdmin && (
          <div className="mt-2.5">
            <VisibilityBadge roles={section.allowed_roles} />
          </div>
        )}
      </header>

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
          className="mb-6 flex items-center gap-3 rounded-xl border border-border bg-surface px-4 py-3 transition-colors hover:bg-surface-2"
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

      <footer className="mt-10 border-t border-border pt-4 text-xs text-muted">
        Last updated {formatDate(section.updated_at)}
      </footer>
    </article>
  )
}
