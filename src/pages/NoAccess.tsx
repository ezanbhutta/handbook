import { Link } from 'react-router-dom'
import { Icon } from '@/components/Icon'
import { Logo } from '@/components/Logo'

export function NoAccess({ invalid = false }: { invalid?: boolean }) {
  return (
    <div className="grid min-h-dvh place-items-center bg-bg px-4 py-10">
      <div className="w-full max-w-md text-center">
        <Logo size={64} className="mx-auto drop-shadow-[0_10px_30px_rgba(114,41,255,0.35)]" />
        <h1 className="mt-5 text-2xl font-bold tracking-tight">
          Haseeb<span className="text-brand">MadeIt</span> Handbook
        </h1>
        <p className="mt-3 text-muted">
          {invalid
            ? 'This link is invalid or has been turned off. Ask your admin for your current team link.'
            : 'Open your team’s handbook link to read it — no login needed. Ask your admin if you don’t have it yet.'}
        </p>

        <div className="mt-7 rounded-2xl border border-border bg-surface p-4 text-left text-sm text-muted shadow-soft">
          <p className="flex items-start gap-2">
            <Icon name="link" size={18} className="mt-0.5 shrink-0 text-brand" />
            Each role (CSR, ASR, HR, and so on) has its own link. It opens straight to the parts of
            the handbook meant for that role.
          </p>
        </div>

        <Link to="/login" className="mt-7 inline-flex items-center gap-1.5 text-sm font-medium text-muted hover:text-fg">
          <Icon name="settings" size={16} />
          Admin? Sign in here
        </Link>
      </div>
    </div>
  )
}
