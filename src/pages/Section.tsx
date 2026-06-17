import { Navigate, useParams } from 'react-router-dom'
import { useSection } from '@/lib/queries'
import { LoadingState, ErrorState, EmptyState } from '@/components/States'

// Sections are now read inside their chapter's continuous page. Any link to a
// single section (search, cross-links, deep links) lands in that chapter and
// scrolls to the section.
export function Section() {
  const { slug } = useParams<{ slug: string }>()
  const { data: section, isLoading, error } = useSection(slug)

  if (isLoading) return <LoadingState />
  if (error) return <ErrorState error={error} />
  if (!section || !section.chapters) {
    return (
      <EmptyState icon="lock" title="Section not available">
        This section doesn’t exist, or your role doesn’t have access to it.
      </EmptyState>
    )
  }

  return <Navigate to={`/chapter/${section.chapters.slug}#s-${section.slug}`} replace />
}
