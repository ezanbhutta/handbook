import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import { BrowserRouter } from 'react-router-dom'
import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import { AuthProvider } from '@/lib/auth'
import { AccessProvider } from '@/lib/access'
import { ThemeProvider } from '@/lib/theme'
import App from './App'
import './index.css'

const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      // Keep content fresh so edits show up without a manual refresh. When the
      // tab regains focus or the connection returns, React Query refetches in
      // the background: the current content stays on screen and is swapped when
      // the new data arrives, so there is no loading flash. (The auth provider
      // no longer flips to a loading state on focus, which was the real cause
      // of the old reload-on-tab-switch.)
      staleTime: 10_000,
      retry: 1,
      refetchOnWindowFocus: true,
      refetchOnReconnect: true,
    },
  },
})

createRoot(document.getElementById('root')!).render(
  <StrictMode>
    <QueryClientProvider client={queryClient}>
      <BrowserRouter>
        <ThemeProvider>
          <AuthProvider>
            <AccessProvider>
              <App />
            </AccessProvider>
          </AuthProvider>
        </ThemeProvider>
      </BrowserRouter>
    </QueryClientProvider>
  </StrictMode>,
)
