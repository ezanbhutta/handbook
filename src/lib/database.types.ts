// Hand-written to mirror supabase/migrations. Keep in sync with the schema
// (or regenerate with `supabase gen types typescript`).

export type UserRole = 'csr' | 'asr' | 'designer' | 'hr' | 'pm' | 'manager' | 'office_boy'
export type ChangeType = 'created' | 'updated' | 'deleted'

export type Database = {
  public: {
    Tables: {
      profiles: {
        Row: {
          id: string
          full_name: string
          role: UserRole
          is_admin: boolean
          is_active: boolean
          created_at: string
        }
        Insert: {
          id: string
          full_name: string
          role: UserRole
          is_admin?: boolean
          is_active?: boolean
          created_at?: string
        }
        Update: {
          id?: string
          full_name?: string
          role?: UserRole
          is_admin?: boolean
          is_active?: boolean
          created_at?: string
        }
        Relationships: []
      }
      chapters: {
        Row: {
          id: string
          title: string
          slug: string
          description: string | null
          icon: string | null
          order_index: number
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          title: string
          slug: string
          description?: string | null
          icon?: string | null
          order_index?: number
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          title?: string
          slug?: string
          description?: string | null
          icon?: string | null
          order_index?: number
          created_at?: string
          updated_at?: string
        }
        Relationships: []
      }
      sections: {
        Row: {
          id: string
          chapter_id: string
          title: string
          slug: string
          body: string
          video_url: string | null
          allowed_roles: UserRole[]
          show_in_onboarding: boolean
          order_index: number
          created_at: string
          updated_at: string
          updated_by: string | null
        }
        Insert: {
          id?: string
          chapter_id: string
          title: string
          slug: string
          body?: string
          video_url?: string | null
          allowed_roles?: UserRole[]
          show_in_onboarding?: boolean
          order_index?: number
          updated_by?: string | null
        }
        Update: {
          id?: string
          chapter_id?: string
          title?: string
          slug?: string
          body?: string
          video_url?: string | null
          allowed_roles?: UserRole[]
          show_in_onboarding?: boolean
          order_index?: number
          updated_by?: string | null
        }
        Relationships: []
      }
      change_log: {
        Row: {
          id: string
          section_id: string | null
          chapter_id: string | null
          section_title: string | null
          type: ChangeType
          summary: string
          allowed_roles: UserRole[]
          changed_by: string | null
          created_at: string
        }
        Insert: {
          id?: string
          section_id?: string | null
          chapter_id?: string | null
          section_title?: string | null
          type: ChangeType
          summary: string
          allowed_roles?: UserRole[]
          changed_by?: string | null
          created_at?: string
        }
        Update: {
          id?: string
          summary?: string
          allowed_roles?: UserRole[]
        }
        Relationships: []
      }
      search_synonyms: {
        Row: {
          id: string
          term: string
          maps_to: string
          created_at: string
        }
        Insert: {
          id?: string
          term: string
          maps_to: string
          created_at?: string
        }
        Update: {
          id?: string
          term?: string
          maps_to?: string
        }
        Relationships: []
      }
      search_log: {
        Row: {
          id: string
          user_id: string | null
          query_text: string
          results_count: number
          clicked_section_id: string | null
          searched_role: UserRole | null
          created_at: string
        }
        Insert: {
          id?: string
          user_id: string | null
          query_text: string
          results_count?: number
          clicked_section_id?: string | null
          searched_role?: UserRole | null
          created_at?: string
        }
        Update: {
          clicked_section_id?: string | null
        }
        Relationships: []
      }
      access_links: {
        Row: {
          token: string
          role: UserRole
          label: string | null
          is_active: boolean
          created_at: string
        }
        Insert: {
          token: string
          role: UserRole
          label?: string | null
          is_active?: boolean
          created_at?: string
        }
        Update: {
          token?: string
          role?: UserRole
          label?: string | null
          is_active?: boolean
        }
        Relationships: []
      }
      roster: {
        Row: {
          id: string
          name: string
          role: string
          shift: string | null
          off_day: string | null
          order_index: number
          active: boolean
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          name: string
          role?: string
          shift?: string | null
          off_day?: string | null
          order_index?: number
          active?: boolean
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          name?: string
          role?: string
          shift?: string | null
          off_day?: string | null
          order_index?: number
          active?: boolean
          updated_at?: string
        }
        Relationships: []
      }
    }
    Views: Record<string, never>
    Functions: {
      get_navigation: {
        Args: Record<string, never>
        Returns: {
          chapter_id: string
          chapter_title: string
          chapter_slug: string
          chapter_order: number
          chapter_icon: string | null
          chapter_description: string | null
          section_id: string
          section_title: string
          section_slug: string
          section_order: number
        }[]
      }
      search_handbook: {
        Args: { q: string }
        Returns: {
          section_id: string
          section_title: string
          section_slug: string
          chapter_title: string
          chapter_slug: string
          snippet: string
          rank: number
        }[]
      }
      link_info: {
        Args: { p_token: string }
        Returns: { role: UserRole; label: string | null }[]
      }
      nav_for_token: {
        Args: { p_token: string }
        Returns: {
          chapter_id: string
          chapter_title: string
          chapter_slug: string
          chapter_order: number
          chapter_icon: string | null
          chapter_description: string | null
          section_id: string
          section_title: string
          section_slug: string
          section_order: number
        }[]
      }
      chapter_for_token: {
        Args: { p_token: string; p_slug: string }
        Returns: {
          id: string
          title: string
          slug: string
          description: string | null
          icon: string | null
          order_index: number
        }[]
      }
      chapter_sections_for_token: {
        Args: { p_token: string; p_slug: string }
        Returns: {
          id: string
          title: string
          slug: string
          order_index: number
          show_in_onboarding: boolean
          body: string
          video_url: string | null
          updated_at: string
        }[]
      }
      section_for_token: {
        Args: { p_token: string; p_slug: string }
        Returns: {
          id: string
          title: string
          slug: string
          body: string
          video_url: string | null
          allowed_roles: UserRole[]
          show_in_onboarding: boolean
          updated_at: string
          chapter_title: string
          chapter_slug: string
        }[]
      }
      search_for_token: {
        Args: { p_token: string; q: string }
        Returns: {
          section_id: string
          section_title: string
          section_slug: string
          chapter_title: string
          chapter_slug: string
          snippet: string
          rank: number
        }[]
      }
      latest_change_for_token: {
        Args: { p_token: string }
        Returns: {
          id: string
          section_title: string | null
          type: ChangeType
          summary: string
          created_at: string
          section_slug: string | null
        }[]
      }
      changelog_for_token: {
        Args: { p_token: string }
        Returns: {
          id: string
          section_title: string | null
          type: ChangeType
          summary: string
          created_at: string
          section_slug: string | null
        }[]
      }
      onboarding_for_token: {
        Args: { p_token: string }
        Returns: {
          id: string
          title: string
          slug: string
          chapter_title: string
          chapter_slug: string
        }[]
      }
      log_search: {
        Args: { p_token: string; p_query: string; p_count: number }
        Returns: string
      }
      log_search_click: {
        Args: { p_token: string; p_log_id: string; p_section_id: string }
        Returns: undefined
      }
      roster_for_token: {
        Args: { p_token: string }
        Returns: {
          id: string
          name: string
          role: string
          shift: string | null
          off_day: string | null
          order_index: number
          active: boolean
        }[]
      }
    }
    Enums: {
      user_role: UserRole
      change_type: ChangeType
    }
    CompositeTypes: Record<string, never>
  }
}
