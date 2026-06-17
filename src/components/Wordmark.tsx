// The official HaseebMadeit wordmark lockup (the pulse mark plus the name).
// It is painted as a CSS mask filled with the active theme's brand colour, so
// it always reads cleanly on the day, night, and reading backgrounds from a
// single lightweight asset. No image swap, no flash, no extra requests.
const RATIO = 231.24 / 38.77 // the official artwork's aspect ratio

export function Wordmark({ width = 240, className }: { width?: number; className?: string }) {
  return (
    <span
      role="img"
      aria-label="HaseebMadeit"
      className={`inline-block bg-brand align-middle ${className ?? ''}`}
      style={{
        width,
        height: Math.round((width / RATIO) * 100) / 100,
        WebkitMaskImage: 'url(/brand/wordmark.svg)',
        maskImage: 'url(/brand/wordmark.svg)',
        WebkitMaskRepeat: 'no-repeat',
        maskRepeat: 'no-repeat',
        WebkitMaskPosition: 'center',
        maskPosition: 'center',
        WebkitMaskSize: 'contain',
        maskSize: 'contain',
      }}
    />
  )
}
