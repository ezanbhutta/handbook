import { useQuery } from '@tanstack/react-query'
import { supabase } from './supabase'
import type { Database, UserRole } from './database.types'

export type Chapter = Database['public']['Tables']['chapters']['Row']
export type Section = Database['public']['Tables']['sections']['Row']
export type ChangeLogEntry = Database['public']['Tables']['change_log']['Row']
// Enriched with the current section slug (when the section still exists and is
// visible) so entries can link straight to the section.
export type ChangeLogEntryWithSlug = ChangeLogEntry & {
  section: { slug: string } | null
}
export type SearchResult = Database['public']['Functions']['search_handbook']['Returns'][number]

export type NavSection = { id: string; title: string; slug: string; order: number }
export type NavChapter = {
  id: string
  title: string
  slug: string
  order: number
  icon: string | null
  description: string | null
  sections: NavSection[]
}

// ---- Navigation (permission-filtered tree) ----------------------------------
export function useNavigation() {
  return useQuery({
    queryKey: ['navigation'],
    queryFn: async (): Promise<NavChapter[]> => {
      const { data, error } = await supabase.rpc('get_navigation')
      if (error) throw error

      const byChapter = new Map<string, NavChapter>()
      for (const row of data ?? []) {
        let chapter = byChapter.get(row.chapter_id)
        if (!chapter) {
          chapter = {
            id: row.chapter_id,
            title: row.chapter_title,
            slug: row.chapter_slug,
            order: row.chapter_order,
            icon: row.chapter_icon,
            description: row.chapter_description,
            sections: [],
          }
          byChapter.set(row.chapter_id, chapter)
        }
        chapter.sections.push({
          id: row.section_id,
          title: row.section_title,
          slug: row.section_slug,
          order: row.section_order,
        })
      }
      return [...byChapter.values()]
    },
  })
}

// ---- A chapter + its visible sections ---------------------------------------
export function useChapter(slug: string | undefined) {
  return useQuery({
    enabled: Boolean(slug),
    queryKey: ['chapter', slug],
    queryFn: async () => {
      const { data: chapter, error } = await supabase
        .from('chapters')
        .select('*')
        .eq('slug', slug!)
        .maybeSingle()
      if (error) throw error
      if (!chapter) return null

      const { data: sections, error: sErr } = await supabase
        .from('sections')
        .select('id, title, slug, order_index, show_in_onboarding')
        .eq('chapter_id', chapter.id)
        .order('order_index')
      if (sErr) throw sErr

      return { chapter, sections: sections ?? [] }
    },
  })
}

// ---- A single section (with its chapter) ------------------------------------
export function useSection(slug: string | undefined) {
  return useQuery({
    enabled: Boolean(slug),
    queryKey: ['section', slug],
    queryFn: async () => {
      const { data, error } = await supabase
        .from('sections')
        .select('*, chapters(title, slug)')
        .eq('slug', slug!)
        .maybeSingle()
      if (error) throw error
      return data as unknown as
        | (Section & { chapters: { title: string; slug: string } | null })
        | null
    },
  })
}

// ---- What's New: the single latest entry the viewer may see (the banner) -----
export function useLatestChange() {
  return useQuery({
    queryKey: ['change_log', 'latest'],
    queryFn: async (): Promise<ChangeLogEntryWithSlug | null> => {
      const { data, error } = await supabase
        .from('change_log')
        .select('*, section:sections(slug)')
        .order('created_at', { ascending: false })
        .limit(1)
        .maybeSingle()
      if (error) throw error
      return data as unknown as ChangeLogEntryWithSlug | null
    },
  })
}

// ---- What's New: the full, permission-filtered history (Chapter 12) ----------
export function useChangeLog() {
  return useQuery({
    queryKey: ['change_log', 'all'],
    queryFn: async (): Promise<ChangeLogEntryWithSlug[]> => {
      const { data, error } = await supabase
        .from('change_log')
        .select('*, section:sections(slug)')
        .order('created_at', { ascending: false })
        .limit(200)
      if (error) throw error
      return (data ?? []) as unknown as ChangeLogEntryWithSlug[]
    },
  })
}

// ---- "Start Here for [role]" onboarding list --------------------------------
export type OnboardingSection = {
  id: string
  title: string
  slug: string
  chapters: { title: string; slug: string } | null
}
export function useOnboarding(enabled: boolean) {
  return useQuery({
    enabled,
    queryKey: ['onboarding'],
    queryFn: async (): Promise<OnboardingSection[]> => {
      const { data, error } = await supabase
        .from('sections')
        .select('id, title, slug, chapters(title, slug)')
        .eq('show_in_onboarding', true)
        .order('order_index')
      if (error) throw error
      return (data ?? []) as unknown as OnboardingSection[]
    },
  })
}

// ---- Search (V1: typo + keyword + synonym, RLS-aware) -----------------------
export function useSearch(query: string) {
  const q = query.trim()
  return useQuery({
    enabled: q.length >= 2,
    queryKey: ['search', q],
    queryFn: async (): Promise<SearchResult[]> => {
      const { data, error } = await supabase.rpc('search_handbook', { q })
      if (error) throw error
      return data ?? []
    },
    staleTime: 30_000,
  })
}

// ---- Silent search logging (raw material for the future Gap Report) ---------
// No SELECT policy for non-admins, so we mint the row id locally instead of
// relying on INSERT ... RETURNING. Everything here is fire-and-forget.
export async function logSearch(
  userId: string,
  query: string,
  resultsCount: number,
): Promise<string | null> {
  const id = crypto.randomUUID()
  const { error } = await supabase.from('search_log').insert({
    id,
    user_id: userId,
    query_text: query,
    results_count: resultsCount,
  })
  return error ? null : id
}

export async function logSearchClick(logId: string, sectionId: string): Promise<void> {
  await supabase.from('search_log').update({ clicked_section_id: sectionId }).eq('id', logId)
}

export type { UserRole }
