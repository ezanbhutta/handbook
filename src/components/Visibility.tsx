import type { UserRole } from '@/lib/database.types'
import { isVisibleToEveryone, roleLabel } from '@/lib/roles'
import { Icon } from './Icon'

// A compact summary of who can see a section/change. "Everyone" for the default
// open case; otherwise the explicit (restricted) role list with a lock.
export function VisibilityBadge({ roles }: { roles: UserRole[] }) {
  if (isVisibleToEveryone(roles)) {
    return (
      <span className="chip">
        <Icon name="users" size={14} />
        Everyone
      </span>
    )
  }
  return (
    <span className="chip-brand" title={`Restricted to: ${roles.map(roleLabel).join(', ')}`}>
      <Icon name="lock" size={14} />
      {roles.length === 1 ? roleLabel(roles[0]) : `${roles.length} roles`}
    </span>
  )
}
