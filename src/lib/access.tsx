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
const INFO_KEY = 'hb_link_info'

// How the current visitor is reading the handbook:
//  - 'authed': the founder is logged in (can author; sees everything).
//  - 'token':  a teammate opened their role link (no login, read-only).
//  - 'none':   no session and no valid link.
type AccessMode = 'authed' | 'token' | 'none'
type LinkInfo = { role: UserRole; label: string | null }

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

function readCachedInfo(): LinkInfo | null {
  try {
    const raw = localStorage.getItem(INFO_KEY)
    return raw ? (JSON.parse(raw) as LinkInfo) : null
  } catch {
    return null
  }
}

export function AccessProvider({ children }: { children: ReactNode }) {
  const { session, profile, loading: authLoading } = useAuth()
  const [token, setToken] = useState<string | null>(() => localStorage.getItem(TOKEN_KEY))
  // undefined = still validating with nothing cached, null = invalid/absent,
  // object = valid link (possibly from cache, so the app opens instantly).
  const [tokenInfo, setTokenInfo] = useState<LinkInfo | null | undefined>(() => {
    if (!localStorage.getItem(TOKEN_KEY)) return null
    return readCachedInfo() ?? undefined
  })

  const authed = Boolean(session && profile)

  // Re-validate the stored token in the background. If we already have a cached
  // role the UI is showing, so this just confirms or corrects it without a
  // loading spinner. Content RPCs validate the token server-side regardless,
  // so an optimistic render is safe.
  useEffect(() => {
    let active = true
    if (authed) return
    if (!token) {
      setTokenInfo(null)
      return
    }
    void (async () => {
      try {
        const { data } = await supabase.rpc('link_info', { p_token: token })
        if (!active) return
        const row = data?.[0]
        if (row) {
          const info = { role: row.role, label: row.label }
          setTokenInfo(info)
          localStorage.setItem(INFO_KEY, JSON.stringify(info))
        } else {
          localStorage.removeItem(INFO_KEY)
          setTokenInfo(null)
        }
      } catch {
        /* offline or transient: keep whatever we have cached */
      }
    })()
    return () => {
      active = false
    }
  }, [token, authed])

  const applyToken = useCallback(async (t: string): Promise<boolean> => {
    const { data } = await supabase.rpc('link_info', { p_token: t })
    const row = data?.[0]
    if (!row) return false
    const info = { role: row.role, label: row.label }
    localStorage.setItem(TOKEN_KEY, t)
    localStorage.setItem(INFO_KEY, JSON.stringify(info))
    setToken(t)
    setTokenInfo(info)
    return true
  }, [])

  const clearToken = useCallback(() => {
    localStorage.removeItem(TOKEN_KEY)
    localStorage.removeItem(INFO_KEY)
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
      // first visit with no cache: validating
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
