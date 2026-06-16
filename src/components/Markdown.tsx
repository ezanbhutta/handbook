import ReactMarkdown, { type Components } from 'react-markdown'
import remarkGfm from 'remark-gfm'
import rehypeSanitize from 'rehype-sanitize'
import { useNavigate } from 'react-router-dom'
import { isValidElement, type ReactNode } from 'react'
import { Icon, type IconName } from './Icon'

// A blockquote that starts with a known label (e.g. "> **Rule:** …") becomes a
// visually-distinct callout. Grounded in NN/g layer-cake scanning research:
// rules and key points must stand out as their own block so readers catch them
// while skimming.
const CALLOUTS: Record<string, { icon: IconName; box: string; accent: string }> = {
  rule: { icon: 'shield', box: 'border-danger/40 bg-danger-soft/40', accent: 'text-danger' },
  important: { icon: 'alert', box: 'border-warning/40 bg-warning/10', accent: 'text-warning' },
  warning: { icon: 'alert', box: 'border-warning/40 bg-warning/10', accent: 'text-warning' },
  standard: { icon: 'check', box: 'border-brand/40 bg-brand-soft/50', accent: 'text-brand' },
  tip: { icon: 'sparkles', box: 'border-success/40 bg-success/10', accent: 'text-success' },
  'helping point': { icon: 'sparkles', box: 'border-success/40 bg-success/10', accent: 'text-success' },
  'key principle': { icon: 'badge', box: 'border-brand/40 bg-brand-soft/50', accent: 'text-brand' },
  note: { icon: 'help', box: 'border-border bg-surface-2', accent: 'text-muted' },
}

function nodeText(node: ReactNode): string {
  if (node == null || node === false) return ''
  if (typeof node === 'string' || typeof node === 'number') return String(node)
  if (Array.isArray(node)) return node.map(nodeText).join('')
  if (isValidElement(node)) return nodeText((node.props as { children?: ReactNode }).children)
  return ''
}

// Section bodies are author-written markdown. We always sanitize (rehype-sanitize)
// before rendering — even though only admins author, defense in depth is cheap.
// Element styling lives here instead of @tailwindcss/typography to keep deps lean.
function useComponents(): Components {
  const navigate = useNavigate()
  return {
    h1: ({ children }) => <h1 className="mt-8 mb-3 text-2xl font-bold tracking-tight">{children}</h1>,
    h2: ({ children }) => (
      <h2 className="mt-7 mb-2.5 text-xl font-bold tracking-tight border-b border-border pb-1.5">
        {children}
      </h2>
    ),
    h3: ({ children }) => <h3 className="mt-6 mb-2 text-lg font-semibold">{children}</h3>,
    p: ({ children }) => <p className="my-4 text-fg/90">{children}</p>,
    a: ({ href, children }) => {
      const internal = href?.startsWith('/')
      return (
        <a
          href={href}
          target={href?.startsWith('http') ? '_blank' : undefined}
          rel={href?.startsWith('http') ? 'noopener noreferrer' : undefined}
          onClick={
            internal
              ? (e) => {
                  e.preventDefault()
                  navigate(href!)
                }
              : undefined
          }
          className="text-brand font-medium underline underline-offset-2 hover:no-underline"
        >
          {children}
        </a>
      )
    },
    ul: ({ children }) => <ul className="my-3.5 ml-5 list-disc space-y-1.5 marker:text-muted">{children}</ul>,
    ol: ({ children }) => <ol className="my-3.5 ml-5 list-decimal space-y-1.5 marker:text-muted">{children}</ol>,
    li: ({ children }) => <li className="pl-1">{children}</li>,
    blockquote: ({ children }) => {
      const label = nodeText(children).trim().match(/^([A-Za-z][A-Za-z ]{1,18}?)\s*:/)?.[1]
      const callout = label ? CALLOUTS[label.toLowerCase()] : undefined
      if (callout) {
        return (
          <div className={`my-4 flex gap-3 rounded-xl border-l-4 px-4 py-3 ${callout.box}`}>
            <Icon name={callout.icon} size={18} className={`mt-0.5 shrink-0 ${callout.accent}`} />
            <div className="text-sm text-fg/90 [&>p]:my-0 [&>p+p]:mt-2">{children}</div>
          </div>
        )
      }
      return (
        <blockquote className="my-4 border-l-4 border-brand/40 bg-surface-2 rounded-r-xl px-4 py-2 text-fg/80">
          {children}
        </blockquote>
      )
    },
    code: ({ className, children }) => {
      const isBlock = /language-/.test(className ?? '')
      if (isBlock) return <code className={className}>{children}</code>
      return (
        <code className="rounded bg-surface-2 px-1.5 py-0.5 text-[0.85em] font-mono text-fg">
          {children}
        </code>
      )
    },
    pre: ({ children }) => (
      <pre className="my-4 overflow-x-auto rounded-xl bg-surface-2 p-4 text-sm font-mono leading-relaxed">
        {children}
      </pre>
    ),
    img: ({ src, alt }) => (
      <img
        src={typeof src === 'string' ? src : undefined}
        alt={alt ?? ''}
        loading="lazy"
        className="my-4 max-w-full rounded-xl border border-border"
      />
    ),
    hr: () => <hr className="my-6 border-border" />,
    table: ({ children }) => (
      <div className="my-4 overflow-x-auto rounded-xl border border-border">
        <table className="w-full text-sm">{children}</table>
      </div>
    ),
    thead: ({ children }) => <thead className="bg-surface-2">{children}</thead>,
    th: ({ children }) => <th className="px-3 py-2 text-left font-semibold border-b border-border">{children}</th>,
    td: ({ children }) => <td className="px-3 py-2 border-b border-border align-top">{children}</td>,
    strong: ({ children }) => <strong className="font-semibold text-fg">{children}</strong>,
  }
}

export function Markdown({ children }: { children: string }) {
  const components = useComponents()
  return (
    <div className="prose-body text-fg">
      <ReactMarkdown
        remarkPlugins={[remarkGfm]}
        rehypePlugins={[rehypeSanitize]}
        components={components}
      >
        {children}
      </ReactMarkdown>
    </div>
  )
}
