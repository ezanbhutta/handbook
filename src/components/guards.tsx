import { Navigate, Outlet, useLocation } from 'react-router-dom'
import { useAuth } from '@/lib/auth'
import { LoadingState } from './States'

// Gate for any authenticated page. While auth resolves we show a spinner so we
// never flash protected content or bounce to /login prematurely.
export function ProtectedRoute() {
  const { session, profile, loading } = useAuth()
  const location = useLocation()

  if (loading) {
    return (
      <div className="grid min-h-dvh place-items-center">
        <LoadingState label="Loading your handbook…" />
      </div>
    )
  }
  if (!session || !profile) {
    return <Navigate to="/login" replace state={{ from: location.pathname }} />
  }
  return <Outlet />
}

// Admin-only gate (authoring, users, synonyms, insights).
export function AdminRoute() {
  const { isAdmin, loading } = useAuth()
  if (loading) {
    return (
      <div className="grid min-h-dvh place-items-center">
        <LoadingState />
      </div>
    )
  }
  if (!isAdmin) return <Navigate to="/" replace />
  return <Outlet />
}
