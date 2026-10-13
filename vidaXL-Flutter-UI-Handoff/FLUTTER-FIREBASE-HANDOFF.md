# vidaXL+ — Mobile UX and Flutter/Firebase handoff

Updated 13 October 2026. Scope selected by Rajesh: upgrade the existing browser demo and provide the implementation specification for the Flutter/Firebase team. This is a UX prototype and handoff, not a delivered Flutter binary or connected Firebase project. A reusable Dart UI package is now supplied in `flutter_ui_handoff/`; compilation and native widget tests must be run in the developer’s Flutter environment.

## Product direction

Build an approachable, premium-feeling home-and-garden membership app. Premium means controlled hierarchy, truthful product imagery, clear pricing, excellent spacing and responsive interactions. Preserve vidaXL’s value positioning and official brand identity. The app connects discovery, auctions, loyalty and assistance without overwhelming the dashboard.

The client deck’s original pillars remain: Offers, Auctions, Rewards and Priority Support. Rajesh’s additions expand the entry flows, add a distinct Home dashboard, contextual AI chat, dynamic recommendations and granular notifications. These additions are proposed POC scope; they are not treated as already approved client requirements.

## Scope and information architecture

Bottom navigation: **Home, Shop, Auctions, Rewards, Ask vida**. Notifications and Account are accessible from the header. Support is accessible from Account and directly from Ask vida; chat never gates human help. This deliberately changes the deck’s original four tabs to accommodate the requested Home and AI screens while avoiding six or seven tabs.

| Screen family | Required flow | Important states |
|---|---|---|
| Splash | Brand reveal → resolve session / pending deep link → Login or Home | Auth loading, signed out, restored session; timeout/retry in native implementation |
| Registration | Name, email, password, terms → verification → Home → optional preferences | Field errors, weak password, existing account, service failure, pending verification |
| Login | Credentials → session → original intended destination | Invalid credentials, loading, offline, reset route, guest browsing |
| Password reset | Email → neutral confirmation → sign in | Invalid email, request failure, no account-disclosure wording |
| Home / Dashboard | Search, collection feature, personalized products, updates, recent items, auction teaser and next mission | Cold start, returning user, relevant alert, no recommendations, personalization off |
| Products / Shop | Search / category / sort → products → detail | Results, empty state, loading, unavailable product, stale prices |
| Product details | Product image, price, terms → wishlist / contextual chat / webshop handoff | Saved, changed price, eligibility, expired offer, availability failure |
| Auctions | Discover / watch → setup → maximum bid → confirmation → leading/outbid → win/loss | Automatic bidding, changed closing time, invalid/stale bid, network failure, completed auction |
| Rewards | Available/pending points → missions → claim / voucher → activity | Incomplete, eligible, claimed, moderation pending, redemption failure, expiry |
| AI conversation | Intent or product context → grounded reply → product / order / rewards / support action | Thinking, answer, no result, clarification, timeout, retry, human handoff |
| Notifications | All / Unread / Prices / Auctions → exact destination | Read status, duplicate suppression, stale event, preference off, permission denied |
| Account and Support | Preferences, history, orders, benefits and support request → confirmation | Standard/Gold entitlement, order context, request history and retry |

Preserve each tab’s position and filters in Flutter. Save important user work across navigation; do not rebuild the whole app when a bid or points balance changes. A notification must open the exact product/auction and then return to the user’s previous context.

## Core journeys to rehearse

1. **New member:** Splash → Registration → Verification → Home → Home preferences → Rewards → claim profile mission. Preferences and email marketing are optional, separate choices.
2. **Returning member:** Splash → session restore or Login → Home → relevant search → products → detail → wishlist → Home changes to match interest.
3. **Price drop:** Save/view a product → authoritative price-change event → eligibility and preference checks → in-app/FCM notification → exact product detail with current price → webshop.
4. **Auction:** Relevant discovery or wishlist alert → auction → delivery/payment readiness → private maximum → review → leading → automatic bid within limit → outbid → raise limit or watch → outcome.
5. **Recovery:** Auction lost → respectful relevant purchase offer → product detail → webshop handoff → authoritative purchase confirmation → pending points. Never count a webshop click as an order.
6. **Rewards and gamification:** Visible prerequisites → complete useful actions → eligible claim → one reward acknowledgment → ledger and tier progress update. Vouchers are a separate discount choice and do not stack with offer discounts unless governing policy allows it.
7. **AI assistance:** Product detail → Ask vida with product context → material/care information grounded in the product source → clarify budget/style → existing product cards. A complaint routes directly to human support.
8. **Notification cold start:** Tap message → Splash/session resolution → authentication if needed → revalidate event target → exact destination. If the event is no longer actionable, explain the current state.

## Dashboard personalization

The POC demonstrates deterministic rules, not machine learning. Use this transparent baseline before introducing a larger recommendation model.

| Signal | Proposed use | What the user sees |
|---|---|---|
| Submitted searches | Identify a current category / intent | “Because you searched for…” |
| Recent product views | Continue a project; related-category discovery | “Still on your mind?” |
| Wishlist | Track selected products and price snapshots | Relevant price-drop updates |
| Auction watchlist / participation | Show status and approaching close | Watched auction and outbid updates |
| Declared home preferences | Supplement sparse history | Style/room relevant collection |
| No history | Curated brand collections and general member favourites | Clear, useful cold-start dashboard |

Initial ranking: recent explicit search intent, viewed category, saved products, and general catalogue fallback. Production should include recency decay, diversity, stock/eligibility, market/currency and suppression of purchased/hidden items where appropriate. A searched product must not be called a wishlist item unless explicitly saved.

Priority of modules: actionable auction/transaction updates first when relevant, then the brand collection, recommendations, recently viewed, auction discovery and a compact reward prompt. Avoid autoplay carousels, unnecessary pop-ups or a feed of unrelated discounts.

Give users “Why?”, “Show less”, personalization off, clear history and preference controls. Do not retain typed-but-unsubmitted text as production search history. The browser demo saves non-empty search terms after a short pause; the native contract records submitted intent events only.

### Price and auction alert rules

- Use current authoritative product prices and historical snapshots, with stable product/variant/market/currency identifiers. Member discount versus regular-price reduction must be distinguishable.
- Proposed demo price threshold: 5% below the tracked snapshot. This is configurable and needs client approval.
- Check relevance, eligibility, stock, user preference and OS notification permission separately. A denied push permission does not hide useful in-app updates.
- Deduplicate using source event ID plus user/target. Prefer digesting non-urgent related-product changes; outbid messages can be immediate when opted in.
- Store in-app inbox records independently of FCM delivery. Delivery/read state must not be inferred from an attempted push.
- Avoid misleading urgency. Use actual closing times, expiry and eligibility.

## Motion and interaction specification

| Moment | Intended effect | Proposed timing | Flutter approach |
|---|---|---|---|
| Splash | Official logo fades into place; Plus gently settles | 650–800 ms visual reveal; no artificial native loading delay | `AnimationController`, fade/scale; native launch screen for immediate app opening |
| Button press | Small compression and immediate feedback | 90–140 ms, scale approximately 0.98 | `AnimatedScale` / interactive Material surface |
| Wishlist | Heart gently pops, saved state settles | 350–430 ms; one subtle success cue | Tween/scale plus optional light haptic |
| Product to detail | Product image maintains visual continuity | 240–300 ms | `Hero` with stable product/variant tag |
| Page / sheet | Short fade and small movement; sheet arrives from bottom | 220–280 ms | route transition / modal sheet; do not animate unrelated data refreshes |
| Reward progress | Progress changes smoothly; celebration once on successful claim | 400–550 ms; short celebration | `TweenAnimationBuilder` / controlled animation |
| Bid result | Amount/status updates clearly, without flashing countdowns | 150–200 ms | `AnimatedSwitcher` on changed state only |
| AI response | Thinking indicator, then readable answer and cards | Natural response duration; no fake long delay | small bounded animation; streaming only if it improves reading |
| Loading | Stable skeleton layout prevents jumps | Stop promptly on result or failure | shimmer/skeleton limited to visible affected module |

The updated browser demo implements press feedback, page entry, supported-browser shared-image transitions, sheet/toast entry, heart feedback, splash reveal, progress fill and chat thinking feedback. The loading-skeleton and native haptic mappings are handoff requirements, not claimed browser features.

Respect reduced motion / disabled animations, do not delay essential actions for effects, stop offscreen animations, and avoid full-screen celebration during time-sensitive bidding. Use effects to acknowledge outcomes and explain relationships. Official reference: [Flutter animations](https://docs.flutter.dev/ui/animations).

## Visual foundations and asset provenance

| Token | Value | Status |
|---|---|---|
| Primary plum | `#93117E` | Extracted from the live store logo and CSS |
| Soft plum surface | `#F9F1F7` | Extracted store token |
| Lemon accent | `#F3D018` | Extracted store token; restrained rewards/offer emphasis |
| Primary text | `#232323` | Extracted store neutral |
| Secondary text | `#6A6A6A` | Extracted store neutral |
| Success | `#048259` | Extracted store status token |
| Attention/error | `#C21141` | Extracted store status token |
| Font foundation | System sans-serif stack | Observed store foundation; official native typography remains to be confirmed |

Keep the official logo unchanged, preserve its aspect ratio and clear space, and separate the Plus membership suffix from the logo asset. The preview uses real vidaXL website/product imagery; provenance is recorded in `asset-sources.json`. Product prices, membership tiers and missions are sample data. The gallery update includes verified supplier angle/detail images, with higher-resolution chair and bench media. Continue to source production media from the approved catalogue.

Layout adaptation: a phone-first canvas, 16–24 px edge spacing, restrained 12–18 px cards, consistent image ratios and clear type hierarchy. Major touch actions should have at least roughly 44–48 logical pixels of comfortable area. Large text settings, accessible labels, contrast, safe areas and keyboard behavior require native-device review. Do not rely on color or motion alone for auction state.

No official brand manual or editable native design system has been supplied. This handoff follows verified website assets/tokens and explicitly labels newly designed components as adaptations requiring approval.

## Flutter implementation architecture

Use feature modules with views, view-model/state, domain models and repositories. Keep branding, motion, error handling and routing shared. Treat widgets as presentation, not as the owner of commerce/auction rules.

| Layer | Responsibility |
|---|---|
| App shell | Firebase initialization, session resolution, route graph, deep links, tab state, error boundaries |
| Shared design | Brand tokens, typography, product cards, buttons, fields, sheets, status labels, accessibility and motion |
| Feature state | Immutable Home/Shop/Auction/Rewards/Chat/Inbox state; granular updates |
| Repositories | Auth, Catalogue, Recommendations, Wishlist, Auctions, Loyalty, Orders, Chat and Notifications |
| Adapters | Firebase services and existing SFCC/Yotpo/Flowbox/Zendesk interfaces; isolated deterministic POC adapters |

Provide one active stream subscription per necessary screen/state slice; cancel when disposed. Use cached catalogue/last known state for browsing, while requiring an authoritative response before bid acceptance, reward claim or redemption. Offline caching must not convert an unconfirmed bid into a successful bid.

Use testable repository interfaces so the prototype rules and real services can be swapped without changing screen widgets. The team can apply its established state-management/router packages; pin dependencies in the actual project and avoid copying unverified versions from a design specification. Official reference: [Flutter architecture guide](https://docs.flutter.dev/app-architecture/guide).

## Firebase responsibilities and integration boundary

Firebase is the proposed mobile application backend/orchestration layer. It does not automatically replace the existing client systems identified in the deck.

| Service | Proposed responsibility |
|---|---|
| Firebase Authentication | Registration, sign-in, session, verification and reset; establish mapping to the client’s commerce identity |
| Cloud Firestore | User preferences, wishlist, inbox, recommendation read models, conversations where retention is required, and POC auction state |
| Cloud Functions / trusted server layer | Validated mutations, integration adapters, event processing, eligibility, deduplication and notification fan-out |
| Firebase Cloud Messaging | User-permitted push delivery with typed deep-link payloads |
| Cloud Storage | Moderated UGC uploads and authorized image access; product images remain sourced from approved media |
| App Check | Protect supported mobile/backend request paths; authentication/authorization are still separately enforced |
| Firebase AI Logic / selected server AI provider | Live grounded assistant; provider and cost/region requirements must be confirmed |

SFCC remains the intended source for product/order/commerce and the existing auction system until the client approves otherwise. Yotpo remains the intended loyalty authority; Zendesk the support authority; Flowbox/SFCC the UGC integration. A sandbox POC can implement isolated Firebase auction/loyalty records, clearly separate from real commerce.

**Auth flow:** listen to authenticated session changes, bind user-scoped repositories, and route to the pending intended destination. Verification gating must follow the approved policy. On sign-out, dispose private streams, clear private caches and conversation context, and remove server-registered push-token association as appropriate. Never store passwords in Firestore, analytics or custom preferences. Official reference: [Firebase Auth for Flutter](https://firebase.google.com/docs/auth/flutter/start).

**FCM:** implement foreground handling and both background/terminated-open paths. A message identifies `eventId`, `type`, `targetId`, `market`, and optional `expiresAt`; no card/payment/private bid data. Resolve auth, fetch current state and validate before navigating. Official reference: [Receive FCM in Flutter](https://firebase.google.com/docs/cloud-messaging/flutter/receive-messages).

## Suggested Firestore read models and ownership

| Path / model | Client access | Authoritative write |
|---|---|---|
| `users/{uid}` | Owner reads/approved profile-field edits | Verified profile or integration service for entitlement fields |
| `users/{uid}/preferences` | Owner only | Owner for preference fields |
| `users/{uid}/wishlist/{productKey}` | Owner only | Owner for selected product and validated snapshot metadata |
| `users/{uid}/events/{eventId}` | Owner submits allowed intent schema; retention defined | Server validates / aggregates |
| `users/{uid}/inbox/{eventId}` | Owner reads; approved `readAt` update only | Server creates event and target |
| `users/{uid}/privateBids/{auctionId}` | Owner reads own maximum | Trusted auction service writes |
| `users/{uid}/loyaltyLedger/{entryId}` | Owner reads | Trusted loyalty integration writes |
| `products/{productKey}` | Approved catalogue read | Catalogue integration writes prices, stock and media |
| `auctions/{auctionId}` | Approved public read model without private maxima | Trusted auction service writes bid status and server end time |
| `recommendations/{uid}` | Owner read | Trusted ranking service / approved function writes |
| `conversations/{uid}/sessions/{sessionId}` | Owner only, with size/retention bounds | Validated conversation endpoint or bounded allowed client writes |

These are proposed logical models, not deployed Firestore rules. Rules must allowlist editable fields and prevent clients from assigning balances, tiers, prices, successful bids or other users’ data. Functions using privileged server SDKs must independently authorize every request. Test ownership boundaries and mutation allowlists with emulators before enabling the backend. References: [Firestore rule conditions](https://firebase.google.com/docs/firestore/security/rules-conditions), [App Check Flutter](https://firebase.google.com/docs/app-check/flutter/default-providers).

## Server mutation contracts

| Operation | Request | Successful result | Failure behavior |
|---|---|---|---|
| `setMaximumBid` | Auction ID, maximum in minor units, request ID, expected version | Accepted maximum, public bid, version, server end time | Stable error code; current version/end time; no optimistic success |
| `claimMission` | Mission ID and request ID | Ledger entry, available points, progress | Ineligible/already claimed returned safely |
| `redeemReward` | Reward ID and request ID | Voucher entitlement, ledger and balance | Insufficient points / incompatible offer; no double debit |
| `submitUGC` | Authorized storage reference, caption and consent version | Pending-review submission ID | No immediate points credit |
| `getHomeFeed` | Auth/guest scope, market, bounded cursor | Ranked IDs, reason codes, module priorities | Curated fallback; never fabricate stock or pricing |
| `setNotificationRead` | Owner event ID | Read timestamp | Reject cross-user mutation |
| `chatTool` | Allowlisted tool name and bounded arguments | Authorized structured domain data | Missing permission, no match or service unavailable |

Use integer minor-unit money values and explicit currencies in the native/backend contract. Price rules, bids and entitlement checks belong on the trusted side. Request IDs must survive retry and prevent duplicate orders/claims/vouchers. Server time decides closing, not the handset clock.

For an isolated Firestore auction POC, a trusted server transaction must re-read state, validate end time and increment/max rules, update public and private state atomically, and handle contention/retries. The real integration must instead follow the actual auction engine’s authoritative API. Reference: [Firestore transaction contention and isolation](https://firebase.google.com/docs/firestore/transaction-data-contention).

## AI conversation contract

The current preview is deterministic conversation simulation. For the Flutter implementation, Firebase AI Logic has a Dart client SDK; model/provider selection and tool design require project configuration. Reference: [Firebase AI Logic](https://firebase.google.com/docs/ai-logic).

Suggested tools: catalogue search, exact product detail, authorized order status, loyalty summary, auction explanation/status and support route. Function calling describes requests for tools; the application/backend still executes and authorizes them. The model must not be allowed to trust its own proposed price or entitlement. Reference: [Firebase AI Logic function calling](https://firebase.google.com/docs/ai-logic/function-calling).

Ground each product recommendation in returned catalogue IDs and current prices. For missing measurements or policy, say what is missing and link the authoritative product/support page. Keep follow-up intent (room, budget, style) in conversation context; do not silently repurpose private support chat as marketing history. In the production design, bids, reward redemption and purchases require an explicit user confirmation in the relevant transactional UI. Chat cannot make these commitments autonomously.

Define request timeouts, cancel/retry, token/output limits and cost limits. A failed assistant should leave browsing and human support available. Account-specific tools must derive identity from the authenticated request, not a model-generated UID.

## Acceptance and delivery checks

- All requested screen families are reachable and connected; splash/session behavior and original-intent sign-in return work.
- Search/view/wishlist activity changes the correct Home recommendations; cold-start and personalization-off remain useful.
- Wishlist price-drop and relevant auction notifications deduplicate, respect preferences and open the correct target.
- Pending versus available points, tier progress, claims and voucher balances stay consistent; UI refresh cannot grant a reward twice.
- AI outputs use existing products, respect budget/context and provide safe no-match and support routes.
- Relevant screens have loading, empty, offline, validation and service-failure states in the native build.
- Motion does not block input, repeat unnecessarily, obscure auction state or ignore reduced-motion settings.
- Verify phones at narrow widths, large text settings, keyboard-open forms, screen-reader labels and actual touch targets.
- Native backend acceptance additionally requires emulator rules tests, concurrent-bid/retry tests, end-time tests and foreground/background/terminated FCM tests.

The updated browser code has syntax, state and route-template checks. Supported browser visual QA is unavailable in this environment; device visual/touch review remains outstanding. No actual Firebase identity, Firestore write, FCM delivery or live AI inference is demonstrated by this link.

## Concrete next dependencies for the Flutter team

Approved brand manual and high-resolution product media; Firebase project and app registrations; target platforms and package versions; client identity mapping; sandbox API contracts for SFCC/auctions/Yotpo/Zendesk/Flowbox; approved tier/mission/alert rules; chat provider and knowledge sources; target market/currency; device test matrix.
