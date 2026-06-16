import { useQuery } from '@tanstack/react-query'
import { supabase } from './supabase'
import type { ChangeType, UserRole } from './database.types'
import type { Chapter, Section } from './queries'

// URL-safe slug from a title. Admin can still override it in the editor.
export function slugify(text: string): string {
  return text
    .toLowerCase()
    .normalize('NFKD')
    .replace(/\p{Diacritic}/gu, '') // strip combining diacritic marks
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-+|-+$/g, '')
    .slice(0, 80)
}

// ===== Chapters ==============================================================
export function useAdminChapters() {
  return useQuery({
    queryKey: ['admin', 'chapters'],
    queryFn: async (): Promise<Chapter[]> => {
      const { data, error } = await supabase
        .from('chapters')
        .select('*')
        .order('order_index')
      if (error) throw error
      return data ?? []
    },
  })
}

export type ChapterInput = {
  title: string
  slug: string
  description: string | null
  icon: string | null
  order_index: number
}

export async function createChapter(input: ChapterInput): Promise<Chapter> {
  const { data, error } = await supabase.from('chapters').insert(input).select('*').single()
  if (error) throw error
  return data
}

export async function updateChapter(id: string, patch: Partial<ChapterInput>): Promise<void> {
  const { error } = await supabase
    .from('chapters')
    .update({ ...patch, updated_at: new Date().toISOString() })
    .eq('id', id)
  if (error) throw error
}

export async function deleteChapter(id: string): Promise<void> {
  const { error } = await supabase.from('chapters').delete().eq('id', id)
  if (error) throw error
}

// ===== Sections ==============================================================
export type AdminSectionRow = Pick<
  Section,
  'id' | 'title' | 'slug' | 'order_index' | 'allowed_roles' | 'show_in_onboarding' | 'updated_at'
> & { chapter_id: string }

export function useAdminSections(chapterId?: string) {
  return useQuery({
    queryKey: ['admin', 'sections', chapterId ?? 'all'],
    queryFn: async (): Promise<AdminSectionRow[]> => {
      let q = supabase
        .from('sections')
        .select('id, title, slug, order_index, allowed_roles, show_in_onboarding, updated_at, chapter_id')
        .order('order_index')
      if (chapterId) q = q.eq('chapter_id', chapterId)
      const { data, error } = await q
      if (error) throw error
      return (data ?? []) as AdminSectionRow[]
    },
  })
}

export function useAdminSection(id: string | undefined) {
  return useQuery({
    enabled: Boolean(id),
    queryKey: ['admin', 'section', id],
    queryFn: async (): Promise<Section | null> => {
      const { data, error } = await supabase
        .from('sections')
        .select('*')
        .eq('id', id!)
        .maybeSingle()
      if (error) throw error
      return data
    },
  })
}

export type SectionInput = {
  id?: string
  chapter_id: string
  title: string
  slug: string
  body: string
  video_url: string | null
  allowed_roles: UserRole[]
  show_in_onboarding: boolean
  order_index: number
  changeSummary: string
}

// The publish flow (brief §7): save the section, then write a change_log row
// whose allowed_roles mirror the section so the log leaks nothing and the
// What's New banner updates instantly.
export async function saveSection(input: SectionInput, userId: string): Promise<Section> {
  const isNew = !input.id
  const row = {
    chapter_id: input.chapter_id,
    title: input.title,
    slug: input.slug,
    body: input.body,
    video_url: input.video_url,
    allowed_roles: input.allowed_roles,
    show_in_onboarding: input.show_in_onboarding,
    order_index: input.order_index,
    updated_by: userId,
  }

  const saved = isNew
    ? await supabase.from('sections').insert(row).select('*').single()
    : await supabase.from('sections').update(row).eq('id', input.id!).select('*').single()
  if (saved.error) throw saved.error
  const section = saved.data

  const type: ChangeType = isNew ? 'created' : 'updated'
  const { error: logErr } = await supabase.from('change_log').insert({
    section_id: section.id,
    chapter_id: section.chapter_id,
    section_title: section.title,
    type,
    summary: input.changeSummary,
    allowed_roles: input.allowed_roles,
    changed_by: userId,
  })
  if (logErr) throw logErr

  return section
}

export async function deleteSection(
  section: Pick<Section, 'id' | 'chapter_id' | 'title' | 'allowed_roles'>,
  userId: string,
): Promise<void> {
  // Log first (snapshotting the title), then delete. The change_log FK is
  // ON DELETE SET NULL, so the entry survives with its snapshot intact.
  const { error: logErr } = await supabase.from('change_log').insert({
    section_id: section.id,
    chapter_id: section.chapter_id,
    section_title: section.title,
    type: 'deleted',
    summary: `Removed "${section.title}".`,
    allowed_roles: section.allowed_roles,
    changed_by: userId,
  })
  if (logErr) throw logErr

  const { error } = await supabase.from('sections').delete().eq('id', section.id)
  if (error) throw error
}

export async function updateSectionOrder(id: string, order_index: number): Promise<void> {
  // Reordering isn't a content change, so it intentionally writes no change_log.
  const { error } = await supabase.from('sections').update({ order_index }).eq('id', id)
  if (error) throw error
}

// ===== Synonyms ==============================================================
export type Synonym = { id: string; term: string; maps_to: string; created_at: string }

export function useSynonyms() {
  return useQuery({
    queryKey: ['admin', 'synonyms'],
    queryFn: async (): Promise<Synonym[]> => {
      const { data, error } = await supabase
        .from('search_synonyms')
        .select('*')
        .order('term')
      if (error) throw error
      return data ?? []
    },
  })
}

export async function addSynonym(term: string, mapsTo: string): Promise<void> {
  const { error } = await supabase
    .from('search_synonyms')
    .insert({ term: term.trim().toLowerCase(), maps_to: mapsTo.trim().toLowerCase() })
  if (error) throw error
}

export async function deleteSynonym(id: string): Promise<void> {
  const { error } = await supabase.from('search_synonyms').delete().eq('id', id)
  if (error) throw error
}

// ===== Users (privileged ops go through the admin-users Edge Function) =======
export type ManagedUser = {
  id: string
  email: string | null
  full_name: string
  role: UserRole
  is_admin: boolean
  is_active: boolean
  created_at: string
}

async function invokeAdminUsers<T>(body: Record<string, unknown>): Promise<T> {
  const { data, error } = await supabase.functions.invoke('admin-users', { body })
  if (error) {
    // Surface the function's JSON error message when present.
    const ctx = (error as { context?: Response }).context
    if (ctx) {
      try {
        const j = await ctx.json()
        if (j?.error) throw new Error(j.error)
      } catch {
        /* fall through */
      }
    }
    throw error
  }
  if (data && typeof data === 'object' && 'error' in data) {
    throw new Error(String((data as { error: unknown }).error))
  }
  return data as T
}

export function useUsers() {
  return useQuery({
    queryKey: ['admin', 'users'],
    queryFn: async (): Promise<ManagedUser[]> => {
      const { users } = await invokeAdminUsers<{ users: ManagedUser[] }>({ action: 'list' })
      return users
    },
  })
}

export type CreateUserInput = {
  email: string
  password: string
  full_name: string
  role: UserRole
  is_admin: boolean
}
export async function createUser(input: CreateUserInput): Promise<void> {
  await invokeAdminUsers({ action: 'create', ...input })
}

export async function setUserPassword(userId: string, password: string): Promise<void> {
  await invokeAdminUsers({ action: 'setPassword', user_id: userId, password })
}

// Role + active are plain profiles updates the admin RLS policy already allows.
export async function setUserRole(userId: string, role: UserRole): Promise<void> {
  const { error } = await supabase.from('profiles').update({ role }).eq('id', userId)
  if (error) throw error
}

export async function setUserActive(userId: string, isActive: boolean): Promise<void> {
  const { error } = await supabase.from('profiles').update({ is_active: isActive }).eq('id', userId)
  if (error) throw error
}
