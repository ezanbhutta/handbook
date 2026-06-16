import { Link } from 'react-router-dom'
import { Icon } from '@/components/Icon'

export function NotFound() {
  return (
    <div className="mx-auto flex max-w-md flex-col items-center gap-4 py-20 text-center">
      <span className="grid h-14 w-14 place-items-center rounded-2xl bg-surface-2 text-muted">
        <Icon name="help" size={28} />
      </span>
      <h1 className="text-2xl font-bold">Page not found</h1>
      <p className="text-muted">The page you’re looking for doesn’t exist or has moved.</p>
      <Link to="/" className="btn-primary">
        <Icon name="home" size={18} />
        Back to home
      </Link>
    </div>
  )
}
