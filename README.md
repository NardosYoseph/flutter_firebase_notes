# flutter_firebase_notes

Flutter notes app built with Firebase (Auth + Firestore), Riverpod, and GoRouter.

## Project setup steps

### 1) Prerequisites

- Flutter SDK (Dart SDK is bundled)
- Android Studio / VS Code + Flutter extensions

### 2) Install dependencies

From the repo root:

```bash
flutter pub get
```


### 3) Code generation (Riverpod / Freezed)

If you change any `@riverpod` providers or `freezed` models, run:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## How to run the app locally

### Android

```bash
flutter run
```

### Build APK (optional)

```bash
flutter build apk
```

## Database schema / collections / tables

The app uses **Cloud Firestore**.

### Collection: `notes`

Each document represents a single note.

- **id**: (document id)
- **userId**: `string` (Firebase Auth uid of the owner)
- **title**: `string`
- **content**: `string`
- **createdAt**: `timestamp`
- **updatedAt**: `timestamp`

### Firestore operations used

- Watch all notes for a user:
  - `notes.where('userId', isEqualTo: <uid>).orderBy('updatedAt', descending: true)`
- Fetch by id:
  - `notes.doc(noteId)` (then validate `userId` matches current user)
- Create:
  - `notes.add({...})`
- Update:
  - `notes.doc(noteId).update({...})`
- Delete:
  - `notes.doc(noteId).delete()`

## Authentication approach used

Authentication is done with **Firebase Authentication (Email/Password)**.

- Sign up: creates a Firebase Auth user.
- Sign in: authenticates the user.
- Sign out: clears session.
- Auth state is listened to via `authStateChanges()` and used to drive routing/UI.

## Assumptions / trade-offs

- **Offline caching**: Firestore provides client-side offline persistence on mobile by default.
  - Reads can be served from cache.
  - Writes (create/update/delete) are queued and synced when connectivity returns.

- **Connectivity indicator**: the app shows a snackbar when offline using `connectivity_plus`.
  - Connectivity does not guarantee internet access, but is good enough for UX feedback.

- **Client-side search**: note search is done locally in-memory (title/content) rather than via Firestore queries.
  - Fast and simple for small datasets.
  - Not suitable for very large note sets.


