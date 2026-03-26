# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
flutter pub get          # Install dependencies
flutter run              # Run the app
flutter test             # Run all tests
flutter test test/widget_test.dart  # Run a single test file
flutter analyze          # Lint/static analysis
flutter build apk        # Build Android APK
```

## Architecture

This is a Flutter real-time chat app backed entirely by Firebase. There is no external state management library — UI state uses `StatefulWidget` with `StreamBuilder` for reactive updates.

### Screen Flow

`main.dart` uses a `StreamBuilder` on `FirebaseAuth.instance.authStateChanges()` to route between three screens:
- **SplashScreen** — shown while auth state is loading
- **AuthScreen** — login / sign-up toggle with image upload on sign-up
- **ChatScreen** — main chat UI with FCM notifications

### Data Model

Two Firestore collections:
- `users` — `{ username, email, image_url }`
- `chat` — `{ text, createdAt, userId, username, userImage }`

### Key Patterns

- **Real-time messages**: `chat_messages.dart` streams from the `chat` Firestore collection ordered by timestamp (descending), rendered via `StreamBuilder`
- **Consecutive message grouping**: Messages from the same author in sequence suppress the avatar/username header for all but the first
- **Auth + profile**: Sign-up uploads a camera image to Firebase Storage, then writes to Firestore `users` before `createUserWithEmailAndPassword`
- **FCM**: `ChatScreen` requests notification permission, subscribes to the `'chat'` topic, and logs the FCM token on init

### Firebase Project

Project ID: `flutter-chat-app-37281`
Storage bucket: `flutter-chat-app-37281.appspot.com`
`firebase_options.dart` is auto-generated — do not edit manually; use `flutterfire configure` to regenerate.

## CI

`.github/workflows/hello-world.yml` runs on PRs: installs Flutter, runs `flutter pub get`, then `flutter test`. There is currently one smoke test verifying `SplashScreen` renders with "Loading..." text.
