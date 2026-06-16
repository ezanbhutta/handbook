import { useState } from 'react'
import { useMutation, useQueryClient } from '@tanstack/react-query'
import {
  useAdminChapters,
  createChapter,
  updateChapter,
  deleteChapter,
  slugify,
  type ChapterInput,
} from '@/lib/admin'
import type { Chapter } from '@/lib/queries'
import { Icon, chapterIcon, type IconName } from '@/components/Icon'
import { Modal } from '@/components/Modal'
import { LoadingState, InlineError, Spinner } from '@/components/States'

const ICON_CHOICES: IconName[] = [
  'home', 'users', 'calendar', 'badge', 'briefcase', 'check', 'wrench',
  'wallet', 'shield', 'alert', 'help', 'sparkles', 'book', 'list', 'settings',
]

export function AdminChapters() {
  const qc = useQueryClient()
  const { data: chapters = [], isLoading } = useAdminChapters()
  const [editing, setEditing] = useState<Chapter | 'new' | null>(null)

  const invalidate = () => {
    void qc.invalidateQueries({ queryKey: ['admin', 'chapters'] })
    void qc.invalidateQueries({ queryKey: ['navigation'] })
  }

  const reorder = useMutation({
    mutationFn: async ({ a, b }: { a: Chapter; b: Chapter }) => {
      await updateChapter(a.id, { order_index: b.order_index })
      await updateChapter(b.id, { order_index: a.order_index })
    },
    onSuccess: invalidate,
  })

  const remove = useMutation({
    mutationFn: (id: string) => deleteChapter(id),
    onSuccess: invalidate,
  })

  return (
    <div>
      <div className="mb-4 flex items-center justify-between">
        <p className="text-sm text-muted">
          {chapters.length} {chapters.length === 1 ? 'chapter' : 'chapters'}
        </p>
        <button className="btn-primary" onClick={() => setEditing('new')}>
          <Icon name="plus" size={18} /> New chapter
        </button>
      </div>

      {isLoading ? (
        <LoadingState />
      ) : (
        <ul className="space-y-2">
          {chapters.map((c, i) => (
            <li
              key={c.id}
              className="flex items-center gap-3 rounded-2xl border border-border bg-surface p-3"
            >
              <div className="flex flex-col">
                <button
                  aria-label="Move up"
                  disabled={i === 0 || reorder.isPending}
                  onClick={() => reorder.mutate({ a: c, b: chapters[i - 1] })}
                  className="grid h-6 w-7 place-items-center rounded text-muted hover:bg-surface-2 disabled:opacity-30"
                >
                  <Icon name="arrow-up" size={15} />
                </button>
                <button
                  aria-label="Move down"
                  disabled={i === chapters.length - 1 || reorder.isPending}
                  onClick={() => reorder.mutate({ a: c, b: chapters[i + 1] })}
                  className="grid h-6 w-7 place-items-center rounded text-muted hover:bg-surface-2 disabled:opacity-30"
                >
                  <Icon name="arrow-down" size={15} />
                </button>
              </div>

              <span className="grid h-10 w-10 shrink-0 place-items-center rounded-xl bg-surface-2 text-brand">
                <Icon name={chapterIcon(c.icon)} size={20} />
              </span>

              <div className="min-w-0 flex-1">
                <p className="truncate font-semibold">{c.title}</p>
                <p className="truncate text-xs text-muted">/{c.slug}</p>
              </div>

              <button
                aria-label={`Edit ${c.title}`}
                onClick={() => setEditing(c)}
                className="grid h-10 w-10 place-items-center rounded-xl text-muted hover:bg-surface-2"
              >
                <Icon name="edit" size={18} />
              </button>
              <button
                aria-label={`Delete ${c.title}`}
                onClick={() => {
                  if (
                    window.confirm(
                      `Delete "${c.title}"? This also deletes every section inside it. This cannot be undone.`,
                    )
                  ) {
                    remove.mutate(c.id)
                  }
                }}
                className="grid h-10 w-10 place-items-center rounded-xl text-danger hover:bg-danger-soft/50"
              >
                <Icon name="trash" size={18} />
              </button>
            </li>
          ))}
        </ul>
      )}

      {editing && (
        <ChapterForm
          chapter={editing === 'new' ? null : editing}
          nextOrder={chapters.reduce((m, c) => Math.max(m, c.order_index), 0) + 1}
          onClose={() => setEditing(null)}
          onSaved={() => {
            invalidate()
            setEditing(null)
          }}
        />
      )}
    </div>
  )
}

function ChapterForm({
  chapter,
  nextOrder,
  onClose,
  onSaved,
}: {
  chapter: Chapter | null
  nextOrder: number
  onClose: () => void
  onSaved: () => void
}) {
  const [title, setTitle] = useState(chapter?.title ?? '')
  const [slug, setSlug] = useState(chapter?.slug ?? '')
  const [slugTouched, setSlugTouched] = useState(Boolean(chapter))
  const [description, setDescription] = useState(chapter?.description ?? '')
  const [icon, setIcon] = useState<string>(chapter?.icon ?? 'book')
  const [error, setError] = useState('')

  const save = useMutation({
    mutationFn: async () => {
      const input: ChapterInput = {
        title: title.trim(),
        slug: slug.trim() || slugify(title),
        description: description.trim() || null,
        icon,
        order_index: chapter?.order_index ?? nextOrder,
      }
      if (!input.title) throw new Error('Title is required.')
      if (!input.slug) throw new Error('Slug is required.')
      if (chapter) await updateChapter(chapter.id, input)
      else await createChapter(input)
    },
    onSuccess: onSaved,
    onError: (e) => setError(e instanceof Error ? e.message : 'Could not save.'),
  })

  return (
    <Modal
      title={chapter ? 'Edit chapter' : 'New chapter'}
      onClose={onClose}
      footer={
        <>
          <button className="btn-secondary" onClick={onClose}>
            Cancel
          </button>
          <button className="btn-primary" disabled={save.isPending} onClick={() => save.mutate()}>
            {save.isPending ? <Spinner /> : null}
            {chapter ? 'Save changes' : 'Create chapter'}
          </button>
        </>
      }
    >
      <div className="space-y-4">
        <div>
          <label className="label" htmlFor="ch-title">Title</label>
          <input
            id="ch-title"
            className="input"
            value={title}
            onChange={(e) => {
              setTitle(e.target.value)
              if (!slugTouched) setSlug(slugify(e.target.value))
            }}
            placeholder="e.g. Attendance, Shifts & Leave"
          />
        </div>
        <div>
          <label className="label" htmlFor="ch-slug">Slug</label>
          <input
            id="ch-slug"
            className="input font-mono text-sm"
            value={slug}
            onChange={(e) => {
              setSlugTouched(true)
              setSlug(slugify(e.target.value))
            }}
            placeholder="attendance"
          />
          <p className="mt-1 hint">URL: /chapter/{slug || 'slug'}</p>
        </div>
        <div>
          <label className="label" htmlFor="ch-desc">Description</label>
          <textarea
            id="ch-desc"
            className="textarea !min-h-[80px]"
            value={description}
            onChange={(e) => setDescription(e.target.value)}
            placeholder="One line describing this chapter."
          />
        </div>
        <div>
          <label className="label">Icon</label>
          <div className="flex flex-wrap gap-2">
            {ICON_CHOICES.map((name) => (
              <button
                key={name}
                type="button"
                aria-label={name}
                aria-pressed={icon === name}
                onClick={() => setIcon(name)}
                className={`grid h-11 w-11 place-items-center rounded-xl border transition-colors ${
                  icon === name
                    ? 'border-brand bg-brand-soft text-brand'
                    : 'border-border text-muted hover:bg-surface-2'
                }`}
              >
                <Icon name={name} size={20} />
              </button>
            ))}
          </div>
        </div>
        {error && <InlineError>{error}</InlineError>}
      </div>
    </Modal>
  )
}
