import type { ReactNode } from 'react'
import { Icon, type IconName } from './Icon'
import { PulseMotif } from './PulseMotif'

export function Spinner({ className }: { className?: string }) {
  return (
    <svg
      className={`animate-spin ${className ?? ''}`}
      width="20"
      height="20"
      viewBox="0 0 24 24"
      fill="none"
      aria-hidden="true"
    >
      <circle cx="12" cy="12" r="9" stroke="currentColor" strokeWidth="3" className="opacity-20" />
      <path
        d="M21 12a9 9 0 0 0-9-9"
        stroke="currentColor"
        strokeWidth="3"
        strokeLinecap="round"
      />
    </svg>
  )
}

export function LoadingState({ label = 'Loading…' }: { label?: string }) {
  return (
    <div className="flex flex-col items-center justify-center gap-3 py-16 text-muted" role="status">
      <PulseMotif height={26} animate className="text-brand" />
      <span className="text-sm">{label}</span>
    </div>
  )
}

export function EmptyState({
  icon = 'book',
  title,
  children,
}: {
  icon?: IconName
  title: string
  children?: ReactNode
}) {
  return (
    <div className="flex flex-col items-center justify-center gap-3 rounded-2xl border border-dashed border-border py-14 px-6 text-center">
      <div className="grid h-12 w-12 place-items-center rounded-full bg-surface-2 text-muted">
        <Icon name={icon} size={22} />
      </div>
      <p className="font-semibold text-fg">{title}</p>
      {children ? <p className="max-w-sm text-sm text-muted">{children}</p> : null}
    </div>
  )
}

export function ErrorState({ error }: { error: unknown }) {
  const message = error instanceof Error ? error.message : 'Something went wrong.'
  return (
    <div className="flex flex-col items-center gap-2 rounded-2xl border border-danger/30 bg-danger-soft/40 py-12 px-6 text-center">
      <Icon name="alert" className="text-danger" />
      <p className="font-semibold text-fg">Couldn’t load this</p>
      <p className="max-w-md text-sm text-muted">{message}</p>
    </div>
  )
}

export function InlineError({ children }: { children: ReactNode }) {
  if (!children) return null
  return (
    <p className="flex items-start gap-1.5 text-sm text-danger" role="alert">
      <Icon name="alert" size={16} className="mt-0.5 shrink-0" />
      <span>{children}</span>
    </p>
  )
}
