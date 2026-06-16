import { useEffect, useId, useRef, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { useAccess } from '@/lib/access'
import { useDebouncedValue, useClickOutside } from '@/lib/hooks'
import { useSearch, logSearch, logSearchClick, type SearchResult } from '@/lib/queries'
import { highlightToSafeHtml } from '@/lib/highlight'
import { Icon } from './Icon'
import { Spinner } from './States'

type Props = {
  size?: 'md' | 'lg'
  autoFocus?: boolean
  placeholder?: string
}

export function SearchBar({ size = 'md', autoFocus = false, placeholder }: Props) {
  const navigate = useNavigate()
  const { token } = useAccess()
  const [query, setQuery] = useState('')
  const [open, setOpen] = useState(false)
  const [active, setActive] = useState(-1)
  const debounced = useDebouncedValue(query, 250)
  const { data: results = [], isFetching } = useSearch(debounced)

  const listId = useId()
  const containerRef = useClickOutside<HTMLDivElement>(() => setOpen(false))
  const inputRef = useRef<HTMLInputElement>(null)
  const loggedRef = useRef<{ query: string; id: string | null }>({ query: '', id: null })

  const trimmed = debounced.trim()
  const showDropdown = open && trimmed.length >= 2

  // Silent search logging — one row per executed reader query (brief §5).
  // In admin mode token is null, so this is a no-op.
  useEffect(() => {
    if (trimmed.length < 2 || isFetching) return
    if (loggedRef.current.query === trimmed) return
    loggedRef.current = { query: trimmed, id: null }
    void logSearch(token, trimmed, results.length).then((id) => {
      if (loggedRef.current.query === trimmed) loggedRef.current.id = id
    })
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [trimmed, isFetching])

  useEffect(() => setActive(-1), [trimmed])

  function go(result: SearchResult) {
    if (loggedRef.current.query === trimmed && loggedRef.current.id) {
      void logSearchClick(token, loggedRef.current.id, result.section_id)
    }
    setOpen(false)
    setQuery('')
    navigate(`/section/${result.section_slug}`)
  }

  function submitAll() {
    if (trimmed.length < 1) return
    setOpen(false)
    navigate(`/search?q=${encodeURIComponent(trimmed)}`)
  }

  function onKeyDown(e: React.KeyboardEvent<HTMLInputElement>) {
    if (e.key === 'ArrowDown') {
      e.preventDefault()
      setOpen(true)
      setActive((i) => Math.min(i + 1, results.length - 1))
    } else if (e.key === 'ArrowUp') {
      e.preventDefault()
      setActive((i) => Math.max(i - 1, -1))
    } else if (e.key === 'Enter') {
      e.preventDefault()
      if (active >= 0 && results[active]) go(results[active])
      else submitAll()
    } else if (e.key === 'Escape') {
      setOpen(false)
      inputRef.current?.blur()
    }
  }

  const big = size === 'lg'

  return (
    <div ref={containerRef} className="relative w-full">
      <div className="relative">
        <Icon
          name="search"
          size={big ? 22 : 20}
          className="pointer-events-none absolute left-3.5 top-1/2 -translate-y-1/2 text-muted"
        />
        <input
          ref={inputRef}
          type="search"
          inputMode="search"
          autoFocus={autoFocus}
          value={query}
          placeholder={placeholder ?? 'Search the handbook…'}
          onChange={(e) => {
            setQuery(e.target.value)
            setOpen(true)
          }}
          onFocus={() => setOpen(true)}
          onKeyDown={onKeyDown}
          role="combobox"
          aria-expanded={showDropdown}
          aria-controls={listId}
          aria-autocomplete="list"
          className={`input pl-11 pr-10 ${
            big ? 'min-h-[52px] text-base rounded-2xl shadow-sm' : 'min-h-[44px]'
          }`}
        />
        <div className="absolute right-3 top-1/2 -translate-y-1/2 text-muted">
          {isFetching && trimmed.length >= 2 ? (
            <Spinner />
          ) : query ? (
            <button
              type="button"
              aria-label="Clear search"
              onClick={() => {
                setQuery('')
                inputRef.current?.focus()
              }}
              className="grid h-7 w-7 place-items-center rounded-full hover:bg-surface-2"
            >
              <Icon name="close" size={18} />
            </button>
          ) : null}
        </div>
      </div>

      {showDropdown && (
        <div
          id={listId}
          role="listbox"
          className="absolute z-30 mt-2 w-full overflow-hidden rounded-2xl border border-border bg-surface shadow-lg animate-fade-in"
        >
          {results.length === 0 ? (
            <div className="px-4 py-6 text-center text-sm text-muted">
              {isFetching ? 'Searching…' : `No results for “${trimmed}”.`}
            </div>
          ) : (
            <ul className="max-h-[70vh] overflow-y-auto py-1.5">
              {results.map((r, i) => (
                <li key={r.section_id} role="option" aria-selected={i === active}>
                  <button
                    type="button"
                    onMouseEnter={() => setActive(i)}
                    onClick={() => go(r)}
                    className={`flex w-full flex-col gap-0.5 px-4 py-2.5 text-left transition-colors ${
                      i === active ? 'bg-surface-2' : 'hover:bg-surface-2'
                    }`}
                  >
                    <span className="text-[11px] font-medium uppercase tracking-wide text-muted">
                      {r.chapter_title}
                    </span>
                    <span className="font-semibold text-fg">{r.section_title}</span>
                    {r.snippet ? (
                      <span
                        className="line-clamp-2 text-sm text-muted"
                        dangerouslySetInnerHTML={{ __html: highlightToSafeHtml(r.snippet) }}
                      />
                    ) : null}
                  </button>
                </li>
              ))}
            </ul>
          )}
          <button
            type="button"
            onClick={submitAll}
            className="flex w-full items-center justify-between border-t border-border px-4 py-2.5 text-sm font-medium text-brand hover:bg-surface-2"
          >
            See all results for “{trimmed}”
            <Icon name="chevron-right" size={16} />
          </button>
        </div>
      )}
    </div>
  )
}
