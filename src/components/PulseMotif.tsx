import type { CSSProperties } from 'react'

// The HaseebMadeit "pulse": a little row of rounded bars taken from the logo,
// used as a recurring brand graphic (cover accents, section dividers). It
// inherits currentColor, so it picks up whatever colour you set around it.
const BARS = [9, 16, 6, 22, 12, 19, 8, 14]
const BAR_W = 2.6
const GAP = 1.6
const BOX = 24

export function PulseMotif({
  height = 18,
  className,
  style,
}: {
  height?: number
  className?: string
  style?: CSSProperties
}) {
  const width = BARS.length * (BAR_W + GAP) - GAP
  return (
    <svg
      height={height}
      viewBox={`0 0 ${width} ${BOX}`}
      fill="currentColor"
      className={className}
      style={style}
      aria-hidden="true"
      focusable="false"
    >
      {BARS.map((h, i) => (
        <rect key={i} x={i * (BAR_W + GAP)} y={(BOX - h) / 2} width={BAR_W} height={h} rx={BAR_W / 2} />
      ))}
    </svg>
  )
}
