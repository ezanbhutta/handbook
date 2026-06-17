import { Link } from 'react-router-dom'
import { useAccess } from '@/lib/access'
import { useNavigation, useOnboarding, useLatestChange } from '@/lib/queries'
import { roleLabel } from '@/lib/roles'
import { Logo } from '@/components/Logo'
import { SearchBar } from '@/components/SearchBar'
import { Icon } from '@/components/Icon'
import { LoadingState, EmptyState } from '@/components/States'

export function Home() {
  const { role } = useAccess()
  const { data: chapters = [], isLoading } = useNavigation()
  const { data: onboarding = [] } = useOnboarding()
  const { data: latest } = useLatestChange()

  return (
    <div className="book-page">
      {/* Title page */}
      <header className="text-center">
        <Logo size={56} className="mx-auto drop-shadow-[0_10px_30px_rgba(114,41,255,0.35)]" />
        <p className="eyebrow mt-5">HaseebMadeit · Design &amp; Branding Agency</p>
        <h1 className="mt-2 font-serif text-4xl font-bold leading-tight tracking-tight sm:text-5xl">
          The Company Handbook
        </h1>
        <p className="mx-auto mt-3 max-w-md font-serif text-lg leading-relaxed text-muted">
          Everything you need to know, in one place.
        </p>
        {role && (
          <span className="chip-brand mt-4 inline-flex">{roleLabel(role)} edition</span>
        )}
      </header>

      <hr className="my-8 border-border" />

      {/* Search */}
      <SearchBar size="lg" placeholder="Search the handbook…" />

      {/* Compact "what's new" line */}
      {latest && (
        <Link
          to={latest.section?.slug ? `/section/${latest.section.slug}` : '/whats-new'}
          className="mt-3 flex items-center gap-2 text-sm text-muted transition-colors hover:text-fg"
        >
          <Icon name="sparkles" size={15} className="shrink-0 text-brand" />
          <span className="truncate">
            <span className="font-medium text-brand">Latest update</span> ·{' '}
            {latest.section_title ?? latest.summary}
          </span>
        </Link>
      )}

      {/* Start here (front matter) */}
      {onboarding.length > 0 && (
        <section className="mt-8">
          <h2 className="eyebrow mb-2">Start here{role && ` · ${roleLabel(role)}`}</h2>
          <ol className="space-y-1.5">
            {onboarding.map((s, i) => (
              <li key={s.id}>
                <Link
                  to={s.chapters ? `/chapter/${s.chapters.slug}#s-${s.slug}` : `/section/${s.slug}`}
                  className="group flex items-center gap-3 rounded-xl px-2 py-2 transition-colors hover:bg-surface-2"
                >
                  <span className="grid h-7 w-7 shrink-0 place-items-center rounded-full bg-brand-soft text-xs font-bold text-brand">
                    {i + 1}
                  </span>
                  <span className="min-w-0 flex-1 truncate font-serif text-lg">{s.title}</span>
                  <Icon
                    name="chevron-right"
                    size={16}
                    className="shrink-0 text-muted transition-transform group-hover:translate-x-0.5"
                  />
                </Link>
              </li>
            ))}
          </ol>
        </section>
      )}

      {/* Table of contents */}
      <section className="mt-8">
        <h2 className="eyebrow mb-1">Contents</h2>
        {isLoading ? (
          <LoadingState />
        ) : chapters.length === 0 ? (
          <EmptyState icon="book" title="The book is empty">
            Chapters appear here once content you can see has been published.
          </EmptyState>
        ) : (
          <ol className="divide-y divide-border">
            {chapters.map((c, i) => (
              <li key={c.id}>
                <Link
                  to={`/chapter/${c.slug}`}
                  className="group flex items-baseline gap-4 py-4 transition-colors"
                >
                  <span className="w-7 shrink-0 font-serif text-lg tabular-nums text-muted">
                    {i + 1}
                  </span>
                  <span className="min-w-0 flex-1">
                    <span className="font-serif text-xl font-medium group-hover:text-brand">
                      {c.title}
                    </span>
                    {c.description && (
                      <span className="mt-0.5 block truncate text-sm text-muted">
                        {c.description}
                      </span>
                    )}
                  </span>
                  <span className="shrink-0 text-sm tabular-nums text-muted">
                    {c.sections.length}
                  </span>
                  <Icon
                    name="chevron-right"
                    size={18}
                    className="shrink-0 self-center text-muted transition-transform group-hover:translate-x-0.5"
                  />
                </Link>
              </li>
            ))}
          </ol>
        )}
      </section>
    </div>
  )
}
