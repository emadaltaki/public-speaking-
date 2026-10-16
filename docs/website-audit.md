# Speak Up Fearless website audit (16 Oct 2026)

## Verdict: would people book?

**Some would, but fewer than the site could get.** The design now looks credible and the message is warm and specific to anxious speakers, which is the hard part. Three gaps hold bookings back:

1. **People searching Google will barely find the site.** It's built with Flutter, so the page Google downloads is almost empty (just a script tag). Searches like "public speaking classes Mississauga" are unlikely to show it.
2. **There's no way to actually book.** Every button opens an email draft. Many phone users have no mail app set up, so the tap does nothing, and an email to a stranger is a much bigger step than picking a time slot.
3. **Visitors can't tell when or where sessions happen.** The FAQ answers to "How often?" and "Online or in person?" are "email us". An anxious person who has to ask before they even know whether it fits their week will usually leave instead.

Visitors who come through personal referrals will probably still book. Cold visitors probably won't, until the gaps above are fixed.

## What's already good

- The page is aimed at a clear audience (people with speaking anxiety) and reassures them all the way down: no judgment, no pressure, everyone starts somewhere.
- Prices are shown up front in CAD, with a free intro session to lower the barrier.
- It uses real photos from your sessions, not stock images.
- It works on phones, and taps and fonts are sized comfortably.
- The page has a title, description and social-share tags, plus a web app manifest.

## Fix first: biggest impact on bookings

| # | Issue | Why it matters | Fix |
|---|---|---|---|
| 1 | No real booking | Email drafts lose people, especially on phones | Add a Calendly or Cal.com link for the free intro call and make it the main button. Optionally take session payments through Stripe Payment Links. |
| 2 | Schedule, location and format are hidden | Basic fit questions go unanswered, so people leave | List the day and time, the neighbourhood or venue in Mississauga, session length, group size, and whether sessions are online or in person |
| 3 | No participant testimonials | Both quotes are from the hosts, which isn't social proof | Collect 3–5 short quotes from past participants (first name plus a photo, with their consent) |
| 4 | Host credentials aren't shown | Visitors are trusting strangers with something they're nervous about | Add 2–3 lines per host on their background and experience |
| 5 | Invisible to Google | No organic traffic | See the SEO section below |
| 6 | No Google Business Profile | That's where local searches and Maps results come from | Create one for Mississauga, link it to the site, and ask happy members for reviews |

## SEO and discoverability

- **Crawlable text:** Google sees almost nothing in `web/index.html`. Either rebuild the landing page as plain HTML (Astro, Next.js or plain HTML; best for SEO), or at minimum put a full HTML copy of the key content (headings, services, prices, location, FAQ) inside `index.html` so crawlers can read it.
- **Local keywords:** the title and description never mention Mississauga or Ontario. Use something like "Public Speaking Classes in Mississauga | Speak Up Fearless".
- **Structured data:** add JSON-LD `LocalBusiness` and `FAQPage` markup.
- **Basics:** there's no `robots.txt` or `sitemap.xml`. There's also no canonical URL or custom domain. A domain like speakupfearless.ca would look more trustworthy than a vercel.app address.
- **Link previews:** `og:image` points at the app icon through a relative path, so shared links show a tiny logo or none at all. Use an absolute URL to a 1200×630 session photo.

## Performance

- Before anything shows, the browser downloads about **3.5 MB compressed** (about 0.7 MB of app code plus about 2.8 MB for the CanvasKit rendering engine). On mobile data that can mean several seconds of blank screen, and some visitors leave before the page appears.
- Photos are already small (under 115 KB each), which is good.
- A plain HTML landing page would load in well under a second.

## Accessibility

- Flutter web keeps screen-reader support off until the user turns it on, so blind and low-vision visitors may get nothing. Calling `SemanticsBinding.instance.ensureSemantics()` at startup turns it on.
- Body text sizes and contrast are good. The navy, teal and white combinations meet WCAG AA for normal text.
- Text can't be selected or found with the browser's find-in-page the way it can on a normal web page.

## Trust and legal

- **Contact address:** a Gmail address looks less established than a matching domain address such as hello@speakupfearless.ca.
- **Privacy policy:** there isn't one. Add a short page explaining what you collect and how it's used, which matters more once you add booking, payments or analytics. You're in Ontario, so PIPEDA applies.
- **Cancellation and refund policy:** add one for the paid packages, because buyers look for it before paying $180–$320.
- **Social links:** there are none. Even one active Instagram account showing real sessions builds trust.

## Measurement

- **Analytics:** there's nothing installed, so you can't see visitor numbers or where people drop off. Add a privacy-friendly tool such as Plausible, Vercel Analytics or GA4.
- **Conversions:** track clicks on "Book a free session" so you know what's working.

## Suggested order

1. Booking link plus schedule, location and format (no rebuild needed).
2. Participant testimonials, host bios and a cancellation policy.
3. Google Business Profile, custom domain and domain email.
4. A plain-HTML landing page, or crawlable content in `index.html`, plus local SEO and structured data.
5. Analytics, privacy policy and an accessibility toggle.
