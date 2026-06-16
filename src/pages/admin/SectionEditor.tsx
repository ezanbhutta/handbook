import { useMemo, useRef, useState } from 'react'
import { useNavigate, useParams, Link } from 'react-router-dom'
import { useMutation, useQueryClient } from '@tanstack/react-query'
import { useAuth } from '@/lib/auth'
import { supabase } from '@/lib/supabase'
import {
  useAdminChapters,
  useAdminSection,
  useAdminSections,
  saveSection,
  slugify,
  type SectionInput,
} from '@/lib/admin'
import type { Section } from '@/lib/queries'
import type { UserRole } from '@/lib/database.types'
import { ALL_ROLES, ROLE_LABELS, ROLE_DESCRIPTIONS } from '@/lib/roles'
import { Markdown } from '@/components/Markdown'
import { Modal } from '@/components/Modal'
import { Icon } from '@/components/Icon'
import { LoadingState, InlineError, Spinner } from '@/components/States'

export function SectionEditor() {
  const { id } = useParams<{ id: string }>()
  const isEdit = Boolean(id)
  const { data: chapters = [], isLoading: chaptersLoading } = useAdminChapters()
  const { data: existing, isLoading: sectionLoading } = useAdminSection(id)

  if (chaptersLoading || (isEdit && sectionLoading)) return <LoadingState />

  if (chapters.length === 0) {
    return (
      <div className="rounded-2xl border border-dashed border-border p-8 text-center">
        <p className="font-semibold">You need a chapter first</p>
        <p className="mt-1 text-sm text-muted">Sections live inside chapters.</p>
        <Link to="/admin/chapters" className="btn-primary mt-4">
          <Icon name="plus" size={18} /> Create a chapter
        </Link>
      </div>
    )
  }

  if (isEdit && !existing) {
    return <p className="text-muted">Section not found.</p>
  }

  return <SectionForm chapters={chapters} existing={existing ?? null} />
}

function SectionForm({
  chapters,
  existing,
}: {
  chapters: { id: string; title: string }[]
  existing: Section | null
}) {
  const navigate = useNavigate()
  const qc = useQueryClient()
  const { profile } = useAuth()
  const { data: allSections = [] } = useAdminSections()
  const bodyRef = useRef<HTMLTextAreaElement>(null)

  const [title, setTitle] = useState(existing?.title ?? '')
  const [slug, setSlug] = useState(existing?.slug ?? '')
  const [slugTouched, setSlugTouched] = useState(Boolean(existing))
  const [chapterId, setChapterId] = useState(existing?.chapter_id ?? chapters[0].id)
  const [body, setBody] = useState(existing?.body ?? '')
  const [videoUrl, setVideoUrl] = useState(existing?.video_url ?? '')
  const [roles, setRoles] = useState<UserRole[]>(existing?.allowed_roles ?? [...ALL_ROLES])
  const [onboarding, setOnboarding] = useState(existing?.show_in_onboarding ?? false)
  const [summary, setSummary] = useState('')
  const [tab, setTab] = useState<'write' | 'preview'>('write')
  const [uploading, setUploading] = useState(false)
  const [error, setError] = useState('')
  const [confirmOpen, setConfirmOpen] = useState(false)

  const orderIndex = useMemo(() => {
    if (existing) return existing.order_index
    const inChapter = allSections.filter((s) => s.chapter_id === chapterId)
    return inChapter.reduce((m, s) => Math.max(m, s.order_index), 0) + 1
  }, [existing, allSections, chapterId])

  function toggleRole(role: UserRole) {
    setRoles((prev) =>
      prev.includes(role) ? prev.filter((r) => r !== role) : [...prev, role],
    )
  }

  function insertAtCursor(text: string) {
    const el = bodyRef.current
    if (!el) {
      setBody((b) => b + text)
      return
    }
    const start = el.selectionStart
    const end = el.selectionEnd
    setBody((b) => b.slice(0, start) + text + b.slice(end))
    requestAnimationFrame(() => {
      el.focus()
      el.selectionStart = el.selectionEnd = start + text.length
    })
  }

  async function onPickImage(e: React.ChangeEvent<HTMLInputElement>) {
    const file = e.target.files?.[0]
    e.target.value = ''
    if (!file) return
    setError('')
    setUploading(true)
    try {
      const ext = file.name.split('.').pop() ?? 'png'
      const path = `${existing?.id ?? 'new'}/${crypto.randomUUID()}.${ext}`
      const { error: upErr } = await supabase.storage.from('handbook').upload(path, file, {
        cacheControl: '3600',
        upsert: false,
      })
      if (upErr) throw upErr
      const { data } = supabase.storage.from('handbook').getPublicUrl(path)
      insertAtCursor(`\n![${file.name.replace(/\.[^.]+$/, '')}](${data.publicUrl})\n`)
    } catch (err) {
      setError(
        err instanceof Error
          ? `Image upload failed: ${err.message}. Is the "handbook" storage bucket set up?`
          : 'Image upload failed.',
      )
    } finally {
      setUploading(false)
    }
  }

  const publish = useMutation({
    mutationFn: async () => {
      const input: SectionInput = {
        id: existing?.id,
        chapter_id: chapterId,
        title: title.trim(),
        slug: (slug.trim() || slugify(title)).trim(),
        body,
        video_url: videoUrl.trim() || null,
        allowed_roles: roles,
        show_in_onboarding: onboarding,
        order_index: orderIndex,
        changeSummary: summary.trim(),
      }
      if (!input.title) throw new Error('Title is required.')
      if (!input.slug) throw new Error('Slug is required.')
      if (roles.length === 0) throw new Error('Pick at least one role that can see this section.')
      if (!input.changeSummary) throw new Error('A one-line change summary is required.')
      return saveSection(input, profile!.id)
    },
    onSuccess: (section) => {
      void qc.invalidateQueries({ queryKey: ['navigation'] })
      void qc.invalidateQueries({ queryKey: ['change_log'] })
      void qc.invalidateQueries({ queryKey: ['admin', 'sections'] })
      void qc.invalidateQueries({ queryKey: ['section', section.slug] })
      setConfirmOpen(false)
      navigate(`/section/${section.slug}`)
    },
    onError: (e) => {
      setError(e instanceof Error ? e.message : 'Could not publish.')
      setConfirmOpen(false)
    },
  })

  // Validate before opening the "check before publish" step.
  function startPublish() {
    setError('')
    if (!title.trim()) return setError('Title is required.')
    if (roles.length === 0) return setError('Pick at least one role that can see this section.')
    if (!summary.trim()) return setError('A one-line change summary is required.')
    setConfirmOpen(true)
  }

  const everyone = roles.length === ALL_ROLES.length

  return (
    <div className="mx-auto max-w-3xl">
      <div className="mb-5 flex items-center gap-2">
        <Link
          to="/admin/sections"
          className="grid h-9 w-9 place-items-center rounded-lg text-muted hover:bg-surface-2"
          aria-label="Back to sections"
        >
          <Icon name="arrow-left" size={20} />
        </Link>
        <h1 className="text-xl font-bold">{existing ? 'Edit section' : 'New section'}</h1>
      </div>

      <div className="space-y-5">
        {/* Title + chapter */}
        <div className="grid gap-4 sm:grid-cols-2">
          <div className="sm:col-span-2">
            <label className="label" htmlFor="se-title">Title</label>
            <input
              id="se-title"
              className="input"
              value={title}
              onChange={(e) => {
                setTitle(e.target.value)
                if (!slugTouched) setSlug(slugify(e.target.value))
              }}
              placeholder="e.g. Dress Code"
            />
          </div>
          <div>
            <label className="label" htmlFor="se-chapter">Chapter</label>
            <select
              id="se-chapter"
              className="input"
              value={chapterId}
              onChange={(e) => setChapterId(e.target.value)}
            >
              {chapters.map((c) => (
                <option key={c.id} value={c.id}>
                  {c.title}
                </option>
              ))}
            </select>
          </div>
          <div>
            <label className="label" htmlFor="se-slug">Slug</label>
            <input
              id="se-slug"
              className="input font-mono text-sm"
              value={slug}
              onChange={(e) => {
                setSlugTouched(true)
                setSlug(slugify(e.target.value))
              }}
              placeholder="dress-code"
            />
          </div>
        </div>

        {/* Body with write/preview */}
        <div>
          <div className="mb-1.5 flex items-center justify-between">
            <span className="label !mb-0">Content</span>
            <div className="flex items-center gap-1.5">
              <label className="btn-ghost !min-h-[36px] cursor-pointer !px-2.5 text-xs">
                {uploading ? <Spinner /> : <Icon name="image" size={16} />}
                Image
                <input type="file" accept="image/*" className="hidden" onChange={onPickImage} />
              </label>
              <div className="flex rounded-lg bg-surface-2 p-0.5 text-xs font-medium">
                <button
                  type="button"
                  onClick={() => setTab('write')}
                  className={`rounded-md px-2.5 py-1 ${tab === 'write' ? 'bg-surface shadow-sm' : 'text-muted'}`}
                >
                  Write
                </button>
                <button
                  type="button"
                  onClick={() => setTab('preview')}
                  className={`rounded-md px-2.5 py-1 ${tab === 'preview' ? 'bg-surface shadow-sm' : 'text-muted'}`}
                >
                  Preview
                </button>
              </div>
            </div>
          </div>
          {tab === 'write' ? (
            <textarea
              ref={bodyRef}
              className="textarea min-h-[320px] font-mono text-sm leading-relaxed"
              value={body}
              onChange={(e) => setBody(e.target.value)}
              placeholder="Write in Markdown. **bold**, lists, links, and images are supported."
            />
          ) : (
            <div className="min-h-[320px] rounded-xl border border-border bg-surface p-4">
              {body.trim() ? (
                <Markdown>{body}</Markdown>
              ) : (
                <p className="text-muted">Nothing to preview yet.</p>
              )}
            </div>
          )}
          <p className="mt-1 hint">Markdown supported. Images upload to Supabase Storage.</p>
        </div>

        {/* Video */}
        <div>
          <label className="label" htmlFor="se-video">Video URL (optional)</label>
          <input
            id="se-video"
            className="input"
            value={videoUrl}
            onChange={(e) => setVideoUrl(e.target.value)}
            placeholder="https://drive.google.com/file/d/…/view"
          />
          <p className="mt-1 hint">Paste a Google Drive link — it embeds automatically.</p>
        </div>

        {/* Visibility */}
        <fieldset>
          <legend className="label">
            Who can see this?{' '}
            <span className={everyone ? 'text-success' : 'text-brand'}>
              {everyone ? 'Everyone' : `${roles.length} of ${ALL_ROLES.length} roles`}
            </span>
          </legend>
          <p className="mb-2 hint">Defaults to everyone. Uncheck roles to restrict a sensitive section.</p>
          <div className="grid gap-2 sm:grid-cols-2">
            {ALL_ROLES.map((role) => {
              const checked = roles.includes(role)
              return (
                <label
                  key={role}
                  className={`flex cursor-pointer items-center gap-3 rounded-xl border p-3 transition-colors ${
                    checked ? 'border-brand/50 bg-brand-soft/40' : 'border-border hover:bg-surface-2'
                  }`}
                >
                  <input
                    type="checkbox"
                    className="h-5 w-5 accent-brand"
                    checked={checked}
                    onChange={() => toggleRole(role)}
                  />
                  <span className="min-w-0">
                    <span className="block font-medium">{ROLE_LABELS[role]}</span>
                    <span className="block truncate text-xs text-muted">
                      {ROLE_DESCRIPTIONS[role]}
                    </span>
                  </span>
                </label>
              )
            })}
          </div>
          <div className="mt-2 flex gap-2">
            <button type="button" className="text-xs font-medium text-brand hover:underline" onClick={() => setRoles([...ALL_ROLES])}>
              Select all
            </button>
            <button type="button" className="text-xs font-medium text-muted hover:underline" onClick={() => setRoles([])}>
              Clear
            </button>
          </div>
        </fieldset>

        {/* Onboarding */}
        <label className="flex cursor-pointer items-center justify-between rounded-xl border border-border p-3">
          <span className="flex items-center gap-2.5">
            <Icon name="badge" size={20} className="text-brand" />
            <span>
              <span className="block font-medium">Show in “Start Here”</span>
              <span className="block text-xs text-muted">Surface this to new hires on the home screen.</span>
            </span>
          </span>
          <input
            type="checkbox"
            className="h-5 w-5 accent-brand"
            checked={onboarding}
            onChange={(e) => setOnboarding(e.target.checked)}
          />
        </label>

        {/* Change summary (required) */}
        <div>
          <label className="label" htmlFor="se-summary">
            Change summary <span className="text-danger">*</span>
          </label>
          <input
            id="se-summary"
            className="input"
            value={summary}
            onChange={(e) => setSummary(e.target.value)}
            placeholder="What changed, in one line (shown in What's New)."
          />
        </div>

        {error && <InlineError>{error}</InlineError>}

        <div className="sticky bottom-0 -mx-3 flex items-center justify-end gap-2 border-t border-border bg-surface/95 px-3 py-3 backdrop-blur">
          <Link to="/admin/sections" className="btn-secondary">
            Cancel
          </Link>
          <button type="button" className="btn-primary" onClick={startPublish}>
            <Icon name="check" size={18} />
            Check before publish
          </button>
        </div>
      </div>

      {confirmOpen && (
        <Modal
          title="Check before publish"
          onClose={() => setConfirmOpen(false)}
          footer={
            <>
              <button className="btn-secondary" onClick={() => setConfirmOpen(false)}>
                Keep editing
              </button>
              <button className="btn-primary" disabled={publish.isPending} onClick={() => publish.mutate()}>
                {publish.isPending ? <Spinner /> : <Icon name="check" size={18} />}
                Publish
              </button>
            </>
          }
        >
          <div className="space-y-4">
            {/* Phase 2 seam: the conflict check will render its findings here. */}
            <div className="flex items-start gap-3 rounded-xl border border-border bg-surface-2/60 p-3">
              <Icon name="shield" size={20} className="mt-0.5 shrink-0 text-muted" />
              <div className="text-sm">
                <p className="font-medium">Conflict check</p>
                <p className="text-muted">
                  Automated conflict checking arrives in Phase 2. For now, review the summary below
                  and publish when you’re ready — nothing is blocked.
                </p>
              </div>
            </div>

            <dl className="space-y-2 text-sm">
              <div className="flex justify-between gap-3">
                <dt className="text-muted">Section</dt>
                <dd className="text-right font-medium">{title || '—'}</dd>
              </div>
              <div className="flex justify-between gap-3">
                <dt className="text-muted">Visibility</dt>
                <dd className="text-right font-medium">
                  {everyone ? 'Everyone' : roles.map((r) => ROLE_LABELS[r]).join(', ') || 'No one'}
                </dd>
              </div>
              <div className="flex justify-between gap-3">
                <dt className="text-muted">Action</dt>
                <dd className="text-right font-medium">{existing ? 'Update' : 'Create'}</dd>
              </div>
            </dl>

            <div>
              <p className="text-xs font-medium uppercase tracking-wide text-muted">What’s New entry</p>
              <p className="mt-1 rounded-lg bg-surface-2 px-3 py-2 text-sm">{summary}</p>
            </div>
          </div>
        </Modal>
      )}
    </div>
  )
}
