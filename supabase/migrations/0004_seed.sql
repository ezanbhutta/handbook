-- =============================================================================
-- HaseebMadeIt Handbook — 0004 seed
-- The 12-chapter spine (inserted empty) + a few starter search synonyms.
-- Content is added later through the admin authoring screen.
-- =============================================================================

insert into chapters (title, slug, order_index, description, icon) values
('Welcome & Company',            'welcome',         1, 'Who we are, our brands, and the org chart.',                                  'home'),
('Conduct & Culture',            'conduct',         2, 'Dress code, behavior, phone and social media use.',                           'users'),
('Attendance, Shifts & Leave',   'attendance',      3, 'Timings, shift swaps, late policy, and leave.',                               'calendar'),
('Your Role',                    'your-role',       4, 'What your job is and how to do it well.',                                     'badge'),
('Fiverr Operations Playbook',   'fiverr-ops',      5, 'Inquiries, requirements, revisions, delivery, cancellations, disputes, reviews.', 'briefcase'),
('Design Delivery & QA',         'delivery-qa',     6, 'Our quality standard before anything reaches a client.',                      'check'),
('Tools & Systems',              'tools',           7, 'Our internal systems and ClickUp — what to use and how.',                     'wrench'),
('HR & Payroll',                 'hr-payroll',      8, 'Pay, benefits, and HR processes.',                                            'wallet'),
('Security & Confidentiality',   'security',        9, 'Account safety and protecting information.',                                  'shield'),
('Emergencies & Escalation',     'escalation',     10, 'Who to contact when something breaks.',                                       'alert'),
('Glossary & FAQ',               'faq',            11, 'Common terms and quick answers.',                                             'help'),
('What''s New',                  'whats-new',      12, 'Every recent change to this handbook.',                                       'sparkles')
on conflict (slug) do nothing;

-- Starter synonyms. The V1 search expands single words, so seed single-word
-- terms that actually resolve (multi-word phrases like "paisa wapas" won't
-- match token-for-token — add those once phrase search lands).
insert into search_synonyms (term, maps_to) values
('chutti',     'leave'),
('chuti',      'leave'),
('refund',     'cancellation'),
('cancelation','cancellation'),
('paisa',      'cancellation'),
('wapas',      'cancellation'),
('salary',     'payroll'),
('tankhwah',   'payroll'),
('attendence', 'attendance'),
('timing',     'shift'),
('clickup',    'tools'),
('revision',   'revisions')
on conflict do nothing;
