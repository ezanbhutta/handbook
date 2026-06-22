-- =============================================================================
-- HaseebMadeit Handbook — 0034 content (batch 26): the CEO's message
-- A personal welcome letter from the founder, Abdul Haseeb. Opens the handbook:
-- placed at the top of the Welcome chapter (order_index 0, ahead of the existing
-- intro at 1) and shown first in onboarding. Visible to every role. Idempotent
-- upsert by slug. House voice kept; the two beliefs render as pull-quotes.
-- =============================================================================

insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='welcome'),
  'CEO Message', 'ceo-message',
  $BODY$
> **Design is not decoration, it is communication.**

That single belief is the reason HaseebMadeit exists. And it is the belief that brought you here.

My journey into design started not in a studio, but with a question I could not shake: why do some brands make people feel something, while others are completely forgettable?

That question consumed me. I spent years learning, experimenting, failing, and getting back up, until I realised that the answer was never just about aesthetics. It was about intention.

I founded HaseebMadeit with a simple mission: to create design that has a soul. Design that solves real problems, tells real stories, and builds real connections between brands and the people they serve.

> **Design that has a soul does not just look good. It works. It earns trust. It makes people remember.**

This handbook is a reflection of everything we stand for: our values, our process, and our commitment to excellence. Read it, live it, and let it be your north star every time you sit down to create.

Welcome to the team. Let us build something remarkable together.

**Abdul Haseeb**\
Founder & CEO, HaseebMadeit
$BODY$,
  array['csr','asr','hr','pm','manager','office_boy','designer']::user_role[], true, 0
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;
