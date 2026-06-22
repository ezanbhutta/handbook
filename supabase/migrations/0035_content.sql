-- =============================================================================
-- HaseebMadeit Handbook — 0035 content (batch 27): agency identity, process & people
-- Adds the CEO's company document as new sections, rewritten in the house voice
-- with widgets. Nothing existing is overwritten; topics already covered (CEO
-- Message, Mission/Vision/Values, What We Do, ClickUp, file naming) are
-- cross-linked, not duplicated.
--   • Welcome      → Our Story (history timeline)
--   • Welcome      → Our Services and Deliverables (service areas + examples)
--   • Delivery&QA  → Our Design Philosophy and Style (principles + visual standards)
--   • Delivery&QA  → Order to Delivery: Our Full Process (direct-client process)
--   • Delivery&QA  → Internal Project Process (how the team runs projects)
--   • HR/Payroll   → Career Growth at HaseebMadeit (levels, promotion, L&D)
--   • HR/Payroll   → Performance Review Process
-- Note: "Order to Delivery" is the DIRECT-CLIENT process; Fiverr/Upwork orders
-- follow the Fiverr Operations Playbook. Both are cross-linked so they never
-- contradict. Visible to all roles. Idempotent upserts by slug.
-- =============================================================================

-- 1) Welcome — Our Story -----------------------------------------------------
insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='welcome'),
  'Our Story', 'our-story',
  $BODY$
HaseebMadeit did not begin as a company. It began as a conviction: that in a world flooded with average visuals and copy-paste branding, there was room for a studio that genuinely cared about craft.

```steps
The Beginning | Haseeb starts freelancing, with one laptop, one client, and an obsession with getting every pixel right. Word spreads quickly about the quality of the work.
First Studio | The first official team comes together. HaseebMadeit takes on its first brand identity project and delivers results that triple the client's social engagement.
Agency Formation | HaseebMadeit registers as a design agency. A dedicated team of designers, strategists, and developers comes together under one roof.
Expanding Services | The studio expands into UI/UX, digital marketing design, and motion graphics. The client roster grows to include startups and established businesses.
Today | HaseebMadeit is a full-service design agency known for bold ideas, detailed execution, and measurable impact. The journey continues.
```

> **Tip:** Our history is not just a timeline. It is a story of persistence, creativity, and a steady belief that great design changes everything.
$BODY$,
  array['csr','asr','hr','pm','manager','office_boy','designer']::user_role[], false, 7
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

-- 2) Welcome — Our Services and Deliverables ---------------------------------
insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='welcome'),
  'Our Services and Deliverables', 'our-services',
  $BODY$
Our work spans brand identity, UI/UX design, packaging, social media visuals, and motion graphics. Here is a closer look at the kinds of projects we do best, and what each one delivers.

## 01 — Brand Identity
Full brand systems: logo design, colour palette, a typography system, brand guidelines, and brand voice.

*Example:* A tech startup needed to go from "just another app" to a category-defining brand. We built a complete identity system, logo, colours, type, and tone of voice, that helped them close their first major funding round.

**Deliverables:** Logo suite, brand book, stationery, social templates, email signature system.

## 02 — UI/UX Design
Interface and experience design for web apps, mobile apps, SaaS platforms, and e-commerce.

*Example:* An e-commerce brand was losing customers at checkout. We redesigned the entire purchase flow and reduced cart abandonment by 34% in the first month.

**Deliverables:** User research report, wireframes, high-fidelity mockups, interactive prototype, handoff files.

## 03 — Social Media Design
Consistent, high-impact visual systems for social media across every platform.

*Example:* A restaurant chain needed a cohesive presence across Instagram, Facebook, and TikTok. We built a modular template system their in-house team could run without compromising quality.

**Deliverables:** 30+ post templates, story templates, highlight covers, reel thumbnail system.

## 04 — Packaging Design
Product packaging that stands out on the shelf and communicates premium quality.

*Example:* A skincare brand launching a new line needed packaging that felt luxurious without the premium price. We created a minimalist system that outperformed competitor packaging in focus-group testing.

**Deliverables:** Die-line files, print-ready artwork, 3D mockups, packaging brand standards.

> **Note:** For the full list of services and where our work comes from, see [What We Do & Where We Work](/section/what-we-do).
$BODY$,
  array['csr','asr','hr','pm','manager','office_boy','designer']::user_role[], false, 8
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

-- 3) Design & QA — Our Design Philosophy and Style ---------------------------
insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='delivery-qa'),
  'Our Design Philosophy and Style', 'design-philosophy',
  $BODY$
At HaseebMadeit, design is not a service we sell. It is a language we speak. Every visual we create is rooted in strategy, shaped by emotion, and refined through craft.

## Core design principles

```keyvalue
Purpose first | Every element has a reason to exist. We ask "why" before we ask "how".
Bold but balanced | We are not afraid of strong visuals, but boldness without balance creates chaos. We pursue tension that feels intentional.
Typography as voice | Type is personality. We treat fonts the way a director treats casting, where every choice says something specific.
White space is power | Breathing room is not empty space. It directs attention, creates hierarchy, and makes a design feel confident.
Colour with meaning | We use colour strategically. Every palette tells a story and evokes a specific emotional response.
Consistency over complexity | A design system that works everywhere is worth more than a single stunning piece that works nowhere.
```

## Visual identity standards

### Typography
- Sans-serif for digital-first brands: clean, modern, and highly legible.
- Serif accents for premium, heritage, or editorial projects.
- Display fonts used sparingly, for headlines only, never body copy.
- Minimum body text: 14px on digital, 9pt in print.

### Colour strategy
Every project gets a custom palette built around the brand's emotional positioning.

- **Primary.** The dominant brand colour: memorable, ownable, intentional.
- **Secondary.** Supports hierarchy and adds depth without competing.
- **Accent.** Used for calls to action, highlights, and moments that need to pop.
- **Neutrals.** Background and body text, always tested for contrast and accessibility.

### Layout and grid
- All designs use an 8pt grid system for consistent spacing.
- A 12-column grid for web and app interfaces.
- Layouts are tested at multiple breakpoints before delivery.
- Visual hierarchy follows an F-pattern or Z-pattern, depending on the content.

> **Key principle:** Our aesthetic in one sentence. Clean without being cold, bold without being loud, strategic without being stiff.
$BODY$,
  array['csr','asr','hr','pm','manager','office_boy','designer']::user_role[], false, 4
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

-- 4) Design & QA — Order to Delivery: Our Full Process -----------------------
insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='delivery-qa'),
  'Order to Delivery: Our Full Process', 'full-process',
  $BODY$
From the first conversation to the final handoff, every direct-client project follows a structured process designed to protect quality, avoid surprises, and keep the client informed at every step.

```steps
Discovery | Understand the brief. The client fills out our onboarding questionnaire, we run a 30 to 60 minute discovery call, research the industry and competitors, and document the goals, KPIs, and non-negotiables. (1 to 2 business days)
Proposal | Scope and pricing. We prepare a detailed proposal with scope, timeline, and pricing. The client reviews, we adjust, the agreement is signed, and a 50% advance is collected to begin. (1 to 2 business days)
Kickoff | Align and begin. Internal kickoff with the assigned team, the project set up in our management system, the client added to the agreed channel, and the timeline milestones shared. (Day 1 of production)
Design | Create and iterate. The lead designer works from the brief, we run an internal review at 50% completion, then share the first draft. The client has 48 to 72 hours to send consolidated feedback.
Review | Client feedback. Revision rounds are completed within the agreed scope. Anything outside scope is quoted separately, and the client gives final written approval before files are prepared.
Delivery | Final handoff. Files are named and organised, the balance is invoiced and paid, and everything is delivered with a handoff document. Post-delivery support covers minor adjustments for 7 days at no charge.
```

## Standard timelines

```keyvalue
Logo and brand identity | 7 to 14 business days
UI/UX project | 2 to 6 weeks, depending on scope
Social media templates | 3 to 5 business days
Packaging design | 5 to 10 business days
Motion graphics | 7 to 14 business days
```

> **Note:** This is the process for direct-client projects. Orders that come through Fiverr and Upwork follow the [Fiverr Operations Playbook](/section/csr-playbook-start-here) and live in ClickUp from the first message to final delivery.
$BODY$,
  array['csr','asr','hr','pm','manager','office_boy','designer']::user_role[], false, 5
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

-- 5) Design & QA — Internal Project Process ----------------------------------
insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='delivery-qa'),
  'Internal Project Process', 'internal-process',
  $BODY$
This is for the HaseebMadeit team. It is how we run projects internally so the output stays consistent and the quality stays high.

## Project management
- Every project is tracked in ClickUp, our project management tool.
- Each project has its own board with tasks, deadlines, and owners.
- No task is done until at least one other person has reviewed it.
- The project lead updates the board every day.

## Files and assets
- All working files live in the designated cloud folder, never only on a personal device.
- File naming follows our convention, `ClientName_ProjectType_Version_Date`, for example `HaseebCo_Logo_v2_2025`. See [SOP 09](/section/sop-09-file-naming) for the full rules.
- Source files (.ai, .psd, .fig) are always saved in the Source folder.
- Export files go in the Exports folder, separated by format.
- Old versions are moved to Archive, never deleted.

## Design review protocol

```steps
Self-review | The designer finishes the initial work and checks it against the brief.
Peer review | The work goes for internal peer review before the client sees it.
Reviewer checks | The reviewer looks at alignment to the brief, quality of execution, and file organisation.
Feedback | Feedback is given within 24 hours: constructive, specific, and actionable.
Revise | The designer revises and submits for final lead approval.
Lead approval | Only after lead approval does the work go to the client.
```

## Communication standards
- Client communication is professional, clear, and prompt, with a maximum 4-hour response during business hours.
- Important decisions made on a call are always confirmed in writing.
- The team uses the agreed channels only. No project talk in personal chats.
- Any scope change is documented and approved in writing.

> **Tip:** The one rule that holds all of this together is the same as on the Fiverr floor. If it is not in ClickUp, it did not happen. See [How We Use ClickUp](/section/clickup-basics).
$BODY$,
  array['csr','asr','hr','pm','manager','office_boy','designer']::user_role[], false, 6
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

-- 6) HR & Payroll — Career Growth --------------------------------------------
insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='hr-payroll'),
  'Career Growth at HaseebMadeit', 'career-growth',
  $BODY$
We are not a place people come to do a job. We are a place people come to grow into the best version of their professional selves. We invest in our team because our work is only ever as strong as the people behind it.

## Career levels (design track)

```steps
Junior Designer | 0 to 2 years. Learning the craft, building speed, and developing taste. Works under close guidance on defined tasks. Focus: execution and quality.
Mid-Level Designer | 2 to 4 years. Owns projects independently and turns strategy into design. Mentors juniors. Focus: ownership and depth.
Senior Designer | 4 to 7 years. Leads design direction on complex projects and contributes to brand strategy. Sets the quality standard. Focus: leadership and vision.
Lead Designer / Art Director | 7+ years. Oversees multiple projects and designers, joins pitches and new business, and shapes the creative direction. Focus: strategy and people.
Creative Director | Agency-level creative leadership. Partners with the CEO on direction, culture, and major client relationships. Focus: vision and culture.
```

## How promotions work
Promotions are merit-based and transparent. To move up a level, you show:

```checklist
Consistent, high-quality work with minimal supervision
Mastery of the skills your current level requires
Clear readiness for the responsibilities of the next level
A positive impact on team culture and collaboration
Client feedback that reflects professionalism and skill
```

## Learning and development
- An annual learning budget for every team member: courses, books, or conferences.
- Monthly internal knowledge-sharing sessions, where the team teaches each other.
- Access to premium design resources, tool subscriptions, and font libraries.
- Mentorship: junior and mid-level designers are paired with a senior.
- Continuous feedback, not just at review time.

> **Key principle:** If you bring your best to HaseebMadeit, we will invest in making your best even better. We promote from within whenever we can, and your growth is a shared responsibility between you and the agency.
$BODY$,
  array['csr','asr','hr','pm','manager','office_boy','designer']::user_role[], false, 11
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

-- 7) HR & Payroll — Performance Review Process -------------------------------
insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='hr-payroll'),
  'Performance Review Process', 'performance-review',
  $BODY$
Performance reviews here are not a formality. They are a structured, honest conversation about where you are, where you want to go, and how we get there together.

## How often

```keyvalue
Probation review | At the end of the 90-day probation, for every new hire
Mid-year check-in | An informal review in June: a progress check and goal realignment
Annual review | A formal review in December: rating, growth plan, and compensation
On-demand review | Available any time you ask for one, with no waiting
```

## What we look at

```keyvalue
Work quality | Is the output consistently meeting the standard? Is the craft improving over time?
Reliability | Are deadlines met? Is communication proactive? Can the team count on you?
Collaboration | How do you work with others? Do you give and take feedback well?
Growth mindset | Are you learning, taking initiative, and bringing new ideas?
Client impact | What is the client's experience? Are you delivering value beyond the brief?
```

## The review, step by step

```steps
Self-evaluation | You complete a self-evaluation form one week before the review.
Preparation | Your manager reviews recent work, project feedback, and peer input.
The meeting | A one-hour review, held as a structured conversation, not a lecture.
Strengths | Strengths are acknowledged specifically and sincerely.
Growth areas | Areas to grow are discussed with clarity and without blame.
Growth plan | You co-create a 90-day growth plan with clear, measurable goals.
Documented | The summary is written down and shared with you.
Follow-up | A check-in is scheduled for 30 days after the review.
```

## The rating scale

```keyvalue
Exceptional (5) | Consistently exceeds expectations. A role model for the team.
Strong (4) | Regularly meets and often exceeds expectations. Growing confidently.
Solid (3) | Meets expectations consistently. Dependable and reliable.
Developing (2) | Meets some expectations. Clear growth areas with a support plan in place.
Needs improvement (1) | Not yet meeting expectations. An immediate, structured improvement plan.
```

> **Important:** A performance review is never a surprise. If there is a serious concern, it is raised straight away, not saved for a review meeting. We believe in real-time feedback and continuous conversation.
$BODY$,
  array['csr','asr','hr','pm','manager','office_boy','designer']::user_role[], false, 12
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;
