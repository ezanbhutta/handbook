import { useQuery } from '@tanstack/react-query'
import { supabase } from './supabase'
import { useAccess } from './access'
import type { Database, UserRole, ChangeType } from './database.types'

export type Chapter = Database['public']['Tables']['chapters']['Row']
export type Section = Database['public']['Tables']['sections']['Row']
export type ChangeLogEntry = Database['public']['Tables']['change_log']['Row']
export type SearchResult = Database['public']['Functions']['search_handbook']['Returns'][number]

// ---- Normalized view shapes (same for the admin and reader paths) -----------
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
export type ChapterView = {
  id: string
  title: string
  slug: string
  description: string | null
  icon: string | null
}
export type SectionListItem = {
  id: string
  title: string
  slug: string
  order_index: number
  show_in_onboarding: boolean
}
export type SectionView = {
  id: string
  title: string
  slug: string
  body: string
  video_url: string | null
  allowed_roles: UserRole[]
  show_in_onboarding: boolean
  updated_at: string
  chapters: { title: string; slug: string } | null
}
export type ChangeView = {
  id: string
  section_title: string | null
  type: ChangeType
  summary: string
  created_at: string
  section: { slug: string } | null
}
export type OnboardingSection = {
  id: string
  title: string
  slug: string
  chapters: { title: string; slug: string } | null
}

// ---- Navigation -------------------------------------------------------------
export function useNavigation() {
  const access = useAccess()
  return useQuery({
    enabled: access.ready && access.mode !== 'none',
    queryKey: ['navigation', access.mode, access.role, access.token],
    queryFn: async (): Promise<NavChapter[]> => {
      const { data, error } =
        access.mode === 'token'
          ? await supabase.rpc('nav_for_token', { p_token: access.token! })
          : await supabase.rpc('get_navigation')
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
  const access = useAccess()
  return useQuery({
    enabled: Boolean(slug) && access.ready && access.mode !== 'none',
    queryKey: ['chapter', slug, access.mode, access.role, access.token],
    queryFn: async (): Promise<{ chapter: ChapterView; sections: SectionListItem[] } | null> => {
      if (access.mode === 'token') {
        const [chapterRes, sectionsRes] = await Promise.all([
          supabase.rpc('chapter_for_token', { p_token: access.token!, p_slug: slug! }),
          supabase.rpc('chapter_sections_for_token', { p_token: access.token!, p_slug: slug! }),
        ])
        if (chapterRes.error) throw chapterRes.error
        if (sectionsRes.error) throw sectionsRes.error
        const c = chapterRes.data?.[0]
        if (!c) return null
        return {
          chapter: { id: c.id, title: c.title, slug: c.slug, description: c.description, icon: c.icon },
          sections: (sectionsRes.data ?? []).map((s) => ({
            id: s.id,
            title: s.title,
            slug: s.slug,
            order_index: s.order_index,
            show_in_onboarding: s.show_in_onboarding,
          })),
        }
      }

      const { data: chapter, error } = await supabase
        .from('chapters')
        .select('id, title, slug, description, icon')
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

// ---- A single section -------------------------------------------------------
export function useSection(slug: string | undefined) {
  const access = useAccess()
  return useQuery({
    enabled: Boolean(slug) && access.ready && access.mode !== 'none',
    queryKey: ['section', slug, access.mode, access.role, access.token],
    queryFn: async (): Promise<SectionView | null> => {
      if (access.mode === 'token') {
        const { data, error } = await supabase.rpc('section_for_token', {
          p_token: access.token!,
          p_slug: slug!,
        })
        if (error) throw error
        const s = data?.[0]
        if (!s) return null
        return {
          id: s.id,
          title: s.title,
          slug: s.slug,
          body: s.body,
          video_url: s.video_url,
          allowed_roles: s.allowed_roles,
          show_in_onboarding: s.show_in_onboarding,
          updated_at: s.updated_at,
          chapters: { title: s.chapter_title, slug: s.chapter_slug },
        }
      }

      const { data, error } = await supabase
        .from('sections')
        .select('*, chapters(title, slug)')
        .eq('slug', slug!)
        .maybeSingle()
      if (error) throw error
      if (!data) return null
      const row = data as unknown as Section & { chapters: { title: string; slug: string } | null }
      return {
        id: row.id,
        title: row.title,
        slug: row.slug,
        body: row.body,
        video_url: row.video_url,
        allowed_roles: row.allowed_roles,
        show_in_onboarding: row.show_in_onboarding,
        updated_at: row.updated_at,
        chapters: row.chapters,
      }
    },
  })
}

// ---- What's New: latest entry (the banner) ----------------------------------
function mapChangeRow(row: {
  id: string
  section_title: string | null
  type: ChangeType
  summary: string
  created_at: string
  section_slug?: string | null
}): ChangeView {
  return {
    id: row.id,
    section_title: row.section_title,
    type: row.type,
    summary: row.summary,
    created_at: row.created_at,
    section: row.section_slug ? { slug: row.section_slug } : null,
  }
}

export function useLatestChange() {
  const access = useAccess()
  return useQuery({
    enabled: access.ready && access.mode !== 'none',
    queryKey: ['change_log', 'latest', access.mode, access.role, access.token],
    queryFn: async (): Promise<ChangeView | null> => {
      if (access.mode === 'token') {
        const { data, error } = await supabase.rpc('latest_change_for_token', {
          p_token: access.token!,
        })
        if (error) throw error
        return data?.[0] ? mapChangeRow(data[0]) : null
      }
      const { data, error } = await supabase
        .from('change_log')
        .select('id, section_title, type, summary, created_at, section:sections(slug)')
        .order('created_at', { ascending: false })
        .limit(1)
        .maybeSingle()
      if (error) throw error
      if (!data) return null
      const row = data as unknown as {
        id: string
        section_title: string | null
        type: ChangeType
        summary: string
        created_at: string
        section: { slug: string } | null
      }
      return { ...row }
    },
  })
}

// ---- What's New: full history (Chapter 12) ----------------------------------
export function useChangeLog() {
  const access = useAccess()
  return useQuery({
    enabled: access.ready && access.mode !== 'none',
    queryKey: ['change_log', 'all', access.mode, access.role, access.token],
    queryFn: async (): Promise<ChangeView[]> => {
      if (access.mode === 'token') {
        const { data, error } = await supabase.rpc('changelog_for_token', { p_token: access.token! })
        if (error) throw error
        return (data ?? []).map(mapChangeRow)
      }
      const { data, error } = await supabase
        .from('change_log')
        .select('id, section_title, type, summary, created_at, section:sections(slug)')
        .order('created_at', { ascending: false })
        .limit(200)
      if (error) throw error
      return (data ?? []) as unknown as ChangeView[]
    },
  })
}

// ---- "Start Here" onboarding list -------------------------------------------
export function useOnboarding() {
  const access = useAccess()
  return useQuery({
    enabled: access.ready && access.mode !== 'none',
    queryKey: ['onboarding', access.mode, access.role, access.token],
    queryFn: async (): Promise<OnboardingSection[]> => {
      if (access.mode === 'token') {
        const { data, error } = await supabase.rpc('onboarding_for_token', { p_token: access.token! })
        if (error) throw error
        return (data ?? []).map((s) => ({
          id: s.id,
          title: s.title,
          slug: s.slug,
          chapters: { title: s.chapter_title, slug: s.chapter_slug },
        }))
      }
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

// ---- Search (typo + keyword + synonym, role-filtered) -----------------------
export function useSearch(query: string) {
  const access = useAccess()
  const q = query.trim()
  return useQuery({
    enabled: q.length >= 2 && access.ready && access.mode !== 'none',
    queryKey: ['search', q, access.mode, access.role, access.token],
    queryFn: async (): Promise<SearchResult[]> => {
      const { data, error } =
        access.mode === 'token'
          ? await supabase.rpc('search_for_token', { p_token: access.token!, q })
          : await supabase.rpc('search_handbook', { q })
      if (error) throw error
      return data ?? []
    },
    staleTime: 30_000,
  })
}

// ---- Silent search logging (readers only — they're the Gap Report signal) ---
export async function logSearch(
  token: string | null,
  query: string,
  resultsCount: number,
): Promise<string | null> {
  if (!token) return null
  const { data } = await supabase.rpc('log_search', {
    p_token: token,
    p_query: query,
    p_count: resultsCount,
  })
  return (data as string | null) ?? null
}

export async function logSearchClick(
  token: string | null,
  logId: string,
  sectionId: string,
): Promise<void> {
  if (!token) return
  await supabase.rpc('log_search_click', {
    p_token: token,
    p_log_id: logId,
    p_section_id: sectionId,
  })
}
