import {
  createContext,
  useContext,
  useEffect,
  useMemo,
  useState,
  type ReactNode,
} from 'react'
import type { Session } from '@supabase/supabase-js'
import { supabase } from './supabase'
import type { Database } from './database.types'

export type Profile = Database['public']['Tables']['profiles']['Row']

type AuthState = {
  session: Session | null
  profile: Profile | null
  loading: boolean
  isAdmin: boolean
  signIn: (email: string, password: string) => Promise<void>
  signOut: () => Promise<void>
}

const AuthContext = createContext<AuthState | undefined>(undefined)

async function fetchProfile(userId: string): Promise<Profile | null> {
  const { data, error } = await supabase
    .from('profiles')
    .select('*')
    .eq('id', userId)
    .maybeSingle()
  if (error) throw error
  return data
}

export function AuthProvider({ children }: { children: ReactNode }) {
  const [session, setSession] = useState<Session | null>(null)
  const [profile, setProfile] = useState<Profile | null>(null)
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    let active = true
    // Tracks whose profile is currently loaded: undefined = not initialised
    // yet, null = signed out, string = that user. Supabase re-checks the
    // session whenever the tab regains focus and re-emits an auth event
    // (SIGNED_IN / TOKEN_REFRESHED) for the *same* user. Reloading on those
    // flipped `loading` back to true and flashed the whole app's loading
    // screen on every tab switch, so we skip them and only (re)load the
    // profile when the signed-in user actually changes.
    let loadedUserId: string | null | undefined = undefined

    async function load(nextSession: Session | null) {
      const userId = nextSession?.user?.id ?? null
      if (!userId) {
        loadedUserId = null
        if (active) {
          setProfile(null)
          setLoading(false)
        }
        return
      }
      try {
        const p = await fetchProfile(userId)
        if (!active) return
        // No profile, or deactivated account => treat as no access.
        if (!p || !p.is_active) {
          await supabase.auth.signOut()
          loadedUserId = null
          setProfile(null)
          setSession(null)
        } else {
          loadedUserId = userId
          setProfile(p)
        }
      } catch {
        if (active) setProfile(null)
      } finally {
        if (active) setLoading(false)
      }
    }

    supabase.auth.getSession().then(({ data }) => {
      if (!active) return
      setSession(data.session)
      const userId = data.session?.user?.id ?? null
      if (userId === loadedUserId) return
      void load(data.session)
    })

    const { data: sub } = supabase.auth.onAuthStateChange((_event, nextSession) => {
      setSession(nextSession)
      const nextUserId = nextSession?.user?.id ?? null
      // Same user (or still signed out) => keep the refreshed session, but do
      // not reload the profile or flip `loading`, which would reload the app.
      if (nextUserId === loadedUserId) return
      setLoading(true)
      void load(nextSession)
    })

    return () => {
      active = false
      sub.subscription.unsubscribe()
    }
  }, [])

  const value = useMemo<AuthState>(
    () => ({
      session,
      profile,
      loading,
      isAdmin: Boolean(profile?.is_admin),
      async signIn(email, password) {
        const { error } = await supabase.auth.signInWithPassword({ email, password })
        if (error) throw error
      },
      async signOut() {
        await supabase.auth.signOut()
        setProfile(null)
        setSession(null)
      },
    }),
    [session, profile, loading],
  )

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>
}

// eslint-disable-next-line react-refresh/only-export-components
export function useAuth(): AuthState {
  const ctx = useContext(AuthContext)
  if (!ctx) throw new Error('useAuth must be used within <AuthProvider>')
  return ctx
}
