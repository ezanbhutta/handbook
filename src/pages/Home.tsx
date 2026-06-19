import type { CSSProperties } from 'react'
import { Link } from 'react-router-dom'
import { useAccess } from '@/lib/access'
import { useNavigation, useOnboarding } from '@/lib/queries'
import { roleLabel } from '@/lib/roles'
import { chapterAccent, chapterNumber } from '@/lib/accent'
import { Wordmark } from '@/components/Wordmark'
import { PulseMotif } from '@/components/PulseMotif'
import { SearchBar } from '@/components/SearchBar'
import { Icon } from '@/components/Icon'
import { LoadingState, EmptyState } from '@/components/States'

export function Home() {
  const { role } = useAccess()
  const { data: chapters = [], isLoading } = useNavigation()
  const { data: onboarding = [] } = useOnboarding()

  return (
    <div className="book-page overflow-hidden">
      {/* Cover / title page — a quiet, full-bleed spread */}
      <header className="cover-aurora relative -mx-6 -mt-12 mb-12 overflow-hidden rounded-t-2xl px-6 pb-14 pt-16 text-center sm:-mx-14 sm:-mt-16 sm:px-14 sm:pb-16 sm:pt-20 lg:-mx-20 lg:-mt-20 lg:px-20">
        <Wordmark width={236} className="mx-auto drop-shadow-[0_8px_22px_rgba(114,41,255,0.16)]" />
        <p className="eyebrow mt-8">Design &amp; Branding Agency · Multan</p>
        <h1 className="mt-4 font-serif text-4xl font-medium leading-[1.05] tracking-tight sm:text-[3.4rem]">
          The Company Handbook
        </h1>
        <p className="mx-auto mt-5 max-w-md font-serif text-lg italic leading-relaxed text-muted">
          Everything you need to know, in one place.
        </p>
        <div className="mt-8 flex items-center justify-center gap-3 text-brand">
          <span className="h-px w-10 bg-border" />
          <PulseMotif height={16} animate />
          <span className="h-px w-10 bg-border" />
        </div>
        <p className="mt-7 text-sm text-muted">Abdul Haseeb · CEO &amp; Founder</p>
        {role && <span className="chip mt-5 inline-flex">{roleLabel(role)} edition</span>}
      </header>

      {/* Search */}
      <div>
        <SearchBar size="lg" placeholder="Search the handbook…" />
      </div>

      {/* Table of contents */}
      <section className="mt-12">
        <div className="mb-1 flex items-baseline justify-between">
          <h2 className="eyebrow">Contents</h2>
          {chapters.length > 0 && (
            <span className="text-xs tabular-nums text-muted">{chapters.length} chapters</span>
          )}
        </div>

        {isLoading ? (
          <LoadingState />
        ) : chapters.length === 0 ? (
          <EmptyState icon="book" title="The book is empty">
            Chapters appear here once content you can see has been published.
          </EmptyState>
        ) : (
          <ol className="divide-y divide-border/70">
            {chapters.map((c, i) => {
              const accent = chapterAccent(i)
              return (
                <li
                  key={c.id}
                  className="animate-rise"
                  style={{ animationDelay: `${Math.min(i * 40, 320)}ms` }}
                >
                  <Link
                    to={`/chapter/${c.slug}`}
                    className="group flex items-baseline gap-5 py-5 sm:gap-7"
                    style={{ '--accent': accent } as CSSProperties}
                  >
                    <span className="w-7 shrink-0 font-serif text-base tabular-nums text-muted transition-colors group-hover:text-[var(--accent)]">
                      {chapterNumber(i)}
                    </span>
                    <span className="min-w-0 flex-1">
                      <span className="font-serif text-xl font-medium leading-snug transition-colors group-hover:text-[var(--accent)]">
                        {c.title}
                      </span>
                      {c.description && (
                        <span className="mt-1 block text-sm leading-relaxed text-muted">{c.description}</span>
                      )}
                    </span>
                    <span className="hidden shrink-0 self-center text-xs tabular-nums text-muted sm:block">
                      {c.sections.length}
                    </span>
                    <Icon
                      name="chevron-right"
                      size={16}
                      className="shrink-0 self-center text-muted/50 transition-transform duration-200 group-hover:translate-x-0.5 group-hover:text-muted"
                    />
                  </Link>
                </li>
              )
            })}
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
                  <Icon name="chevron-right" size={14} className="shrink-0 text-muted/60" />
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
