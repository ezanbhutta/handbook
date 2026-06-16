import { Link } from 'react-router-dom'
import { useAuth } from '@/lib/auth'
import { useNavigation, useOnboarding } from '@/lib/queries'
import { roleLabel } from '@/lib/roles'
import { WhatsNewBanner } from '@/components/WhatsNewBanner'
import { SearchBar } from '@/components/SearchBar'
import { Icon, chapterIcon } from '@/components/Icon'
import { LoadingState, EmptyState } from '@/components/States'

function greeting(): string {
  const h = new Date().getHours()
  if (h < 12) return 'Good morning'
  if (h < 18) return 'Good afternoon'
  return 'Good evening'
}

export function Home() {
  const { profile } = useAuth()
  const { data: chapters = [], isLoading } = useNavigation()
  const { data: onboarding = [] } = useOnboarding(Boolean(profile))

  const firstName = profile?.full_name.split(' ')[0] ?? 'there'

  return (
    <div className="mx-auto max-w-4xl space-y-7">
      <div>
        <h1 className="text-2xl font-bold tracking-tight sm:text-3xl">
          {greeting()}, {firstName}.
        </h1>
        <p className="mt-1 text-muted">
          Everything you need to know, in one place. Signed in as{' '}
          <span className="font-medium text-fg">{profile && roleLabel(profile.role)}</span>.
        </p>
      </div>

      <WhatsNewBanner />

      {/* Prominent search — the primary way in. */}
      <div className="rounded-2xl border border-border bg-surface p-5 shadow-sm sm:p-6">
        <label className="mb-2 block text-sm font-semibold text-fg">
          Looking for something?
        </label>
        <SearchBar size="lg" placeholder="Search dress code, leave, refunds, ClickUp…" />
        <p className="mt-2 hint">Tip: search works with typos and everyday words.</p>
      </div>

      {/* Start Here — role-based onboarding list. */}
      {onboarding.length > 0 && (
        <section aria-labelledby="start-here">
          <div className="mb-3 flex items-center gap-2">
            <Icon name="badge" size={20} className="text-brand" />
            <h2 id="start-here" className="text-lg font-bold">
              Start here for {profile && roleLabel(profile.role)}
            </h2>
          </div>
          <ol className="space-y-2">
            {onboarding.map((s, i) => (
              <li key={s.id}>
                <Link
                  to={`/section/${s.slug}`}
                  className="group flex items-center gap-3 rounded-xl border border-border bg-surface px-4 py-3 transition-colors hover:border-brand/40 hover:bg-surface-2"
                >
                  <span className="grid h-8 w-8 shrink-0 place-items-center rounded-full bg-brand-soft text-sm font-bold text-brand">
                    {i + 1}
                  </span>
                  <div className="min-w-0 flex-1">
                    <p className="truncate font-medium text-fg">{s.title}</p>
                    {s.chapters && (
                      <p className="truncate text-xs text-muted">{s.chapters.title}</p>
                    )}
                  </div>
                  <Icon
                    name="chevron-right"
                    size={18}
                    className="text-muted transition-transform group-hover:translate-x-0.5"
                  />
                </Link>
              </li>
            ))}
          </ol>
        </section>
      )}

      {/* Chapter grid. */}
      <section aria-labelledby="chapters">
        <h2 id="chapters" className="mb-3 text-lg font-bold">
          Browse the handbook
        </h2>
        {isLoading ? (
          <LoadingState />
        ) : chapters.length === 0 ? (
          <EmptyState icon="book" title="No content yet">
            Chapters appear here once your admin publishes sections you can see.
          </EmptyState>
        ) : (
          <div className="grid gap-3 sm:grid-cols-2">
            {chapters.map((c) => (
              <Link
                key={c.id}
                to={`/chapter/${c.slug}`}
                className="group flex gap-3.5 rounded-2xl border border-border bg-surface p-4 transition-all hover:-translate-y-0.5 hover:border-brand/40 hover:shadow-sm"
              >
                <span className="grid h-11 w-11 shrink-0 place-items-center rounded-xl bg-surface-2 text-brand transition-colors group-hover:bg-brand-soft">
                  <Icon name={chapterIcon(c.icon)} size={22} />
                </span>
                <div className="min-w-0">
                  <h3 className="font-semibold text-fg">{c.title}</h3>
                  {c.description && (
                    <p className="mt-0.5 line-clamp-2 text-sm text-muted">{c.description}</p>
                  )}
                  <p className="mt-1.5 text-xs font-medium text-muted">
                    {c.sections.length} {c.sections.length === 1 ? 'section' : 'sections'}
                  </p>
                </div>
              </Link>
            ))}
          </div>
        )}
      </section>
    </div>
  )
}
