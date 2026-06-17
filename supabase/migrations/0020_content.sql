-- =============================================================================
-- HaseebMadeit Handbook, 0020 content (batch 13)
-- Add the break window for each shift to the Work Schedule table. Each break is
-- 45 minutes. Wording otherwise unchanged. Idempotent upsert by slug.
-- =============================================================================

insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='attendance'),
  'Work Schedule and Shifts', 'work-schedule',
  $BODY$
We run three shifts. Each one is 8 hours, with a 45 minute break.

| Shift | Hours | Break |
| --- | --- | --- |
| Morning | 9:00 AM to 5:00 PM | 1:15 PM to 2:00 PM |
| Evening | 5:00 PM to 1:00 AM | 9:45 PM to 10:30 PM |
| Night | 1:00 AM to 9:00 AM | 5:45 AM to 6:30 AM |

Working days are Monday through Sunday, with 1 day off each week, assigned by your supervisor based on the shift schedule.
$BODY$,
  array['csr','asr','hr','pm','manager','office_boy']::user_role[], true, 1
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;
