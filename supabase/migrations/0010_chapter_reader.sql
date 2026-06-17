-- =============================================================================
-- HaseebMadeit Handbook, 0010 chapter reader
-- Return full section bodies for a chapter so the reader can render a whole
-- chapter as one continuous, scrolling page (book style) instead of one
-- section per click.
-- =============================================================================

set search_path = public, extensions;

drop function if exists chapter_sections_for_token(text, text);

create or replace function chapter_sections_for_token(p_token text, p_slug text)
returns table (
  id uuid, title text, slug text, order_index int, show_in_onboarding boolean,
  body text, video_url text, updated_at timestamptz
)
language sql stable security definer set search_path = public as $$
  select s.id, s.title, s.slug, s.order_index, s.show_in_onboarding,
         s.body, s.video_url, s.updated_at
  from access_links al
  join chapters c on c.slug = p_slug
  join sections s on s.chapter_id = c.id and al.role = any(s.allowed_roles)
  where al.token = p_token and al.is_active
  order by s.order_index
$$;

grant execute on function chapter_sections_for_token(text, text) to anon, authenticated;
