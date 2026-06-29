import { useQuery } from '@tanstack/react-query'
import { supabase } from './supabase'
import type { UserRole } from './database.types'

export type AccessLink = {
  token: string
  role: UserRole
  label: string | null
  is_active: boolean
  created_at: string
}

// Strong, unguessable token. CSPRNG over an alphabet without look-alike
// characters (no 0/O/1/I/l). 26 chars of this 56-char alphabet is ~150 bits of
// entropy, so the link is infeasible to brute-force even though the reader RPCs
// are reachable with the public anon key. Rejection sampling avoids modulo bias.
// The database also enforces a minimum token length, so a weak token cannot be
// stored even if this generator regressed.
const ALPHABET = 'ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnpqrstuvwxyz23456789'
const TOKEN_LEN = 26
export function newToken(): string {
  const limit = Math.floor(256 / ALPHABET.length) * ALPHABET.length
  const buf = new Uint8Array(1)
  let out = ''
  while (out.length < TOKEN_LEN) {
    crypto.getRandomValues(buf)
    if (buf[0] < limit) out += ALPHABET[buf[0] % ALPHABET.length]
  }
  return out
}

export function linkUrl(token: string): string {
  return `${window.location.origin}/r/${token}`
}

export function useAccessLinks() {
  return useQuery({
    queryKey: ['admin', 'links'],
    queryFn: async (): Promise<AccessLink[]> => {
      const { data, error } = await supabase
        .from('access_links')
        .select('*')
        .order('role')
      if (error) throw error
      return data ?? []
    },
  })
}

// Rotate = mint a new token in place; the old link stops working immediately.
export async function rotateLink(oldToken: string): Promise<string> {
  const token = newToken()
  const { error } = await supabase.from('access_links').update({ token }).eq('token', oldToken)
  if (error) throw error
  return token
}

export async function setLinkActive(token: string, isActive: boolean): Promise<void> {
  const { error } = await supabase.from('access_links').update({ is_active: isActive }).eq('token', token)
  if (error) throw error
}

export async function createLink(role: UserRole, label: string): Promise<void> {
  const { error } = await supabase
    .from('access_links')
    .insert({ token: newToken(), role, label: label.trim() || null })
  if (error) throw error
}

export async function deleteLink(token: string): Promise<void> {
  const { error } = await supabase.from('access_links').delete().eq('token', token)
  if (error) throw error
}
