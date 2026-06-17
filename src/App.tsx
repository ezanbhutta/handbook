import { lazy } from 'react'
import { Routes, Route } from 'react-router-dom'
import { ProtectedRoute, AdminRoute } from '@/components/guards'
import { Layout } from '@/components/Layout'
import { Login } from '@/pages/Login'
import { Home } from '@/pages/Home'
import { WhatsNew } from '@/pages/WhatsNew'
import { SearchPage } from '@/pages/SearchPage'
import { NotFound } from '@/pages/NotFound'
import { NoAccess } from '@/pages/NoAccess'
import { TokenCapture } from '@/pages/TokenCapture'

// Code-split the markdown-heavy reader and the admin area so the core bundle
// that most staff load on a phone stays small.
const Chapter = lazy(() => import('@/pages/Chapter').then((m) => ({ default: m.Chapter })))
const Section = lazy(() => import('@/pages/Section').then((m) => ({ default: m.Section })))
const AdminLayout = lazy(() =>
  import('@/pages/admin/AdminLayout').then((m) => ({ default: m.AdminLayout })),
)
const AdminHome = lazy(() =>
  import('@/pages/admin/AdminHome').then((m) => ({ default: m.AdminHome })),
)
const AdminChapters = lazy(() =>
  import('@/pages/admin/AdminChapters').then((m) => ({ default: m.AdminChapters })),
)
const AdminSections = lazy(() =>
  import('@/pages/admin/AdminSections').then((m) => ({ default: m.AdminSections })),
)
const SectionEditor = lazy(() =>
  import('@/pages/admin/SectionEditor').then((m) => ({ default: m.SectionEditor })),
)
const AdminLinks = lazy(() =>
  import('@/pages/admin/AdminLinks').then((m) => ({ default: m.AdminLinks })),
)
const AdminSynonyms = lazy(() =>
  import('@/pages/admin/AdminSynonyms').then((m) => ({ default: m.AdminSynonyms })),
)
const AdminUsers = lazy(() =>
  import('@/pages/admin/AdminUsers').then((m) => ({ default: m.AdminUsers })),
)
const AdminInsights = lazy(() =>
  import('@/pages/admin/AdminInsights').then((m) => ({ default: m.AdminInsights })),
)

export default function App() {
  return (
    <Routes>
      <Route path="/login" element={<Login />} />
      <Route path="/welcome" element={<NoAccess />} />
      <Route path="/r/:token" element={<TokenCapture />} />

      <Route element={<ProtectedRoute />}>
        <Route element={<Layout />}>
          <Route path="/" element={<Home />} />
          <Route path="/chapter/:slug" element={<Chapter />} />
          <Route path="/section/:slug" element={<Section />} />
          <Route path="/whats-new" element={<WhatsNew />} />
          <Route path="/search" element={<SearchPage />} />

          <Route element={<AdminRoute />}>
            <Route path="/admin" element={<AdminLayout />}>
              <Route index element={<AdminHome />} />
              <Route path="chapters" element={<AdminChapters />} />
              <Route path="sections" element={<AdminSections />} />
              <Route path="sections/new" element={<SectionEditor />} />
              <Route path="sections/:id/edit" element={<SectionEditor />} />
              <Route path="links" element={<AdminLinks />} />
              <Route path="synonyms" element={<AdminSynonyms />} />
              <Route path="users" element={<AdminUsers />} />
              <Route path="insights" element={<AdminInsights />} />
            </Route>
          </Route>

          <Route path="*" element={<NotFound />} />
        </Route>
      </Route>
    </Routes>
  )
}
