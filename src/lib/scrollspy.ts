import { useSyncExternalStore } from 'react'

// Tracks which section is currently under the top of the viewport, so the
// sidebar can highlight it as the reader scrolls. The chapter page is the only
// writer (via a scroll listener); the sidebar reads it. Kept as a tiny external
// store so an update never re-renders the whole app, only the subscribers.
let activeSlug = ''
const listeners = new Set<() => void>()

export function setActiveSection(slug: string): void {
  if (slug === activeSlug) return
  activeSlug = slug
  for (const l of listeners) l()
}

function subscribe(cb: () => void): () => void {
  listeners.add(cb)
  return () => listeners.delete(cb)
}

export function useActiveSection(): string {
  return useSyncExternalStore(
    subscribe,
    () => activeSlug,
    () => activeSlug,
  )
}
