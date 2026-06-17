import { useQuery } from '@tanstack/react-query'
import { supabase } from './supabase'
import { useAccess } from './access'
import type { Database } from './database.types'

// The team roster drives the Company Hierarchy section. Admins edit it; readers
// see it through a token RPC. Removing a row removes that person everywhere the
// handbook shows the team.
export type RosterMember = {
  id: string
  name: string
  role: string
  shift: string | null
  off_day: string | null
  order_index: number
  active: boolean
}

export const ROSTER_ROLES = ['CEO', 'Team Leader', 'Senior', 'Project Manager', 'CSR'] as const
export const ROSTER_SHIFTS = ['Morning', 'Evening', 'Night'] as const
export const OFF_DAYS = [
  'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday',
] as const

// ---- Reader / shared (the widget) ------------------------------------------
export function useRoster() {
  const access = useAccess()
  return useQuery({
    enabled: access.ready && access.mode !== 'none',
    queryKey: ['roster', access.mode, access.token],
    queryFn: async (): Promise<RosterMember[]> => {
      if (access.mode === 'token') {
        const { data, error } = await supabase.rpc('roster_for_token', { p_token: access.token! })
        if (error) throw error
        return (data ?? []) as RosterMember[]
      }
      const { data, error } = await supabase
        .from('roster')
        .select('id, name, role, shift, off_day, order_index, active')
        .eq('active', true)
        .order('order_index')
      if (error) throw error
      return (data ?? []) as RosterMember[]
    },
  })
}

// ---- Admin -----------------------------------------------------------------
export type RosterRow = Database['public']['Tables']['roster']['Row']

export function useAdminRoster() {
  return useQuery({
    queryKey: ['admin', 'roster'],
    queryFn: async (): Promise<RosterRow[]> => {
      const { data, error } = await supabase.from('roster').select('*').order('order_index')
      if (error) throw error
      return data ?? []
    },
  })
}

export type RosterInput = {
  name: string
  role: string
  shift: string | null
  off_day: string | null
  order_index: number
  active: boolean
}

export async function createRosterMember(input: RosterInput): Promise<void> {
  const { error } = await supabase.from('roster').insert(input)
  if (error) throw error
}

export async function updateRosterMember(id: string, patch: Partial<RosterInput>): Promise<void> {
  const { error } = await supabase
    .from('roster')
    .update({ ...patch, updated_at: new Date().toISOString() })
    .eq('id', id)
  if (error) throw error
}

export async function deleteRosterMember(id: string): Promise<void> {
  const { error } = await supabase.from('roster').delete().eq('id', id)
  if (error) throw error
}
