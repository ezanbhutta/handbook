import ReactMarkdown, { type Components } from 'react-markdown'
import remarkGfm from 'remark-gfm'
import rehypeSanitize from 'rehype-sanitize'
import { useNavigate } from 'react-router-dom'
import { isValidElement, type ReactNode } from 'react'
import { Icon, type IconName } from './Icon'
import { widgetFor } from './widgets'

// A blockquote that starts with a known label (e.g. "> **Rule:** …") becomes a
// visually-distinct callout. Grounded in NN/g layer-cake scanning research:
// rules and key points must stand out as their own block so readers catch them
// while skimming.
const CALLOUTS: Record<string, { icon: IconName; box: string; accent: string }> = {
  rule: { icon: 'shield', box: 'border-danger/25 bg-danger-soft/30', accent: 'text-danger' },
  important: { icon: 'alert', box: 'border-warning/25 bg-warning/[0.06]', accent: 'text-warning' },
  warning: { icon: 'alert', box: 'border-warning/25 bg-warning/[0.06]', accent: 'text-warning' },
  standard: { icon: 'check', box: 'border-brand/25 bg-brand-soft/40', accent: 'text-brand' },
  tip: { icon: 'sparkles', box: 'border-success/25 bg-success/[0.06]', accent: 'text-success' },
  'helping point': { icon: 'sparkles', box: 'border-success/25 bg-success/[0.06]', accent: 'text-success' },
  'key principle': { icon: 'badge', box: 'border-brand/25 bg-brand-soft/40', accent: 'text-brand' },
  note: { icon: 'help', box: 'border-border bg-surface-2/60', accent: 'text-muted' },
}

function nodeText(node: ReactNode): string {
  if (node == null || node === false) return ''
  if (typeof node === 'string' || typeof node === 'number') return String(node)
  if (Array.isArray(node)) return node.map(nodeText).join('')
  if (isValidElement(node)) return nodeText((node.props as { children?: ReactNode }).children)
  return ''
}

// Pull the header labels and row text out of a markdown table's hast node, so
// the same table can render as a real table on desktop and as tidy cards on a
// phone, where wide tables otherwise force a horizontal scroll.
type HastNode = { type?: string; tagName?: string; value?: string; children?: HastNode[] }

function cellText(node: HastNode | undefined): string {
  if (!node) return ''
  if (node.type === 'text') return node.value ?? ''
  if (node.children) return node.children.map(cellText).join('')
  return ''
}

function parseTable(node: HastNode | undefined): { headers: string[]; rows: string[][] } {
  const kids = node?.children ?? []
  const thead = kids.find((c) => c.tagName === 'thead')
  const tbody = kids.find((c) => c.tagName === 'tbody')
  const headRow = (thead?.children ?? []).find((r) => r.tagName === 'tr')
  const headers = (headRow?.children ?? []).filter((c) => c.tagName === 'th').map(cellText)
  const rows = (tbody?.children ?? [])
    .filter((r) => r.tagName === 'tr')
    .map((r) => (r.children ?? []).filter((c) => c.tagName === 'td').map(cellText))
  return { headers, rows }
}

// Section bodies are author-written markdown. We always sanitize (rehype-sanitize)
// before rendering — even though only admins author, defense in depth is cheap.
// Element styling lives here instead of @tailwindcss/typography to keep deps lean.
function useComponents(): Components {
  const navigate = useNavigate()
  return {
    h1: ({ children }) => <h1 className="mt-8 mb-3 text-2xl font-bold tracking-tight">{children}</h1>,
    h2: ({ children }) => (
      <h2 className="mt-10 mb-3 text-2xl font-medium tracking-tight">{children}</h2>
    ),
    h3: ({ children }) => (
      <h3 className="mt-8 mb-2 text-lg font-semibold tracking-tight">{children}</h3>
    ),
    p: ({ children }) => <p className="my-5 text-justify text-fg/90 [hyphens:none]">{children}</p>,
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
          <div
            className={`my-5 flex items-start gap-3 rounded-2xl border border-l-[3px] px-4 py-3.5 ${callout.box}`}
          >
            <span
              className={`mt-0.5 grid h-7 w-7 shrink-0 place-items-center rounded-lg bg-surface/70 ${callout.accent}`}
            >
              <Icon name={callout.icon} size={16} />
            </span>
            <div className="text-sm leading-relaxed text-fg/90 [&>p]:my-0 [&>p+p]:mt-2">{children}</div>
          </div>
        )
      }
      return (
        <blockquote className="my-5 border-l-2 border-border bg-surface-2/50 rounded-r-xl px-4 py-2 text-fg/80">
          {children}
        </blockquote>
      )
    },
    code: ({ className, children }) => {
      const widget = widgetFor(className)
      if (widget) return widget(nodeText(children))
      const isBlock = /language-/.test(className ?? '')
      if (isBlock) return <code className={className}>{children}</code>
      return (
        <code className="rounded bg-surface-2 px-1.5 py-0.5 text-[0.85em] font-mono text-fg">
          {children}
        </code>
      )
    },
    pre: ({ children }) => {
      // Widget code blocks render as full-width graphics, not a code box.
      const cls = isValidElement(children)
        ? (children.props as { className?: string }).className
        : undefined
      if (widgetFor(cls)) return <>{children}</>
      return (
        <pre className="my-4 overflow-x-auto rounded-xl bg-surface-2 p-4 text-sm font-mono leading-relaxed">
          {children}
        </pre>
      )
    },
    img: ({ src, alt }) => (
      <img
        src={typeof src === 'string' ? src : undefined}
        alt={alt ?? ''}
        loading="lazy"
        className="my-4 max-w-full rounded-xl border border-border"
      />
    ),
    hr: () => <hr className="my-6 border-border" />,
    table: ({ node, children }) => {
      const { headers, rows } = parseTable(node as unknown as HastNode)
      return (
        <div className="my-5">
          {/* Desktop: the real table, with full formatting */}
          <div className="hidden overflow-x-auto rounded-2xl border border-border sm:block">
            <table className="w-full text-sm">{children}</table>
          </div>
          {/* Phone: each row becomes a tidy card, its first cell the heading */}
          {rows.length > 0 && (
            <div className="space-y-3 sm:hidden">
              {rows.map((r, ri) => (
                <div key={ri} className="overflow-hidden rounded-2xl border border-border bg-surface shadow-soft">
                  <div className="bg-surface-2 px-3.5 py-2 font-serif font-medium text-fg">{r[0]}</div>
                  <dl className="divide-y divide-border">
                    {r.slice(1).map((c, ci) => (
                      <div key={ci} className="flex justify-between gap-4 px-3.5 py-2 text-sm">
                        <dt className="shrink-0 text-muted">{headers[ci + 1]}</dt>
                        <dd className="text-right font-medium text-fg">{c}</dd>
                      </div>
                    ))}
                  </dl>
                </div>
              ))}
            </div>
          )}
        </div>
      )
    },
    thead: ({ children }) => <thead className="bg-surface-2">{children}</thead>,
    th: ({ children }) => <th className="px-3 py-2 text-left font-semibold border-b border-border">{children}</th>,
    td: ({ children }) => <td className="px-3 py-2 border-b border-border align-top">{children}</td>,
    strong: ({ children }) => <strong className="font-semibold text-fg">{children}</strong>,
  }
}

export function Markdown({ children, lead = false }: { children: string; lead?: boolean }) {
  const components = useComponents()
  return (
    <div className={`prose-body text-fg ${lead ? 'prose-lead' : ''}`}>
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
