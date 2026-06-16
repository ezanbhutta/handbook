import ReactMarkdown, { type Components } from 'react-markdown'
import remarkGfm from 'remark-gfm'
import rehypeSanitize from 'rehype-sanitize'

// Section bodies are author-written markdown. We always sanitize (rehype-sanitize)
// before rendering — even though only admins author, defense in depth is cheap.
// Element styling lives here instead of @tailwindcss/typography to keep deps lean.
const components: Components = {
  h1: ({ children }) => <h1 className="mt-8 mb-3 text-2xl font-bold tracking-tight">{children}</h1>,
  h2: ({ children }) => (
    <h2 className="mt-7 mb-2.5 text-xl font-bold tracking-tight border-b border-border pb-1.5">
      {children}
    </h2>
  ),
  h3: ({ children }) => <h3 className="mt-6 mb-2 text-lg font-semibold">{children}</h3>,
  p: ({ children }) => <p className="my-4 text-fg/90">{children}</p>,
  a: ({ href, children }) => (
    <a
      href={href}
      target={href?.startsWith('http') ? '_blank' : undefined}
      rel={href?.startsWith('http') ? 'noopener noreferrer' : undefined}
      className="text-brand font-medium underline underline-offset-2 hover:no-underline"
    >
      {children}
    </a>
  ),
  ul: ({ children }) => <ul className="my-3.5 ml-5 list-disc space-y-1.5 marker:text-muted">{children}</ul>,
  ol: ({ children }) => <ol className="my-3.5 ml-5 list-decimal space-y-1.5 marker:text-muted">{children}</ol>,
  li: ({ children }) => <li className="pl-1">{children}</li>,
  blockquote: ({ children }) => (
    <blockquote className="my-4 border-l-4 border-brand/40 bg-surface-2 rounded-r-xl px-4 py-2 text-fg/80">
      {children}
    </blockquote>
  ),
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

export function Markdown({ children }: { children: string }) {
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
