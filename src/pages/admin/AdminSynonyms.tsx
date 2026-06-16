import { useState } from 'react'
import { useMutation, useQueryClient } from '@tanstack/react-query'
import { useSynonyms, addSynonym, deleteSynonym } from '@/lib/admin'
import { Icon } from '@/components/Icon'
import { LoadingState, EmptyState, InlineError, Spinner } from '@/components/States'

export function AdminSynonyms() {
  const qc = useQueryClient()
  const { data: synonyms = [], isLoading } = useSynonyms()
  const [term, setTerm] = useState('')
  const [mapsTo, setMapsTo] = useState('')
  const [error, setError] = useState('')

  const invalidate = () => qc.invalidateQueries({ queryKey: ['admin', 'synonyms'] })

  const add = useMutation({
    mutationFn: () => addSynonym(term, mapsTo),
    onSuccess: () => {
      setTerm('')
      setMapsTo('')
      setError('')
      void invalidate()
    },
    onError: (e) =>
      setError(
        e instanceof Error && /duplicate|unique/i.test(e.message)
          ? 'That mapping already exists.'
          : e instanceof Error
            ? e.message
            : 'Could not add.',
      ),
  })

  const remove = useMutation({
    mutationFn: (id: string) => deleteSynonym(id),
    onSuccess: invalidate,
  })

  function submit(e: React.FormEvent) {
    e.preventDefault()
    if (!term.trim() || !mapsTo.trim()) {
      setError('Both fields are required.')
      return
    }
    add.mutate()
  }

  return (
    <div>
      <div className="mb-5 rounded-2xl border border-border bg-surface-2/40 p-4">
        <p className="text-sm text-muted">
          Synonyms expand searches so everyday words find the right section. A search for the{' '}
          <span className="font-medium text-fg">term</span> also matches content containing{' '}
          <span className="font-medium text-fg">maps&nbsp;to</span> — e.g. “chutti” → “leave”.
          Single words work best.
        </p>
      </div>

      <form onSubmit={submit} className="mb-6 flex flex-wrap items-end gap-2.5">
        <div className="flex-1 min-w-[140px]">
          <label className="label" htmlFor="syn-term">When someone types…</label>
          <input
            id="syn-term"
            className="input"
            value={term}
            onChange={(e) => setTerm(e.target.value)}
            placeholder="chutti"
          />
        </div>
        <span className="hidden pb-3 text-muted sm:block">
          <Icon name="arrow-left" size={18} className="rotate-180" />
        </span>
        <div className="flex-1 min-w-[140px]">
          <label className="label" htmlFor="syn-maps">…also find</label>
          <input
            id="syn-maps"
            className="input"
            value={mapsTo}
            onChange={(e) => setMapsTo(e.target.value)}
            placeholder="leave"
          />
        </div>
        <button type="submit" className="btn-primary" disabled={add.isPending}>
          {add.isPending ? <Spinner /> : <Icon name="plus" size={18} />}
          Add
        </button>
      </form>

      {error && (
        <div className="mb-4">
          <InlineError>{error}</InlineError>
        </div>
      )}

      {isLoading ? (
        <LoadingState />
      ) : synonyms.length === 0 ? (
        <EmptyState icon="search" title="No synonyms yet">
          Add your first mapping above to make search smarter.
        </EmptyState>
      ) : (
        <ul className="divide-y divide-border overflow-hidden rounded-2xl border border-border bg-surface">
          {synonyms.map((s) => (
            <li key={s.id} className="flex items-center gap-3 px-4 py-3">
              <span className="font-mono text-sm font-medium">{s.term}</span>
              <Icon name="chevron-right" size={16} className="text-muted" />
              <span className="flex-1 font-mono text-sm text-muted">{s.maps_to}</span>
              <button
                aria-label={`Delete ${s.term} → ${s.maps_to}`}
                onClick={() => remove.mutate(s.id)}
                className="grid h-9 w-9 place-items-center rounded-lg text-danger hover:bg-danger-soft/50"
              >
                <Icon name="trash" size={17} />
              </button>
            </li>
          ))}
        </ul>
      )}
    </div>
  )
}
