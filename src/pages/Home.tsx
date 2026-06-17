import { Link } from 'react-router-dom'
import { useAccess } from '@/lib/access'
import { useNavigation, useOnboarding } from '@/lib/queries'
import { roleLabel } from '@/lib/roles'
import { Logo } from '@/components/Logo'
import { SearchBar } from '@/components/SearchBar'
import { Icon, chapterIcon } from '@/components/Icon'
import { LoadingState, EmptyState } from '@/components/States'

export function Home() {
  const { role } = useAccess()
  const { data: chapters = [], isLoading } = useNavigation()
  const { data: onboarding = [] } = useOnboarding()

  return (
    <div className="book-page">
      {/* Cover / title page */}
      <header className="py-8 text-center sm:py-12">
        <Logo size={60} className="mx-auto drop-shadow-[0_12px_34px_rgba(114,41,255,0.35)]" />
        <p className="eyebrow mt-7">HaseebMadeit · Design &amp; Branding Agency</p>
        <h1 className="mt-3 font-serif text-4xl font-bold leading-[1.05] tracking-tight sm:text-[3.25rem]">
          The Company Handbook
        </h1>
        <p className="mx-auto mt-4 max-w-md font-serif text-lg italic leading-relaxed text-muted">
          Everything you need to know, in one place.
        </p>
        <p className="mt-7 text-sm text-muted">Abdul Haseeb · CEO &amp; Founder</p>
        {role && <span className="chip-brand mt-5 inline-flex">{roleLabel(role)} edition</span>}
      </header>

      <hr className="border-border" />

      {/* Search */}
      <div className="mt-8">
        <SearchBar size="lg" placeholder="Search the handbook…" />
      </div>

      {/* Table of contents */}
      <section className="mt-9">
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
                  className="group flex items-center gap-4 py-3.5 transition-colors"
                >
                  <span className="grid h-11 w-11 shrink-0 place-items-center rounded-xl bg-surface-2 text-brand transition-colors group-hover:bg-brand-soft">
                    <Icon name={chapterIcon(c.icon)} size={21} />
                  </span>
                  <span className="min-w-0 flex-1">
                    <span className="flex items-baseline gap-2">
                      <span className="text-xs font-semibold tabular-nums text-muted">{i + 1}</span>
                      <span className="font-serif text-lg font-medium group-hover:text-brand">
                        {c.title}
                      </span>
                    </span>
                    {c.description && (
                      <span className="block truncate text-sm text-muted">{c.description}</span>
                    )}
                  </span>
                  <span className="shrink-0 text-xs tabular-nums text-muted">
                    {c.sections.length}
                  </span>
                  <Icon
                    name="chevron-right"
                    size={18}
                    className="shrink-0 text-muted transition-transform group-hover:translate-x-0.5"
                  />
                </Link>
              </li>
            ))}
          </ol>
        )}
      </section>

      {/* New here? — kept, but quiet and below the contents */}
      {onboarding.length > 0 && (
        <section className="mt-10 rounded-2xl border border-border bg-surface-2/40 p-4 sm:p-5">
          <h2 className="eyebrow mb-2">New here? Start with these</h2>
          <ul className="space-y-0.5">
            {onboarding.slice(0, 5).map((s) => (
              <li key={s.id}>
                <Link
                  to={s.chapters ? `/chapter/${s.chapters.slug}#s-${s.slug}` : `/section/${s.slug}`}
                  className="group flex items-center gap-2.5 rounded-lg px-2 py-1.5 text-sm transition-colors hover:bg-surface"
                >
                  <Icon name="chevron-right" size={14} className="shrink-0 text-brand" />
                  <span className="min-w-0 flex-1 truncate font-medium">{s.title}</span>
                </Link>
              </li>
            ))}
          </ul>
        </section>
      )}
    </div>
  )
}
