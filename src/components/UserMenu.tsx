import { useState } from 'react'
import { Link, useNavigate } from 'react-router-dom'
import { useAuth } from '@/lib/auth'
import { useClickOutside } from '@/lib/hooks'
import { roleLabel } from '@/lib/roles'
import { Icon } from './Icon'

function initials(name: string): string {
  return name
    .trim()
    .split(/\s+/)
    .slice(0, 2)
    .map((w) => w[0]?.toUpperCase() ?? '')
    .join('')
}

export function UserMenu() {
  const { profile, isAdmin, signOut } = useAuth()
  const [open, setOpen] = useState(false)
  const navigate = useNavigate()
  const ref = useClickOutside<HTMLDivElement>(() => setOpen(false))

  if (!profile) return null

  async function handleSignOut() {
    setOpen(false)
    await signOut()
    navigate('/login', { replace: true })
  }

  return (
    <div ref={ref} className="relative">
      <button
        type="button"
        onClick={() => setOpen((v) => !v)}
        aria-haspopup="menu"
        aria-expanded={open}
        className="grid h-11 w-11 place-items-center rounded-full bg-brand text-brand-fg text-sm font-bold transition-transform hover:scale-105"
        title={profile.full_name}
      >
        {initials(profile.full_name) || <Icon name="users" size={18} />}
      </button>

      {open && (
        <div
          role="menu"
          className="absolute right-0 z-40 mt-2 w-60 overflow-hidden rounded-2xl border border-border bg-surface shadow-lg animate-fade-in"
        >
          <div className="border-b border-border px-4 py-3">
            <p className="font-semibold text-fg">{profile.full_name}</p>
            <div className="mt-1 flex items-center gap-2">
              <span className="chip">{roleLabel(profile.role)}</span>
              {isAdmin && <span className="chip-brand">Admin</span>}
            </div>
          </div>
          <div className="p-1.5">
            {isAdmin && (
              <Link
                to="/admin"
                role="menuitem"
                onClick={() => setOpen(false)}
                className="flex items-center gap-3 rounded-xl px-3 min-h-[44px] text-sm font-medium text-fg hover:bg-surface-2"
              >
                <Icon name="settings" size={18} />
                Admin
              </Link>
            )}
            <button
              type="button"
              role="menuitem"
              onClick={handleSignOut}
              className="flex w-full items-center gap-3 rounded-xl px-3 min-h-[44px] text-sm font-medium text-danger hover:bg-danger-soft/50"
            >
              <Icon name="logout" size={18} />
              Sign out
            </button>
          </div>
        </div>
      )}
    </div>
  )
}
