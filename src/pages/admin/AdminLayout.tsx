import { Suspense } from 'react'
import { NavLink, Outlet } from 'react-router-dom'
import { Icon, type IconName } from '@/components/Icon'
import { LoadingState } from '@/components/States'

const TABS: { to: string; label: string; icon: IconName; end?: boolean }[] = [
  { to: '/admin', label: 'Overview', icon: 'home', end: true },
  { to: '/admin/chapters', label: 'Chapters', icon: 'list' },
  { to: '/admin/sections', label: 'Sections', icon: 'book' },
  { to: '/admin/synonyms', label: 'Synonyms', icon: 'search' },
  { to: '/admin/users', label: 'Users', icon: 'users' },
  { to: '/admin/insights', label: 'Insights', icon: 'sparkles' },
]

export function AdminLayout() {
  return (
    <div className="mx-auto max-w-5xl">
      <div className="mb-5 flex items-center gap-2.5">
        <span className="grid h-9 w-9 place-items-center rounded-xl bg-brand text-brand-fg">
          <Icon name="settings" size={20} />
        </span>
        <h1 className="text-xl font-bold tracking-tight">Admin</h1>
      </div>

      <div className="mb-6 -mx-3 overflow-x-auto px-3 sm:mx-0 sm:px-0">
        <nav className="flex min-w-max gap-1 border-b border-border" aria-label="Admin sections">
          {TABS.map((t) => (
            <NavLink
              key={t.to}
              to={t.to}
              end={t.end}
              className={({ isActive }) =>
                `flex items-center gap-2 border-b-2 px-3 py-2.5 text-sm font-medium transition-colors ${
                  isActive
                    ? 'border-brand text-brand'
                    : 'border-transparent text-muted hover:text-fg'
                }`
              }
            >
              <Icon name={t.icon} size={17} />
              {t.label}
            </NavLink>
          ))}
        </nav>
      </div>

      <Suspense fallback={<LoadingState />}>
        <Outlet />
      </Suspense>
    </div>
  )
}
