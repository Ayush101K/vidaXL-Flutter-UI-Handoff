# Product gallery and motion refinement — 13 October 2026

## Changes implemented

- All four sample product-detail screens now have two distinct supplier images, swipe paging, thumbnails, a visible count and view caption, and enlarged viewing with zoom/pan controls.
- Sofa uses angle/front views; curtains use the full pair/fabric detail; chairs use the set/individual view; bench uses cushioned/frame views. The assets are tied to the same supplier product identifiers, not generated alternative angles.
- Bench and chair media were upgraded from small originals. Website asset provenance is recorded in `asset-sources.json`.
- Splash uses official lifestyle images, an animated composition, staged logo/copy reveal, brand spark accents, progress and a visible entry action. Browser presentation advances after approximately 3.4 seconds and can be skipped/replayed. Native production should follow session readiness and avoid a forced artificial wait.
- Wishlist actions emit a short plum/lemon particle acknowledgment. Rewards include an animated count and a celebration. Sections reveal as they enter view, and the collection feature gets a single light sweep.
- Product details keep their current member price and offer action available in a persistent action bar.
- A Motion tour is available from the desktop presentation controls and Demo controls so effects can be reviewed directly. A celebration preview does not award points.
- Unknown product deep links now show an unavailable state rather than silently substituting another product.

## UX decisions

Do not autoplay the product gallery, show unrelated photos, loop full-screen confetti, or delay bids for an animation. Motion should make cause and effect legible. Reduced-motion preferences disable decorative effects. Scroll reveals use feature detection; without support the content remains visible.

The browser is a UX reference. The Flutter package supplies real Dart components, but no full app/backend is claimed. See its README for the exact developer handover steps.

## Remaining review items

Browser/device visual verification is unavailable in this environment. Check touch gestures, zoom, the product action bar with safe areas, reduced motion, slow image loading and Splash at short screen heights. Flutter/Dart compilation and widget testing also require the developer's environment. An official brand manual remains to be supplied.
