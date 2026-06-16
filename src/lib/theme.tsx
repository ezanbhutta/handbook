import {
  createContext,
  useContext,
  useEffect,
  useMemo,
  useState,
  type ReactNode,
} from 'react'

// Three reading environments (brief: "Day, Night, Reading mode"):
//  - day:     bright HaseebMadeIt violet on near-white.
//  - night:   deep indigo, easy on the eyes after dark.
//  - reading: warm cream + serif body, book-like for long reads.
export type Theme = 'day' | 'night' | 'reading'

const THEME_KEY = 'hb_theme'
export const THEMES: Theme[] = ['day', 'night', 'reading']

type ThemeState = {
  theme: Theme
  setTheme: (t: Theme) => void
  cycle: () => void
}

const ThemeContext = createContext<ThemeState | undefined>(undefined)

function initialTheme(): Theme {
  const saved = localStorage.getItem(THEME_KEY) as Theme | null
  if (saved && THEMES.includes(saved)) return saved
  // First visit: respect the OS at night.
  if (window.matchMedia?.('(prefers-color-scheme: dark)').matches) return 'night'
  return 'day'
}

export function ThemeProvider({ children }: { children: ReactNode }) {
  const [theme, setThemeState] = useState<Theme>(initialTheme)

  useEffect(() => {
    document.documentElement.dataset.theme = theme
    localStorage.setItem(THEME_KEY, theme)
  }, [theme])

  const value = useMemo<ThemeState>(
    () => ({
      theme,
      setTheme: setThemeState,
      cycle: () =>
        setThemeState((t) => THEMES[(THEMES.indexOf(t) + 1) % THEMES.length]),
    }),
    [theme],
  )

  return <ThemeContext.Provider value={value}>{children}</ThemeContext.Provider>
}

// eslint-disable-next-line react-refresh/only-export-components
export function useTheme(): ThemeState {
  const ctx = useContext(ThemeContext)
  if (!ctx) throw new Error('useTheme must be used within <ThemeProvider>')
  return ctx
}
