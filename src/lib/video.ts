// Turn a Google Drive share link into an embeddable /preview URL. Returns null
// for anything we don't recognize, so callers can fall back to a plain link.
export function driveEmbedUrl(url: string | null | undefined): string | null {
  if (!url) return null
  const byPath = url.match(/\/d\/([A-Za-z0-9_-]+)/)
  const byQuery = url.match(/[?&]id=([A-Za-z0-9_-]+)/)
  const id = byPath?.[1] ?? byQuery?.[1]
  if (id) return `https://drive.google.com/file/d/${id}/preview`
  return null
}
