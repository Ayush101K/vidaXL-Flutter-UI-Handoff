# vidaXL Flutter UI handoff — start here

This is an actual Dart/Flutter **reusable UI package**, not the full app, a conversion of the HTML prototype, or an installed Firebase backend. It supplies Splash, product gallery, press feedback, animated points, reward celebration, verified brand colors and official media. The developer still builds/integrates Login, Home, Auctions, Rewards, Chat, Notifications and Firebase services using the supplied specification.

## How Rajesh should hand it over

Send the developer the ZIP and the prototype URL. Ask the developer to unpack it, read this file and `FLUTTER-FIREBASE-HANDOFF.md`, integrate the package into the existing Flutter project, then run formatting, analysis and widget tests before connecting backend services. Native screenshots, a device walkthrough and the Firebase integration status should be returned for design review. The current private prototype link is for the owner; it does not automatically grant your developer access.

The ZIP contains this package, the complete UX/architecture specification, image provenance, browser reference and motion/gallery notes. No passwords, API keys, Firebase secrets or Git credentials are included.

## Integrate into an existing Flutter project

1. Copy `flutter_ui_handoff` to `packages/vidaxl_ui_handoff` in the developer's app.
2. Add a local dependency to the app's `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  vidaxl_ui_handoff:
    path: packages/vidaxl_ui_handoff
```

3. In the application root run `flutter pub get`.
4. Import `package:vidaxl_ui_handoff/vidaxl_ui_handoff.dart`.
5. In the package directory run `dart format lib test`, `flutter analyze` and `flutter test`. Then run the host app's checks.

Flutter/Dart SDKs are unavailable in the authoring environment, so these Dart components have **not been compiled or tested here**. Widget tests are supplied for the developer to run. Confirm compatibility with the team's selected Flutter version; the package declares Dart 3.3 or newer.

## Splash example

```dart
VidaSplash(
  ready: sessionInitializationComplete,
  onContinue: () {
    // Route using the resolved Firebase session and pending deep link.
    // Do not add an artificial delay to authentication.
    openResolvedDestination();
  },
)
```

The package uses the unmodified logo artwork exported to transparent PNG, and official bedroom/garden imagery. Production should keep a native launch screen separate from this interactive intro. Replayable intro effects belong in first-use/presentation mode; returning users should not be forced through a long sequence.

## Gallery example

```dart
VidaProductGallery(
  productId: 'sofa',
  productName: 'Kids’ sofa bed',
  images: const [
    AssetImage('assets/sofa-2.jpg', package: 'vidaxl_ui_handoff'),
    AssetImage('assets/sofa-3.jpg', package: 'vidaxl_ui_handoff'),
  ],
  labels: const ['Angled product view', 'Front view'],
)
```

Use approved `NetworkImage` providers from the catalogue backend in the actual app. Keep images and labels aligned. Never show another product or variant as an alternative angle. Match the listing image Hero tag to `${productId}_image_0` when using the first gallery page as the detail transition destination.

The gallery supports paging, thumbnail selection, image count, accessible labels and a full-screen `InteractiveViewer` for pinch zoom/pan. The browser reference has an enlarged sheet with explicit zoom buttons; the native component uses platform touch gestures.

## Feedback and reward examples

```dart
VidaPressFeedback(
  label: 'Save product',
  haptic: true,
  onTap: saveSelectedProduct,
  child: yourWishlistButton,
)

VidaAnimatedPoints(points: availablePoints)

VidaRewardMoment(
  points: confirmedAward,
  onContinue: closeRewardSheet,
)
```

Trigger reward celebration **after** the trusted backend confirms the award, once per successful event. These components do not create ledger entries, debit points, place bids or authenticate users. Effects honor reduced-motion settings.

## Backend ownership

Follow the separate handoff for Auth, user-scoped Firestore data, trusted bid/loyalty functions, FCM deep links and grounded AI. Map the client’s SFCC/Yotpo/auction identity contracts before assuming Firebase replaces them. Add the team's real Firebase configuration using its normal environment-specific setup; none is bundled.

## Definition of developer completion

- Format/analyze/test the package and host app.
- Implement remaining screen state and backend contracts.
- Test small screens, large text, image load failure, keyboard behavior and reduced motion.
- Test Firebase rules, duplicate mutations, bid concurrency, notification opening and AI grounding.
- Confirm approved brand guidelines and product media.
- Provide Android/iOS builds and a reviewed device walkthrough as agreed with the team.
