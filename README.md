# AdMob Flutter Test

This is a minimal Android Flutter project for testing Google AdMob integration.

## What it tests

- Google Mobile Ads Flutter SDK initialization
- Banner test ad
- Interstitial test ad

The project uses Google's official Android sample/test App ID and test ad unit IDs. These are for development/testing only.

## Build

From a Flutter environment:

```bash
flutter pub get
flutter build apk --debug
```

For an AAB:

```bash
flutter build appbundle --release
```

Before publishing, replace the sample App ID and ad unit IDs with your own AdMob IDs and configure release signing.

## Important

Google recommends using test ads during development. Do not click production ads while testing.
