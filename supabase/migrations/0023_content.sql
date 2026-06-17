-- =============================================================================
-- HaseebMadeit Handbook, 0023 content (batch 15): Dress Code
-- Adds a Dress Code section to Conduct & Culture for a Pakistani design agency
-- with international clients. Shalwar kameez and pant shirt are both welcome,
-- properly pressed. Covers grooming, footwear, on-camera, modest dress, what is
-- not allowed, and the consequence. Human voice, widgets. Idempotent.
-- =============================================================================

insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='conduct'),
  'Dress Code', 'dress-code',
  $BODY$
How you turn up says something about the company before you say a word. We keep it simple. Dress clean, neat, and professional every day. Whether you wear shalwar kameez or a pant shirt is your choice, and both are welcome. What matters is that it is tidy and properly pressed.

> **Rule:** Your clothes must be clean and properly pressed, every shift. Wrinkled, stained, or shabby clothing is not acceptable, not even on the night shift.

## What to wear
- Shalwar kameez or a pant shirt, both are fine. Pick whatever you are comfortable in.
- Iron your clothes properly. A neat press is the difference between looking professional and looking rushed.
- Keep to decent, modest, and professional clothing in calm colours.
- Wear clean, presentable shoes and keep them in good shape.
- For the women on the team, professional and modest dress such as shalwar kameez or formal wear is welcome. Abaya and hijab are completely fine and respected.

## Grooming and hygiene
- Show up clean and fresh for every shift.
- Keep your hair neat. A beard is fine when it is kept tidy and groomed.
- Trimmed nails, fresh breath, and basic hygiene are expected.
- Keep any fragrance light. Nothing strong in a shared room.

## On camera and with clients
You are the face of the company to clients around the world. When you join a meeting or a call with the camera on, look the part, with pressed clothes, a tidy background, and a professional manner. The night shift is held to the same standard, even when the office is quiet.

## What works and what does not

```dodont
Everyday office wear | A pressed shalwar kameez, or a pant shirt with clean shoes. | Wrinkled, stained, or slept in clothes.
Footwear | Clean, presentable shoes. | Worn out slippers or flip flops in the office.
Fit for the room | Decent, modest, professional dress. | Shorts, ripped jeans, vests, gym wear, or beachwear.
Prints | Plain or simple patterns. | Slogans or images that could offend anyone.
```

## A quick check before you leave

```checklist
My clothes are clean and properly pressed.
My shoes are clean and presentable.
I am groomed: neat hair, trimmed nails, and fresh.
Any fragrance I am wearing is light.
I would be happy for a client to see me on camera right now.
```

> **Tip:** If you are ever unsure whether something is fine to wear, it probably is not. Keep it simple and professional, and ask HR when you really are not sure.

> **Important:** Turning up untidy or dressed against this code, again and again, is a conduct matter. Your Team Leader or HR will raise it, and it can affect your monthly grade.
$BODY$,
  array['csr','asr','hr','pm','manager','office_boy']::user_role[], false, 4
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;
