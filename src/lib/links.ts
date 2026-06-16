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

// Short, unguessable-enough token. Uses an alphabet without look-alike
// characters (no 0/O/1/I/l) so links stay short and easy to read/type. 6 chars
// of this alphabet is ~35 bits — fine for a read-only, rotatable handbook link.
const ALPHABET = 'ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnpqrstuvwxyz23456789'
export function newToken(): string {
  const bytes = new Uint8Array(6)
  crypto.getRandomValues(bytes)
  let out = ''
  for (let i = 0; i < bytes.length; i++) out += ALPHABET[bytes[i] % ALPHABET.length]
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
