-- =============================================================================
-- HaseebMadeit Handbook, 0012 content (batch 5)
-- Updates from the revised CSR SOPs: richer remark examples (SOP 06) and client
-- message scripts (SOP 12). Also removes the signed blank cheque from the
-- joining documents (no confidential data). Example client/designer names are
-- kept generic so no client data appears. Idempotent upsert by slug.
-- =============================================================================

insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='fiverr-ops'),
  'SOP 06: Remarks on Every Order', 'sop-06-remarks',
  $BODY$
Every order needs a running set of remarks, so anyone, including a Senior, can understand the whole story by reading them alone. A good remark says what happened, who is involved, and what comes next, in one clear entry.

## Real examples
Here is how to log the different situations you will run into.

**Standard order, assigned**
> The client asked for 3 logo variations on a dark background. Brief shared with the designer. Deadline 28 June, 5:00 PM. Client prefers a minimalist style, noted in the brief. ClickUp updated.

**Frustrated client**
> The client was strongly dissatisfied at 3:15 PM, saying the logo colours do not match what was discussed at onboarding. Their tone was very firm. Escalated to the Senior straight away. No promises made. Awaiting the Senior's direction before replying. ClickUp flagged as Escalated.

**Unclear or incomplete brief**
> The client sent a brief but did not give a colour palette, target audience, or brand tone. Not assigned to a designer yet. Sent a clarification message at 11:30 AM asking for these details. On hold pending the client's reply. ClickUp set to Pending Client Info.

**Cancellation request**
> The client asked to cancel at 2:00 PM, citing a change in business direction. Acknowledged it professionally. No cancellation processed and no refund discussed. Escalated to the Senior at 2:05 PM with a full summary. Designer work paused. ClickUp set to Cancellation, Pending Senior Review.

**Dispute or quality complaint**
> The client disputed the delivered design at 5:45 PM, saying the banner size is wrong (delivered 1080x1080, requested 1920x1080). Reviewing the brief now. The first check confirms the client is right, the dimension was missed. Escalated to the Senior. The designer is preparing a corrected version. Will not deliver again until QC and the Senior sign off.

## Good and poor, side by side
| Good | Poor |
| --- | --- |
| "Revision received, 4 points: font to bold, darker background, remove the tagline, centre the logo. Assigned to the designer. Deadline 27 June, 3:00 PM. ClickUp set to Revision In Progress." | "Client wants changes. Told designer." |

## How to write them
- Add a remark every time something meaningful happens, such as an assignment, a revision, a delivery, or client feedback.
- Each one says what happened, who is responsible, and the next step.
- Write in clear, simple English. No slang, short forms, or vague lines.
- A Senior who has never touched this client should get the full picture from your remarks alone.
- Always note the time of important events, such as escalations, complaints, and deliveries.
$BODY$,
  array['csr','hr','pm','manager']::user_role[], false, 7
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='fiverr-ops'),
  'SOP 12: Looking After the Client Relationship', 'sop-12-client-relationships',
  $BODY$
Our relationships with clients are the most valuable thing we have, and you are the face of the company to them. Every chat should build trust.

## How we talk to clients
- Use the name they prefer.
- Be warm and professional. Never cold, rude, blunt, or too casual.
- Keep your word. If you say you will get back shortly, actually do, not the next day.
- Keep them posted without being asked. If a client has to chase you for an update, that is on the CSR who has their profile.
- If a deadline slips, tell them right away and apologise properly. Never let a deadline pass in silence, and never make us look careless. If a designer or anyone else made a mistake, that stays inside. You never put it on the client, because it reflects on all of us.

## Example messages
Use these as your guide.

**First reply to a new client**
- Say: "Hi [Name], thank you for reaching out to HaseebMadeit. I have your message and am reviewing your requirements right now. I will come back to you with a full response shortly."
- Not: "ok noted. will check and reply."

**A progress update while work is on**
- Say: "Hi [Name], a quick update. Your project is with our design team and on track for delivery by [date and time]. We will send it over as soon as it is ready."
- Not: "Still working on it."

**Delivering finished work**
- Say: "Hi [Name], great news, your [project name] is ready. The files are in the Google Drive link below and as a ZIP. If the ZIP does not open, the Drive link works perfectly. Please review and let us know your thoughts."
- Not: "Here are your files."

**When a deadline cannot be met**
- Say: "Hi [Name], I want to be open with you. Because of [brief reason], we need an extra [time] to make sure your work meets our quality standard. We are sorry for this and appreciate your patience. Your updated delivery time is [new time]."
- Not: "Sorry for the delay, we will send it soon."

**When a client checks in and there is no news yet**
- Say: "Hi [Name], thank you for checking in. Your project is with our design team and progressing well. I will send an update as soon as I have a confirmed timeline. Thank you for your patience."
- Not: "Not ready yet. Will let you know."

**Closing message when a project is done**
- Say: "Hi [Name], it has been a pleasure working on your project. I hope you are delighted with the result. If you ever need anything in future, new designs, revisions, or new projects, we are always here. Thank you for choosing HaseebMadeit."
- Not: "Done. Let us know if you need anything else."

> **Standard:** Every message is a direct reflection of the brand. Write each one as if the CEO will read it. Be warm, clear, and professional, always.

## Building relationships that last
- Put the client's success ahead of the single sale. People who feel looked after come back, every time.
- Remember the little things from past chats and bring them up when it fits.
- When a project wraps up, thank them genuinely and invite them back, with no selling tone.
- Never pressure a client to leave a review or place a new order before they are ready. Understand their problem, guide them well, and ask a Senior if you are stuck. Do not sell. Help. Show them value and you will see the difference.
$BODY$,
  array['csr','hr','pm','manager']::user_role[], false, 13
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;

-- Remove the signed blank cheque from the joining documents (no confidential data).
insert into sections (chapter_id, title, slug, body, allowed_roles, show_in_onboarding, order_index)
select (select id from chapters where slug='hr-payroll'),
  'Joining Documents and Your Information', 'joining-documents',
  $BODY$
## What to bring when you join
- 2 copies of your CNIC.
- 1 copy of a reference CNIC.
- A passport size photograph.
- Your original degree or diploma.
- A copy of your previous experience letter, if you have one.
- Your last 2 salary slips or bank statements, if applicable.

## Keep your details current
Tell HR straight away if any of these change:

- Address.
- Email.
- Postal code.
- Phone number.
- Marital status.
- Emergency contacts.
- Banking information.
$BODY$,
  array['csr','asr','hr','pm','manager','office_boy']::user_role[], false, 7
on conflict (slug) do update set
  chapter_id=excluded.chapter_id, title=excluded.title, body=excluded.body,
  allowed_roles=excluded.allowed_roles, show_in_onboarding=excluded.show_in_onboarding, order_index=excluded.order_index;
