import { useEffect, useRef, useState } from 'react'
import { Link, useSearchParams } from 'react-router-dom'
import { useAccess } from '@/lib/access'
import { useDebouncedValue } from '@/lib/hooks'
import { useSearch, logSearch, logSearchClick } from '@/lib/queries'
import { highlightToSafeHtml } from '@/lib/highlight'
import { Icon } from '@/components/Icon'
import { LoadingState, EmptyState } from '@/components/States'

export function SearchPage() {
  const { token } = useAccess()
  const [params, setParams] = useSearchParams()
  const initial = params.get('q') ?? ''
  const [input, setInput] = useState(initial)
  const debounced = useDebouncedValue(input, 250)
  const trimmed = debounced.trim()
  const { data: results = [], isFetching, isLoading } = useSearch(debounced)
  const loggedRef = useRef<{ query: string; id: string | null }>({ query: '', id: null })

  // Keep the URL in sync so results are shareable/bookmarkable.
  useEffect(() => {
    setParams(trimmed ? { q: trimmed } : {}, { replace: true })
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [trimmed])

  // Silent logging — one row per executed reader query (no-op in admin mode).
  useEffect(() => {
    if (trimmed.length < 2 || isFetching) return
    if (loggedRef.current.query === trimmed) return
    loggedRef.current = { query: trimmed, id: null }
    void logSearch(token, trimmed, results.length).then((id) => {
      if (loggedRef.current.query === trimmed) loggedRef.current.id = id
    })
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [trimmed, isFetching])

  function onClickResult(sectionId: string) {
    if (loggedRef.current.query === trimmed && loggedRef.current.id) {
      void logSearchClick(token, loggedRef.current.id, sectionId)
    }
  }

  return (
    <div className="mx-auto max-w-3xl">
      <h1 className="mb-4 text-2xl font-bold tracking-tight">Search</h1>

      <div className="relative mb-6">
        <Icon
          name="search"
          size={20}
          className="pointer-events-none absolute left-3.5 top-1/2 -translate-y-1/2 text-muted"
        />
        <input
          type="search"
          autoFocus
          value={input}
          onChange={(e) => setInput(e.target.value)}
          placeholder="Search the handbook…"
          className="input pl-11 min-h-[52px] text-base rounded-2xl"
        />
      </div>

      {trimmed.length < 2 ? (
        <p className="text-muted">Type at least two characters to search.</p>
      ) : isLoading ? (
        <LoadingState label="Searching…" />
      ) : results.length === 0 ? (
        <EmptyState icon="search" title={`No results for “${trimmed}”`}>
          Try a different word — search understands typos and common terms.
        </EmptyState>
      ) : (
        <>
          <p className="mb-3 text-sm text-muted">
            {results.length} {results.length === 1 ? 'result' : 'results'} for “{trimmed}”
          </p>
          <ul className="space-y-2.5">
            {results.map((r) => (
              <li key={r.section_id}>
                <Link
                  to={`/section/${r.section_slug}`}
                  onClick={() => onClickResult(r.section_id)}
                  className="group block rounded-2xl border border-border bg-surface p-4 transition-colors hover:border-brand/40 hover:bg-surface-2"
                >
                  <span className="text-[11px] font-medium uppercase tracking-wide text-muted">
                    {r.chapter_title}
                  </span>
                  <h2 className="mt-0.5 font-semibold text-fg group-hover:text-brand">
                    {r.section_title}
                  </h2>
                  {r.snippet && (
                    <p
                      className="mt-1 text-sm text-muted"
                      dangerouslySetInnerHTML={{ __html: highlightToSafeHtml(r.snippet) }}
                    />
                  )}
                </Link>
              </li>
            ))}
          </ul>
        </>
      )}
    </div>
  )
}
