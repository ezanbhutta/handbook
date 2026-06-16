import { useTheme, type Theme } from '@/lib/theme'
import { Icon, type IconName } from './Icon'

const OPTIONS: { theme: Theme; icon: IconName; label: string }[] = [
  { theme: 'day', icon: 'sun', label: 'Day' },
  { theme: 'night', icon: 'moon', label: 'Night' },
  { theme: 'reading', icon: 'book', label: 'Reading' },
]

// Compact Day / Night / Reading selector for the header.
export function ThemeSwitcher() {
  const { theme, setTheme } = useTheme()
  return (
    <div
      role="radiogroup"
      aria-label="Reading mode"
      className="flex items-center rounded-full border border-border bg-surface p-0.5"
    >
      {OPTIONS.map((o) => {
        const active = theme === o.theme
        return (
          <button
            key={o.theme}
            type="button"
            role="radio"
            aria-checked={active}
            title={o.label}
            onClick={() => setTheme(o.theme)}
            className={`grid h-9 w-9 place-items-center rounded-full transition-colors ${
              active ? 'bg-brand text-brand-fg' : 'text-muted hover:text-fg'
            }`}
          >
            <Icon name={o.icon} size={17} />
            <span className="sr-only">{o.label}</span>
          </button>
        )
      })}
    </div>
  )
}
