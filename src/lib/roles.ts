import type { UserRole } from './database.types'

// The roles, in a stable display order. Identity = role; the admin flag is
// separate and grants author/approve power.
export const ALL_ROLES: UserRole[] = [
  'csr',
  'asr',
  'designer',
  'hr',
  'pm',
  'manager',
  'office_boy',
]

export const ROLE_LABELS: Record<UserRole, string> = {
  csr: 'CSR',
  asr: 'ASR',
  designer: 'Designer',
  hr: 'HR',
  pm: 'Project Manager',
  manager: 'Manager',
  office_boy: 'Office Boy',
}

export const ROLE_DESCRIPTIONS: Record<UserRole, string> = {
  csr: 'Customer Service Representative',
  asr: 'After-Sales Representative',
  designer: 'Design Team',
  hr: 'Human Resources',
  pm: 'Project Manager',
  manager: 'Team Manager',
  office_boy: 'Office Support',
}

export function roleLabel(role: UserRole): string {
  return ROLE_LABELS[role] ?? role
}

// True when a section is visible to every role (the default, unrestricted case).
export function isVisibleToEveryone(allowed: UserRole[]): boolean {
  return ALL_ROLES.every((r) => allowed.includes(r))
}
