import { Suspense, useEffect, useState } from 'react'
import { Link, Outlet, useLocation } from 'react-router-dom'
import { useAccess } from '@/lib/access'
import { roleLabel } from '@/lib/roles'
import { Icon } from './Icon'
import { Logo } from './Logo'
import { SearchBar } from './SearchBar'
import { NavTree } from './NavTree'
import { UserMenu } from './UserMenu'
import { ThemeSwitcher } from './ThemeSwitcher'
import { LoadingState } from './States'

function Brand() {
  return (
    <Link to="/" className="flex items-center gap-2.5" aria-label="HaseebMadeIt Handbook — home">
      <Logo size={34} />
      <span className="text-base font-bold tracking-tight">
        Haseeb<span className="text-brand">MadeIt</span>
      </span>
    </Link>
  )
}

function RoleBadge() {
  const { role, label } = useAccess()
  if (!role) return null
  return (
    <span className="chip-brand" title={label ?? undefined}>
      <Icon name="badge" size={14} />
      {roleLabel(role)}
    </span>
  )
}

export function Layout() {
  const [drawerOpen, setDrawerOpen] = useState(false)
  const location = useLocation()
  const { mode } = useAccess()

  useEffect(() => setDrawerOpen(false), [location.pathname])
  useEffect(() => {
    document.body.style.overflow = drawerOpen ? 'hidden' : ''
    return () => {
      document.body.style.overflow = ''
    }
  }, [drawerOpen])

  return (
    <div className="min-h-dvh">
      <header className="sticky top-0 z-30 border-b border-border bg-surface/90 backdrop-blur supports-[backdrop-filter]:bg-surface/75">
        <div className="mx-auto flex h-16 max-w-7xl items-center gap-3 px-3 sm:px-5">
          <button
            type="button"
            aria-label="Open navigation"
            onClick={() => setDrawerOpen(true)}
            className="grid h-11 w-11 shrink-0 place-items-center rounded-xl hover:bg-surface-2 lg:hidden"
          >
            <Icon name="menu" />
          </button>

          <Brand />

          <div className="mx-auto hidden w-full max-w-xl md:block">
            <SearchBar />
          </div>

          <div className="ml-auto flex items-center gap-1.5 md:ml-0">
            <div className="hidden sm:block">
              <ThemeSwitcher />
            </div>
            <Link
              to="/search"
              aria-label="Search"
              className="grid h-11 w-11 place-items-center rounded-xl hover:bg-surface-2 md:hidden"
            >
              <Icon name="search" />
            </Link>
            {mode === 'authed' ? <UserMenu /> : <RoleBadge />}
          </div>
        </div>
      </header>

      <div className="mx-auto flex max-w-7xl gap-6 px-3 sm:px-5">
        <aside className="hidden w-64 shrink-0 lg:block">
          <div className="sticky top-[4.5rem] max-h-[calc(100dvh-5.5rem)] overflow-y-auto py-5 pr-1">
            <NavTree />
          </div>
        </aside>

        <main className="min-w-0 flex-1 py-5 pb-20">
          <Suspense fallback={<LoadingState />}>
            <Outlet />
          </Suspense>
        </main>
      </div>

      {drawerOpen && (
        <div className="fixed inset-0 z-50 lg:hidden">
          <div
            className="absolute inset-0 bg-black/40 animate-fade-in"
            onClick={() => setDrawerOpen(false)}
            aria-hidden="true"
          />
          <div className="absolute inset-y-0 left-0 flex w-[85%] max-w-xs flex-col bg-surface shadow-xl">
            <div className="flex h-16 items-center justify-between border-b border-border px-4">
              <Brand />
              <button
                type="button"
                aria-label="Close navigation"
                onClick={() => setDrawerOpen(false)}
                className="grid h-11 w-11 place-items-center rounded-xl hover:bg-surface-2"
              >
                <Icon name="close" />
              </button>
            </div>
            <div className="flex-1 overflow-y-auto p-3">
              <div className="mb-3">
                <SearchBar />
              </div>
              <NavTree onNavigate={() => setDrawerOpen(false)} />
            </div>
            <div className="border-t border-border p-3">
              <ThemeSwitcher />
            </div>
          </div>
        </div>
      )}
    </div>
  )
}
