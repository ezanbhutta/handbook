-- =============================================================================
-- HaseebMadeIt Handbook — 0005 storage
-- A bucket for section images, with admin-only writes.
--
-- Trade-off: the bucket is PUBLIC so images embed in markdown with stable URLs.
-- Paths are UUID-based (unguessable), and no client data is stored. Section
-- *text* remains fully RLS-gated; only inlined images are publicly fetchable by
-- URL. For truly sensitive imagery, switch to a private bucket + signed URLs
-- (a V1.5 upgrade) — note that markdown <img> src would then need refreshing.
-- =============================================================================

insert into storage.buckets (id, name, public)
values ('handbook', 'handbook', true)
on conflict (id) do nothing;

-- Any signed-in user can read; only admins can write/modify/delete.
drop policy if exists "handbook images read" on storage.objects;
create policy "handbook images read" on storage.objects for select
  using (bucket_id = 'handbook' and auth.uid() is not null);

drop policy if exists "handbook images write" on storage.objects;
create policy "handbook images write" on storage.objects for all
  using (bucket_id = 'handbook' and is_admin())
  with check (bucket_id = 'handbook' and is_admin());
