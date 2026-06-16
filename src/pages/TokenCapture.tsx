import { useEffect, useState } from 'react'
import { useNavigate, useParams } from 'react-router-dom'
import { useAccess } from '@/lib/access'
import { LoadingState } from '@/components/States'
import { NoAccess } from './NoAccess'

// Handles /r/:token — validates and stores the link, then sends the reader in.
export function TokenCapture() {
  const { token } = useParams<{ token: string }>()
  const { applyToken } = useAccess()
  const navigate = useNavigate()
  const [invalid, setInvalid] = useState(false)

  useEffect(() => {
    let active = true
    if (!token) {
      setInvalid(true)
      return
    }
    applyToken(token).then((ok) => {
      if (!active) return
      if (ok) navigate('/', { replace: true })
      else setInvalid(true)
    })
    return () => {
      active = false
    }
  }, [token, applyToken, navigate])

  if (invalid) return <NoAccess invalid />
  return (
    <div className="grid min-h-dvh place-items-center">
      <LoadingState label="Opening your handbook…" />
    </div>
  )
}
