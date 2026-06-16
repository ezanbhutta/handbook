import { Navigate, Outlet } from 'react-router-dom'
import { useAccess } from '@/lib/access'
import { LoadingState } from './States'

// Any reader — the logged-in founder OR a teammate with a valid role link.
export function ProtectedRoute() {
  const access = useAccess()
  if (!access.ready) {
    return (
      <div className="grid min-h-dvh place-items-center">
        <LoadingState label="Opening your handbook…" />
      </div>
    )
  }
  if (access.mode === 'none') return <Navigate to="/welcome" replace />
  return <Outlet />
}

// Admin-only (authoring, users, synonyms, links, insights).
export function AdminRoute() {
  const access = useAccess()
  if (!access.ready) {
    return (
      <div className="grid min-h-dvh place-items-center">
        <LoadingState />
      </div>
    )
  }
  if (!access.isAdmin) return <Navigate to="/" replace />
  return <Outlet />
}
