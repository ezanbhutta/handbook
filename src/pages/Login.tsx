import { useState } from 'react'
import { Navigate, useLocation } from 'react-router-dom'
import { useAuth } from '@/lib/auth'
import { Icon } from '@/components/Icon'
import { Logo } from '@/components/Logo'
import { Spinner, InlineError } from '@/components/States'

export function Login() {
  const { session, profile, loading, signIn } = useAuth()
  const location = useLocation()
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [showPassword, setShowPassword] = useState(false)
  const [error, setError] = useState('')
  const [submitting, setSubmitting] = useState(false)

  const from = (location.state as { from?: string } | null)?.from ?? '/'

  if (!loading && session && profile) {
    return <Navigate to={from} replace />
  }

  async function onSubmit(e: React.FormEvent) {
    e.preventDefault()
    setError('')
    setSubmitting(true)
    try {
      await signIn(email.trim(), password)
      // AuthProvider picks up the session; the redirect above handles the rest.
    } catch (err) {
      setError(
        err instanceof Error && /invalid login/i.test(err.message)
          ? 'Wrong email or password.'
          : err instanceof Error
            ? err.message
            : 'Could not sign in.',
      )
    } finally {
      setSubmitting(false)
    }
  }

  return (
    <div className="grid min-h-dvh place-items-center bg-bg px-4 py-10">
      <div className="w-full max-w-sm">
        <div className="mb-7 flex flex-col items-center text-center">
          <Logo size={56} className="drop-shadow-[0_10px_30px_rgba(114,41,255,0.35)]" />
          <h1 className="mt-4 text-2xl font-bold tracking-tight">
            Haseeb<span className="text-brand">Madeit</span> Handbook
          </h1>
          <p className="mt-1 text-sm text-muted">Sign in to your account to continue.</p>
        </div>

        <form onSubmit={onSubmit} className="card p-6 shadow-sm">
          <div className="space-y-4">
            <div>
              <label htmlFor="email" className="label">
                Email
              </label>
              <input
                id="email"
                type="email"
                autoComplete="email"
                required
                autoFocus
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                className="input"
                placeholder="you@haseebmadeit.com"
              />
            </div>

            <div>
              <label htmlFor="password" className="label">
                Password
              </label>
              <div className="relative">
                <input
                  id="password"
                  type={showPassword ? 'text' : 'password'}
                  autoComplete="current-password"
                  required
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  className="input pr-11"
                  placeholder="••••••••"
                />
                <button
                  type="button"
                  aria-label={showPassword ? 'Hide password' : 'Show password'}
                  onClick={() => setShowPassword((v) => !v)}
                  className="absolute right-2 top-1/2 grid h-8 w-8 -translate-y-1/2 place-items-center rounded-lg text-muted hover:bg-surface-2"
                >
                  <Icon name={showPassword ? 'eye-off' : 'eye'} size={18} />
                </button>
              </div>
            </div>

            {error && <InlineError>{error}</InlineError>}

            <button type="submit" disabled={submitting} className="btn-primary w-full">
              {submitting ? (
                <>
                  <Spinner /> Signing in…
                </>
              ) : (
                'Sign in'
              )}
            </button>
          </div>
        </form>

        <p className="mt-5 text-center text-xs text-muted">
          Accounts are created by your admin. No public sign-up.
        </p>
      </div>
    </div>
  )
}
