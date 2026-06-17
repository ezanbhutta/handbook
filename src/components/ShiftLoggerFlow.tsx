import type { ReactNode } from 'react'

// Hand-drawn vector mockups of the CSR Shift Logger, one per step. These are
// illustrations (SVG, so they never pixelate), not screenshots. The screens use
// a fixed light palette so they read like product art on any theme, while the
// surrounding cards and captions follow the handbook's theme tokens.
const PAL = {
  ink: '#160A33',
  mut: '#6B6485',
  line: '#E8E5F3',
  soft: '#F1EBFF',
  softLine: '#E2D6FF',
  bar: '#D9CEF6',
  violet: '#7229FF',
  glow: '#9F66FF',
  mint: '#10B981',
  amber: '#F59E0B',
  sky: '#0EA5E9',
  coral: '#EF4444',
}

const FX = 22
const FW = 256
const FONT = 'Inter, ui-sans-serif, system-ui, sans-serif'

function Frame({ title, accent = PAL.violet, children }: { title: string; accent?: string; children: ReactNode }) {
  return (
    <svg viewBox="0 0 300 360" className="h-auto w-full" role="img" aria-label={title}>
      <rect x="2" y="2" width="296" height="356" rx="24" fill="#ffffff" stroke={PAL.line} strokeWidth="2" />
      <circle cx="30" cy="32" r="7" fill={accent} />
      <text x="46" y="37" fontFamily={FONT} fontSize="14" fontWeight="700" fill={PAL.ink}>
        {title}
      </text>
      <line x1="20" y1="54" x2="280" y2="54" stroke={PAL.line} strokeWidth="1.5" />
      {children}
    </svg>
  )
}

function Label({ y, t }: { y: number; t: string }) {
  return (
    <text x="24" y={y} fontFamily={FONT} fontSize="10" fontWeight="700" letterSpacing="0.09em" fill={PAL.mut}>
      {t}
    </text>
  )
}

function Field({ y, t, chevron }: { y: number; t: string; chevron?: boolean }) {
  return (
    <g>
      <rect x={FX} y={y} width={FW} height="34" rx="10" fill="#ffffff" stroke={PAL.line} strokeWidth="1.5" />
      <text x="36" y={y + 22} fontFamily={FONT} fontSize="13" fill={PAL.mut}>
        {t}
      </text>
      {chevron && (
        <path
          d={`M${FX + FW - 24} ${y + 14} l6 6 l6 -6`}
          stroke={PAL.mut}
          strokeWidth="2"
          fill="none"
          strokeLinecap="round"
          strokeLinejoin="round"
        />
      )}
    </g>
  )
}

function Btn({ y, t, color = PAL.violet, x = FX, w = FW }: { y: number; t: string; color?: string; x?: number; w?: number }) {
  return (
    <g>
      <rect x={x} y={y} width={w} height="42" rx="12" fill={color} />
      <text x={x + w / 2} y={y + 26} textAnchor="middle" fontFamily={FONT} fontSize="14" fontWeight="700" fill="#ffffff">
        {t}
      </text>
    </g>
  )
}

function Tick({ x, y }: { x: number; y: number }) {
  return (
    <g>
      <circle cx={x} cy={y} r="11" fill={PAL.mint} />
      <path d={`M${x - 5} ${y} l3.5 3.5 l6.5 -7`} stroke="#fff" strokeWidth="2.2" fill="none" strokeLinecap="round" strokeLinejoin="round" />
    </g>
  )
}

function Stat({ x, y, n, label, color = PAL.violet }: { x: number; y: number; n: string; label: string; color?: string }) {
  return (
    <g>
      <rect x={x} y={y} width="122" height="74" rx="14" fill={PAL.soft} stroke={PAL.softLine} strokeWidth="1.5" />
      <text x={x + 16} y={y + 40} fontFamily={FONT} fontSize="30" fontWeight="800" fill={color}>
        {n}
      </text>
      <text x={x + 16} y={y + 60} fontFamily={FONT} fontSize="12" fill={PAL.mut}>
        {label}
      </text>
    </g>
  )
}

function Chip({ x, y, t, w = 122 }: { x: number; y: number; t: string; w?: number }) {
  return (
    <g>
      <rect x={x} y={y} width={w} height="30" rx="9" fill="#ffffff" stroke={PAL.softLine} strokeWidth="1.5" />
      <text x={x + 12} y={y + 20} fontFamily={FONT} fontSize="12" fontWeight="600" fill={PAL.violet}>
        + {t}
      </text>
    </g>
  )
}

/* ── 1 · Start the shift ────────────────────────────────────────────── */
function StartArt() {
  return (
    <Frame title="Start my report">
      <Label y={80} t="NAME" />
      <Field y={88} t="Pick your name" chevron />
      <Label y={146} t="SHIFT" />
      <rect x={FX} y={152} width={FW} height="36" rx="11" fill={PAL.soft} />
      <rect x={FX + 4} y={156} width="80" height="28" rx="8" fill={PAL.violet} />
      <text x={FX + 44} y={174} textAnchor="middle" fontFamily={FONT} fontSize="12" fontWeight="700" fill="#fff">Morning</text>
      <text x={FX + 130} y={174} textAnchor="middle" fontFamily={FONT} fontSize="12" fill={PAL.mut}>Evening</text>
      <text x={FX + 212} y={174} textAnchor="middle" fontFamily={FONT} fontSize="12" fill={PAL.mut}>Night</text>
      <Label y={214} t="PROFILE" />
      <Field y={222} t="Pick the profile" chevron />
      <text x="24" y={280} fontFamily={FONT} fontSize="11" fill={PAL.mut}>Date and check in stamped for you</text>
      <Btn y={298} t="Start my report" />
    </Frame>
  )
}

/* ── 2 · Handover note ──────────────────────────────────────────────── */
function HandoverArt() {
  return (
    <Frame title="Note from last shift" accent={PAL.amber}>
      <rect x="22" y="80" width="256" height="150" rx="16" fill={PAL.soft} stroke={PAL.softLine} strokeWidth="1.5" />
      <circle cx="48" cy="110" r="13" fill={PAL.amber} />
      <path d="M48 104 v7 M48 116 v0.5" stroke="#fff" strokeWidth="2.4" strokeLinecap="round" />
      <rect x="70" y="104" width="120" height="11" rx="5.5" fill={PAL.glow} />
      <rect x="40" y="140" width="220" height="9" rx="4.5" fill={PAL.bar} />
      <rect x="40" y="158" width="206" height="9" rx="4.5" fill={PAL.bar} />
      <rect x="40" y="176" width="150" height="9" rx="4.5" fill={PAL.bar} />
      <rect x="40" y="200" width="150" height="10" rx="5" fill={PAL.glow} opacity="0.45" />
      <Btn y={258} t="Noted" x={90} w={120} />
    </Frame>
  )
}

/* ── 3 · Log each action ────────────────────────────────────────────── */
function LogArt() {
  return (
    <Frame title="Shift Home">
      {/* live KPI strip */}
      <g>
        <rect x="22" y="66" width="80" height="38" rx="10" fill={PAL.soft} />
        <text x="34" y="90" fontFamily={FONT} fontSize="16" fontWeight="800" fill={PAL.violet}>3</text>
        <text x="52" y="90" fontFamily={FONT} fontSize="10" fill={PAL.mut}>Inq.</text>
        <rect x="110" y="66" width="80" height="38" rx="10" fill={PAL.soft} />
        <text x="122" y="90" fontFamily={FONT} fontSize="16" fontWeight="800" fill={PAL.violet}>2</text>
        <text x="140" y="90" fontFamily={FONT} fontSize="10" fill={PAL.mut}>F/U</text>
        <rect x="198" y="66" width="80" height="38" rx="10" fill={PAL.soft} />
        <text x="210" y="90" fontFamily={FONT} fontSize="16" fontWeight="800" fill={PAL.violet}>1</text>
        <text x="228" y="90" fontFamily={FONT} fontSize="10" fill={PAL.mut}>Upsell</text>
      </g>
      {/* action buttons */}
      <Chip x={22} y={118} t="New inquiry" />
      <Chip x={156} y={118} t="New order" />
      <Chip x={22} y={154} t="Revision" />
      <Chip x={156} y={154} t="Delivered" />
      {/* the pop-up form */}
      <rect x="20" y="198" width="260" height="146" rx="16" fill="#fff" stroke={PAL.violet} strokeWidth="2" />
      <text x="34" y="224" fontFamily={FONT} fontSize="13" fontWeight="700" fill={PAL.ink}>New inquiry</text>
      <rect x="34" y="236" width="232" height="30" rx="9" fill="#fff" stroke={PAL.line} strokeWidth="1.5" />
      <text x="44" y="256" fontFamily={FONT} fontSize="12" fill={PAL.mut}>Username</text>
      <rect x="34" y="274" width="232" height="26" rx="8" fill={PAL.soft} />
      <text x="44" y="291" fontFamily={FONT} fontSize="11" fill={PAL.mut}>What they want</text>
      <Btn y={310} t="Save" x={34} w={232} />
    </Frame>
  )
}

/* ── 4 · Live summary ───────────────────────────────────────────────── */
function SummaryArt() {
  return (
    <Frame title="Your shift, live">
      <Stat x={22} y={72} n="3" label="Inquiries" />
      <Stat x={156} y={72} n="2" label="Follow ups" color={PAL.amber} />
      <Stat x={22} y={158} n="1" label="Upsells" color={PAL.mint} />
      <Stat x={156} y={158} n="1" label="Offers" color={PAL.sky} />
      <rect x="22" y="252" width="256" height="40" rx="12" fill={PAL.soft} />
      <path d="M40 280 l14 -12 l12 8 l16 -18 l14 10" stroke={PAL.violet} strokeWidth="2.5" fill="none" strokeLinecap="round" strokeLinejoin="round" />
      <text x="120" y="277" fontFamily={FONT} fontSize="12" fontWeight="600" fill={PAL.ink}>Counts add up on their own</text>
    </Frame>
  )
}

/* ── 5 · Wrap-up checklist ──────────────────────────────────────────── */
function ChecklistArt() {
  const items = ['CRM updated', 'ClickUp cleared', 'Portfolio updated', 'Briefs created', 'Analytics checked', 'Orders checked one by one']
  return (
    <Frame title="Before you check out" accent={PAL.mint}>
      {items.map((t, i) => {
        const y = 84 + i * 42
        return (
          <g key={i}>
            <rect x="22" y={y - 17} width="256" height="34" rx="10" fill={i % 2 ? '#fff' : PAL.soft} />
            <Tick x={42} y={y} />
            <text x="64" y={y + 5} fontFamily={FONT} fontSize="13" fill={PAL.ink}>{t}</text>
          </g>
        )
      })}
    </Frame>
  )
}

/* ── 6 · Check out and lock ─────────────────────────────────────────── */
function SubmitArt() {
  return (
    <Frame title="Report submitted">
      <circle cx="150" cy="116" r="40" fill={PAL.soft} />
      <rect x="132" y="114" width="36" height="30" rx="7" fill={PAL.violet} />
      <path d="M137 114 v-8 a13 13 0 0 1 26 0 v8" stroke={PAL.violet} strokeWidth="5" fill="none" />
      <circle cx="150" cy="128" r="3.4" fill="#fff" />
      <text x="150" y="184" textAnchor="middle" fontFamily={FONT} fontSize="14" fontWeight="700" fill={PAL.ink}>Locked. No more edits.</text>
      <rect x="64" y="200" width="172" height="26" rx="13" fill={PAL.soft} />
      <text x="150" y="217" textAnchor="middle" fontFamily={FONT} fontSize="11" fontWeight="600" fill={PAL.violet}>Checked out · time stamped</text>
      <rect x="22" y="244" width="256" height="92" rx="14" fill="#fff" stroke={PAL.line} strokeWidth="1.5" />
      <text x="34" y="266" fontFamily={FONT} fontSize="11" fontWeight="700" letterSpacing="0.06em" fill={PAL.mut}>NOTE FOR NEXT SHIFT</text>
      <rect x="34" y="276" width="232" height="9" rx="4.5" fill={PAL.bar} />
      <rect x="34" y="294" width="200" height="9" rx="4.5" fill={PAL.bar} />
      <rect x="34" y="312" width="150" height="9" rx="4.5" fill={PAL.bar} />
    </Frame>
  )
}

const STEPS: { title: string; body: string; art: ReactNode }[] = [
  {
    title: 'Start your shift',
    body: 'Open the app, pick your name, your shift, and the profile you are covering. Your sign in time and the date are stamped for you. One report covers one profile.',
    art: <StartArt />,
  },
  {
    title: 'Read the handover note',
    body: 'If the last person on this profile left a note, it shows up the moment you sign in. Read it and tap Noted, so nothing from the shift before is lost.',
    art: <HandoverArt />,
  },
  {
    title: 'Log each action as it happens',
    body: 'Tap the action on your Shift Home, fill the short form that opens, and submit. The counter for that action goes up on its own.',
    art: <LogArt />,
  },
  {
    title: 'Watch the live summary',
    body: 'Your counts add up at the top of the screen as you work. No tallying, and no guessing your totals at the end.',
    art: <SummaryArt />,
  },
  {
    title: 'Run the wrap up checklist',
    body: 'Before you close, tick the end of shift checks, like CRM updated, ClickUp cleared, portfolio updated, briefs created, analytics checked, and orders checked one by one.',
    art: <ChecklistArt />,
  },
  {
    title: 'Check out and submit',
    body: 'Your check out time is stamped and the report locks, so it cannot be changed. Leave a short note for the next person on this profile, and you are done.',
    art: <SubmitArt />,
  },
]

export function ShiftLoggerFlow() {
  return (
    <div className="my-8 space-y-4">
      {STEPS.map((s, i) => (
        <div
          key={i}
          className="grid items-center gap-5 rounded-2xl border border-border bg-surface-2/30 p-4 sm:grid-cols-[230px,1fr] sm:p-5"
        >
          <div className="mx-auto w-full max-w-[250px]">{s.art}</div>
          <div>
            <div className="flex items-center gap-2.5">
              <span className="grid h-7 w-7 shrink-0 place-items-center rounded-full bg-gradient-to-br from-brand to-brand/70 text-sm font-bold text-brand-fg shadow-soft">
                {i + 1}
              </span>
              <h4 className="font-serif text-lg font-bold text-fg">{s.title}</h4>
            </div>
            <p className="mt-1.5 text-sm leading-relaxed text-muted">{s.body}</p>
          </div>
        </div>
      ))}
    </div>
  )
}
