import {
  createContext,
  useCallback,
  useContext,
  useEffect,
  useMemo,
  useState,
  type ReactNode,
} from 'react'
import { supabase } from './supabase'
import { useAuth } from './auth'
import type { UserRole } from './database.types'

const TOKEN_KEY = 'hb_link_token'

// How the current visitor is reading the handbook:
//  - 'authed': the founder is logged in (can author; sees everything).
//  - 'token':  a teammate opened their role link (no login, read-only).
//  - 'none':   no session and no valid link.
type AccessMode = 'authed' | 'token' | 'none'

type AccessState = {
  ready: boolean
  mode: AccessMode
  role: UserRole | null
  label: string | null
  token: string | null
  isAdmin: boolean
  applyToken: (t: string) => Promise<boolean>
  clearToken: () => void
}

const AccessContext = createContext<AccessState | undefined>(undefined)

export function AccessProvider({ children }: { children: ReactNode }) {
  const { session, profile, loading: authLoading } = useAuth()
  const [token, setToken] = useState<string | null>(() => localStorage.getItem(TOKEN_KEY))
  // undefined = still validating, null = invalid/absent, object = valid link
  const [tokenInfo, setTokenInfo] = useState<
    { role: UserRole; label: string | null } | null | undefined
  >(() => (localStorage.getItem(TOKEN_KEY) ? undefined : null))

  const authed = Boolean(session && profile)

  // Validate the stored token (only matters when not logged in).
  useEffect(() => {
    let active = true
    if (authed) return
    if (!token) {
      setTokenInfo(null)
      return
    }
    setTokenInfo(undefined)
    supabase.rpc('link_info', { p_token: token }).then(({ data }) => {
      if (!active) return
      const row = data?.[0]
      setTokenInfo(row ? { role: row.role, label: row.label } : null)
    })
    return () => {
      active = false
    }
  }, [token, authed])

  const applyToken = useCallback(async (t: string): Promise<boolean> => {
    const { data } = await supabase.rpc('link_info', { p_token: t })
    const row = data?.[0]
    if (!row) return false
    localStorage.setItem(TOKEN_KEY, t)
    setToken(t)
    setTokenInfo({ role: row.role, label: row.label })
    return true
  }, [])

  const clearToken = useCallback(() => {
    localStorage.removeItem(TOKEN_KEY)
    setToken(null)
    setTokenInfo(null)
  }, [])

  const value = useMemo<AccessState>(() => {
    const base = { applyToken, clearToken }
    if (authLoading) {
      return { ready: false, mode: 'none', role: null, label: null, token: null, isAdmin: false, ...base }
    }
    if (authed && profile) {
      return {
        ready: true,
        mode: 'authed',
        role: profile.role,
        label: null,
        token: null,
        isAdmin: profile.is_admin,
        ...base,
      }
    }
    if (token && tokenInfo === undefined) {
      // still validating the link
      return { ready: false, mode: 'none', role: null, label: null, token, isAdmin: false, ...base }
    }
    if (token && tokenInfo) {
      return {
        ready: true,
        mode: 'token',
        role: tokenInfo.role,
        label: tokenInfo.label,
        token,
        isAdmin: false,
        ...base,
      }
    }
    return { ready: true, mode: 'none', role: null, label: null, token: null, isAdmin: false, ...base }
  }, [authLoading, authed, profile, token, tokenInfo, applyToken, clearToken])

  return <AccessContext.Provider value={value}>{children}</AccessContext.Provider>
}

// eslint-disable-next-line react-refresh/only-export-components
export function useAccess(): AccessState {
  const ctx = useContext(AccessContext)
  if (!ctx) throw new Error('useAccess must be used within <AccessProvider>')
  return ctx
}
