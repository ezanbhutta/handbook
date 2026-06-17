// One harmonious accent colour per chapter, all cousins of the violet brand.
// Shared by the table of contents and the chapter openers, so a chapter keeps
// the same colour everywhere it appears. Indexed by the chapter's position in
// the navigation, so the run of colours is stable and repeats cleanly.
export const CHAPTER_ACCENTS = [
  '#7229FF', '#DB2777', '#2563EB', '#0D9488', '#4F46E5', '#059669',
  '#0891B2', '#D97706', '#DC2626', '#EA580C', '#9333EA', '#7C3AED',
]

export function chapterAccent(index: number): string {
  const len = CHAPTER_ACCENTS.length
  return CHAPTER_ACCENTS[((index % len) + len) % len]
}

// A two digit chapter label, e.g. 1 becomes "01".
export function chapterNumber(index: number): string {
  return String(index + 1).padStart(2, '0')
}
