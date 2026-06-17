import { useState } from 'react'
import { Link, NavLink, useLocation } from 'react-router-dom'
import { useNavigation } from '@/lib/queries'
import { Icon, chapterIcon } from './Icon'
import { Spinner } from './States'

// The permission-filtered chapter/section navigation. Chapters with no readable
// section never come back from get_navigation(), so they simply don't render.
export function NavTree({ onNavigate }: { onNavigate?: () => void }) {
  const { data: chapters = [], isLoading } = useNavigation()
  const location = useLocation()

  const linkBase =
    'flex items-center gap-3 rounded-xl px-3 min-h-[44px] text-sm transition-colors'
  const topLink = ({ isActive }: { isActive: boolean }) =>
    `${linkBase} font-medium ${
      isActive ? 'bg-brand-soft text-brand' : 'text-fg hover:bg-surface-2'
    }`

  return (
    <nav className="flex flex-col gap-1" aria-label="Handbook navigation">
      <NavLink to="/" end className={topLink} onClick={onNavigate}>
        <Icon name="home" size={20} />
        Home
      </NavLink>
      <NavLink to="/whats-new" className={topLink} onClick={onNavigate}>
        <Icon name="sparkles" size={20} />
        What’s New
      </NavLink>

      <div className="my-2 px-3 text-[11px] font-semibold uppercase tracking-wide text-muted">
        Chapters
      </div>

      {isLoading ? (
        <div className="flex items-center gap-2 px-3 py-2 text-sm text-muted">
          <Spinner /> Loading…
        </div>
      ) : chapters.length === 0 ? (
        <p className="px-3 py-2 text-sm text-muted">No chapters yet.</p>
      ) : (
        chapters.map((chapter) => {
          const active = location.pathname === `/chapter/${chapter.slug}`
          return (
            <ChapterItem
              key={chapter.id}
              slug={chapter.slug}
              title={chapter.title}
              icon={chapter.icon ?? null}
              sections={chapter.sections}
              defaultOpen={
                active ||
                chapter.sections.some((s) => location.pathname === `/section/${s.slug}`)
              }
              onNavigate={onNavigate}
            />
          )
        })
      )}
    </nav>
  )
}

function ChapterItem({
  slug,
  title,
  icon,
  sections,
  defaultOpen,
  onNavigate,
}: {
  slug: string
  title: string
  icon: string | null
  sections: { id: string; title: string; slug: string }[]
  defaultOpen: boolean
  onNavigate?: () => void
}) {
  const [open, setOpen] = useState(defaultOpen)
  const location = useLocation()
  return (
    <div>
      <div className="flex items-center">
        <NavLink
          to={`/chapter/${slug}`}
          onClick={onNavigate}
          className={({ isActive }) =>
            `flex flex-1 items-center gap-3 rounded-xl px-3 min-h-[44px] text-sm font-medium transition-colors ${
              isActive ? 'bg-brand-soft text-brand' : 'text-fg hover:bg-surface-2'
            }`
          }
        >
          <Icon name={chapterIcon(icon)} size={20} className="text-muted" />
          <span className="truncate">{title}</span>
        </NavLink>
        {sections.length > 0 && (
          <button
            type="button"
            aria-label={open ? `Collapse ${title}` : `Expand ${title}`}
            aria-expanded={open}
            onClick={() => setOpen((v) => !v)}
            className="grid h-11 w-11 shrink-0 place-items-center rounded-xl text-muted hover:bg-surface-2"
          >
            <Icon name="chevron-down" size={16} className={open ? '' : '-rotate-90'} />
          </button>
        )}
      </div>
      {open && sections.length > 0 && (
        <ul className="ml-5 mt-0.5 border-l border-border pl-2">
          {sections.map((s) => {
            const current =
              location.pathname === `/chapter/${slug}` && location.hash === `#s-${s.slug}`
            return (
              <li key={s.id}>
                <Link
                  to={`/chapter/${slug}#s-${s.slug}`}
                  onClick={onNavigate}
                  className={`block rounded-lg px-3 py-2 text-sm transition-colors ${
                    current
                      ? 'font-medium text-brand'
                      : 'text-muted hover:bg-surface-2 hover:text-fg'
                  }`}
                >
                  {s.title}
                </Link>
              </li>
            )
          })}
        </ul>
      )}
    </div>
  )
}
