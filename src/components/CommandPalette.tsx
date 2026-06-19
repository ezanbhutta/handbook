import { useEffect, useMemo, useRef, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { useNavigation, useSearch } from '@/lib/queries'
import { useDebouncedValue } from '@/lib/hooks'
import { chapterAccent } from '@/lib/accent'
import { Icon, chapterIcon, type IconName } from './Icon'

// The ⌘K command palette: type to jump to any chapter or section instantly
// (client-side), with full-text content matches mixed in, and Enter on an empty
// match opens the full search page. Fully keyboard-driven.
type Row = {
  key: string
  to: string
  title: string
  sub?: string
  icon: IconName
  accent: string
  tag: string
}

function score(text: string, q: string): number {
  if (text === q) return 100
  if (text.startsWith(q)) return 80
  const idx = text.indexOf(q)
  if (idx >= 0) return 60 - Math.min(idx, 40)
  let ti = 0
  for (const ch of q) {
    ti = text.indexOf(ch, ti)
    if (ti === -1) return 0
    ti++
  }
  return 8
}

export function CommandPalette({ open, onClose }: { open: boolean; onClose: () => void }) {
  const navigate = useNavigate()
  const { data: chapters = [] } = useNavigation()
  const [q, setQ] = useState('')
  const [active, setActive] = useState(0)
  const inputRef = useRef<HTMLInputElement>(null)

  const debounced = useDebouncedValue(q, 200)
  const trimmed = debounced.trim()
  const { data: searchResults = [] } = useSearch(trimmed)

  const index = useMemo<Row[]>(() => {
    const rows: Row[] = []
    chapters.forEach((c, i) => {
      const accent = chapterAccent(i)
      rows.push({ key: `c-${c.id}`, to: `/chapter/${c.slug}`, title: c.title, sub: 'Chapter', icon: chapterIcon(c.icon), accent, tag: 'chapter' })
      c.sections.forEach((s) => {
        rows.push({ key: `s-${s.id}`, to: `/chapter/${c.slug}#s-${s.slug}`, title: s.title, sub: c.title, icon: 'chevron-right', accent, tag: 'section' })
      })
    })
    return rows
  }, [chapters])

  const jump = useMemo<Row[]>(() => {
    const query = q.trim().toLowerCase()
    if (!query) return index.filter((r) => r.tag === 'chapter')
    return index
      .map((r) => ({ r, s: score(r.title.toLowerCase(), query) }))
      .filter((x) => x.s > 0)
      .sort((a, b) => b.s - a.s)
      .slice(0, 8)
      .map((x) => x.r)
  }, [q, index])

  const content = useMemo<Row[]>(() => {
    if (trimmed.length < 2) return []
    const taken = new Set(jump.map((r) => r.to))
    return searchResults
      .map<Row>((r) => ({
        key: `f-${r.section_id}`,
        to: `/chapter/${r.chapter_slug}#s-${r.section_slug}`,
        title: r.section_title,
        sub: r.chapter_title,
        icon: 'search',
        accent: '#7229FF',
        tag: 'in text',
      }))
      .filter((r) => !taken.has(r.to))
      .slice(0, 6)
  }, [searchResults, trimmed, jump])

  const rows = useMemo(() => [...jump, ...content], [jump, content])

  useEffect(() => setActive(0), [q, rows.length])
  useEffect(() => {
    if (!open) return
    setQ('')
    setActive(0)
    const id = requestAnimationFrame(() => inputRef.current?.focus())
    return () => cancelAnimationFrame(id)
  }, [open])

  if (!open) return null

  const go = (to: string) => {
    onClose()
    navigate(to)
  }

  const onKeyDown = (e: React.KeyboardEvent) => {
    if (e.key === 'ArrowDown') {
      e.preventDefault()
      setActive((a) => Math.min(a + 1, rows.length - 1))
    } else if (e.key === 'ArrowUp') {
      e.preventDefault()
      setActive((a) => Math.max(a - 1, 0))
    } else if (e.key === 'Enter') {
      e.preventDefault()
      if (rows[active]) go(rows[active].to)
      else if (trimmed) go(`/search?q=${encodeURIComponent(trimmed)}`)
    } else if (e.key === 'Escape') {
      e.preventDefault()
      onClose()
    }
  }

  return (
    <div className="fixed inset-0 z-[60]" role="dialog" aria-modal="true" aria-label="Search or jump to">
      <div
        className="absolute inset-0 animate-fade-in bg-black/40 backdrop-blur-sm"
        onClick={onClose}
        aria-hidden="true"
      />
      <div className="absolute left-1/2 top-[10vh] w-[92%] max-w-xl -translate-x-1/2 animate-rise overflow-hidden rounded-2xl border border-border bg-surface shadow-2xl">
        <div className="flex items-center gap-3 border-b border-border px-4">
          <Icon name="search" size={18} className="shrink-0 text-muted" />
          <input
            ref={inputRef}
            value={q}
            onChange={(e) => setQ(e.target.value)}
            onKeyDown={onKeyDown}
            placeholder="Search or jump to…"
            className="h-14 flex-1 bg-transparent text-base outline-none placeholder:text-muted"
            aria-label="Search or jump to"
          />
          <kbd className="hidden rounded border border-border px-1.5 py-0.5 text-[10px] font-medium text-muted sm:block">
            esc
          </kbd>
        </div>

        <div className="max-h-[58vh] overflow-y-auto p-2">
          {rows.length === 0 ? (
            <p className="px-3 py-10 text-center text-sm text-muted">
              {trimmed ? `Nothing matches “${q}”.` : 'Type to search the whole handbook.'}
            </p>
          ) : (
            rows.map((r, i) => (
              <button
                key={r.key}
                onMouseMove={() => setActive(i)}
                onClick={() => go(r.to)}
                className={`flex w-full items-center gap-3 rounded-xl px-3 py-2.5 text-left transition-colors ${
                  i === active ? 'bg-surface-2' : ''
                }`}
              >
                <span
                  className="grid h-8 w-8 shrink-0 place-items-center rounded-lg"
                  style={{ backgroundColor: `${r.accent}1a`, color: r.accent }}
                >
                  <Icon name={r.icon} size={16} />
                </span>
                <span className="min-w-0 flex-1">
                  <span className="block truncate text-sm font-medium text-fg">{r.title}</span>
                  {r.sub && <span className="block truncate text-xs text-muted">{r.sub}</span>}
                </span>
                <span className="shrink-0 text-[10px] uppercase tracking-wide text-muted">{r.tag}</span>
              </button>
            ))
          )}
        </div>

        {trimmed.length >= 1 && (
          <button
            onClick={() => go(`/search?q=${encodeURIComponent(trimmed)}`)}
            className="flex w-full items-center justify-between border-t border-border px-4 py-2.5 text-sm font-medium text-brand hover:bg-surface-2"
          >
            See all results for “{trimmed}”
            <Icon name="chevron-right" size={16} />
          </button>
        )}
      </div>
    </div>
  )
}
