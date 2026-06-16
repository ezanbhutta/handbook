// ts_headline() returns the matched fragment with <b>…</b> around hits. We can't
// trust raw HTML, so escape everything, then re-introduce ONLY the highlight
// tags as <mark>. Result is safe to pass to dangerouslySetInnerHTML.
export function highlightToSafeHtml(snippet: string | null | undefined): string {
  if (!snippet) return ''
  const escaped = snippet
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
  return escaped
    .replace(/&lt;b&gt;/g, '<mark>')
    .replace(/&lt;\/b&gt;/g, '</mark>')
}
