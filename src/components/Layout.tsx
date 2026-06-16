import { Suspense, useEffect, useState } from 'react'
import { Link, Outlet, useLocation } from 'react-router-dom'
import { Icon } from './Icon'
import { SearchBar } from './SearchBar'
import { NavTree } from './NavTree'
import { UserMenu } from './UserMenu'
import { LoadingState } from './States'

function Brand() {
  return (
    <Link to="/" className="flex items-center gap-2.5" aria-label="HaseebMadeIt Handbook — home">
      <span className="grid h-9 w-9 place-items-center rounded-xl bg-brand text-brand-fg">
        <Icon name="book" size={20} />
      </span>
      <span className="text-base font-bold tracking-tight">
        Haseeb<span className="text-brand">MadeIt</span>
      </span>
    </Link>
  )
}

export function Layout() {
  const [drawerOpen, setDrawerOpen] = useState(false)
  const location = useLocation()

  // Close the mobile drawer whenever the route changes.
  useEffect(() => setDrawerOpen(false), [location.pathname])

  // Lock body scroll while the drawer is open.
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

          <div className="ml-auto flex items-center gap-1 md:ml-0">
            <Link
              to="/search"
              aria-label="Search"
              className="grid h-11 w-11 place-items-center rounded-xl hover:bg-surface-2 md:hidden"
            >
              <Icon name="search" />
            </Link>
            <UserMenu />
          </div>
        </div>
      </header>

      <div className="mx-auto flex max-w-7xl gap-6 px-3 sm:px-5">
        {/* Desktop sidebar */}
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

      {/* Mobile drawer */}
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
            <div className="overflow-y-auto p-3">
              <div className="mb-3">
                <SearchBar />
              </div>
              <NavTree onNavigate={() => setDrawerOpen(false)} />
            </div>
          </div>
        </div>
      )}
    </div>
  )
}
