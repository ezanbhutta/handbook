-- =============================================================================
-- HaseebMadeit Handbook, 0013 content (batch 6)
-- Make the Company Hierarchy visual: a top-down org chart and colourful
-- per-shift cards (using the new markdown widgets). Idempotent upsert by slug.
-- =============================================================================

insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='welcome'),
  'Company Hierarchy and Shifts', 'company-hierarchy',
  $BODY$
We run three shifts. Each one has a Team Leader you report to, and its own CSR team. When something is past what you can handle on your own, your Team Leader is the first person you go to.

## Who reports to whom

```orgchart
CEO and Founder | Abdul Haseeb | Final calls, scores, and the big decisions
Team Leaders and Seniors | Ezan, Zubair | Run the shifts, handle escalations and cancellations, and coach the team
Project Manager | | Keeps work moving between the CSRs and the designers
CSRs | | Own the client conversation and the order, start to finish
```

See the [Project Manager role](/section/role-pm) and the [CSR role](/section/role-csr) for what each one does day to day.

## The team, by shift

```shiftcards
Morning | 9:00 AM to 5:00 PM | Ezan | Iqra Qaiser, Tanzeel Bibi, Hassan Mehdi, Amrah Shoaib
Evening | 5:00 PM to 1:00 AM | Zubair, Ezan | Abdul Basit, Tayyab, Husnain Gillani, Abdul Hadi, Ali Shakeel
Night | 1:00 AM to 9:00 AM | Zubair | Salman Malik, Ahmed Bibrash, Swaid Khan, Saad Khan, Nadir Ali, Samama
```

> **Tip:** Not sure who to ask? Go to your shift Team Leader first. They will take it up to the Project Manager or the CEO if it needs to go further. HR and the Seniors keep this list current.
$BODY$,
  array['csr','asr','hr','pm','manager','office_boy']::user_role[], true, 2
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;
