import { Link } from 'react-router-dom'
import { useAccess } from '@/lib/access'
import { useNavigation, useOnboarding } from '@/lib/queries'
import { roleLabel } from '@/lib/roles'
import { chapterAccent, chapterNumber } from '@/lib/accent'
import { Wordmark } from '@/components/Wordmark'
import { PulseMotif } from '@/components/PulseMotif'
import { SearchBar } from '@/components/SearchBar'
import { Icon, chapterIcon } from '@/components/Icon'
import { LoadingState, EmptyState } from '@/components/States'

export function Home() {
  const { role } = useAccess()
  const { data: chapters = [], isLoading } = useNavigation()
  const { data: onboarding = [] } = useOnboarding()

  return (
    <div className="book-page overflow-hidden">
      {/* Cover / title page — a full-bleed branded spread */}
      <header className="cover-aurora relative -mx-6 -mt-10 mb-9 overflow-hidden rounded-t-2xl px-6 pb-10 pt-12 text-center sm:-mx-12 sm:-mt-14 sm:px-12 sm:pb-12 sm:pt-16 lg:-mx-16 lg:px-16">
        <Wordmark width={250} className="mx-auto drop-shadow-[0_10px_28px_rgba(114,41,255,0.28)]" />
        <p className="eyebrow mt-7">Design &amp; Branding Agency · Multan</p>
        <h1 className="mt-3 font-serif text-4xl font-bold leading-[1.04] tracking-tight sm:text-[3.4rem]">
          The Company Handbook
        </h1>
        <p className="mx-auto mt-4 max-w-md font-serif text-lg italic leading-relaxed text-muted">
          Everything you need to know, in one place.
        </p>
        <div className="mt-6 flex items-center justify-center gap-3 text-brand">
          <span className="h-px w-8 bg-brand/30" />
          <PulseMotif height={16} />
          <span className="h-px w-8 bg-brand/30" />
        </div>
        <p className="mt-6 text-sm font-medium text-muted">Abdul Haseeb · CEO &amp; Founder</p>
        {role && <span className="chip-brand mt-4 inline-flex">{roleLabel(role)} edition</span>}
      </header>

      {/* Search */}
      <div>
        <SearchBar size="lg" placeholder="Search the handbook…" />
      </div>

      {/* Table of contents */}
      <section className="mt-9">
        <div className="mb-3 flex items-center gap-2.5">
          <h2 className="eyebrow">Contents</h2>
          <span className="h-px flex-1 bg-border" />
          {chapters.length > 0 && (
            <span className="text-xs font-medium tabular-nums text-muted">{chapters.length} chapters</span>
          )}
        </div>

        {isLoading ? (
          <LoadingState />
        ) : chapters.length === 0 ? (
          <EmptyState icon="book" title="The book is empty">
            Chapters appear here once content you can see has been published.
          </EmptyState>
        ) : (
          <ol className="grid gap-2.5">
            {chapters.map((c, i) => {
              const accent = chapterAccent(i)
              return (
                <li key={c.id} className="animate-rise" style={{ animationDelay: `${Math.min(i * 45, 360)}ms` }}>
                  <Link
                    to={`/chapter/${c.slug}`}
                    className="group relative flex items-center gap-4 overflow-hidden rounded-2xl border border-border bg-surface p-3.5 pl-5 transition duration-200 hover:-translate-y-0.5 hover:border-transparent hover:shadow-brand"
                  >
                    <span
                      className="absolute inset-y-0 left-0 w-1.5"
                      style={{ background: accent }}
                      aria-hidden="true"
                    />
                    <span
                      className="w-8 shrink-0 text-center font-serif text-2xl font-bold tabular-nums"
                      style={{ color: accent }}
                    >
                      {chapterNumber(i)}
                    </span>
                    <span
                      className="grid h-12 w-12 shrink-0 place-items-center rounded-xl text-white shadow-soft transition-transform duration-200 group-hover:scale-105"
                      style={{ background: accent }}
                    >
                      <Icon name={chapterIcon(c.icon)} size={22} />
                    </span>
                    <span className="min-w-0 flex-1">
                      <span className="block font-serif text-lg font-semibold leading-snug">{c.title}</span>
                      {c.description && (
                        <span className="mt-0.5 block truncate text-sm text-muted">{c.description}</span>
                      )}
                    </span>
                    <span className="hidden shrink-0 text-xs font-medium tabular-nums text-muted sm:block">
                      {c.sections.length} {c.sections.length === 1 ? 'part' : 'parts'}
                    </span>
                    <Icon
                      name="chevron-right"
                      size={18}
                      className="shrink-0 text-muted transition-transform duration-200 group-hover:translate-x-0.5"
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
