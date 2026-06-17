-- =============================================================================
-- HaseebMadeit Handbook, 0016 content (batch 9)
-- Adds the official company contact block from the Employee Handbook footer
-- (office address, email, phone, hours) as a "Where to Find Us" section in the
-- escalation/contact chapter. This is public company contact information, not
-- confidential data. Idempotent upsert by slug.
-- =============================================================================

insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='escalation'),
  'Where to Find Us', 'where-to-find-us',
  $BODY$
Here is where we are, and how to reach the company directly.

```keyvalue
Office | Office 20, 2nd Floor, Crystal Arcade, Near Katchery, Multan
Email | haseebmadeit@gmail.com
Phone | +92 317 1617142
Hours | Three shifts, round the clock, Monday to Sunday
```

For anything on an order or a client, start with your shift Team Leader, the way it is set out in [Who to Contact and How to Escalate](/section/who-to-contact). For anything to do with HR, leave, pay, or your records, reach the HR Department through the same office.
$BODY$,
  array['csr','asr','hr','pm','manager','office_boy']::user_role[], false, 2
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;
