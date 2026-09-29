# Movies 🎬

A Flutter app for discovering movies: browse by genre, search, see details,
cast and screenshots, watch trailers, and keep a personal watch list and
viewing history. Available in **English** and **Arabic** (RTL).

## Features

- **Onboarding** – shown once on the first launch.
- **Authentication** (Firebase Auth) – login, register with avatar / name /
  phone, forgot password.
- **Home** – carousel of the latest movies (the background follows the
  centred poster) and a random genre row with **See More** → opens Browse
  filtered by that genre.
- **Search** – debounced search; only the latest query's results are shown.
- **Browse** – top rated movies filtered by genre chips.
- **Movie details** – rating, runtime, likes, summary, screenshots, cast,
  genres, similar movies, and **Watch** → opens the YouTube trailer.
- **Watch list & history** (Cloud Firestore) – bookmark a movie from its
  details page; every opened movie is added to the history (most recent first).
- **Profile** – live watch list / history counters, edit name, phone and
  avatar, reset password, delete account (with confirmation), logout.
- **Localization** – every screen is translated; the chosen language is
  remembered between launches.

## Architecture

Clean Architecture per feature, with BLoC/Cubit for state management and
`get_it` for dependency injection.

```
lib/
├── core/
│   ├── di/            # get_it registrations (injection.dart)
│   ├── error/         # Failure types
│   ├── l10n/          # ARB files + generated AppLocalizations
│   ├── network/       # Dio + Retrofit ApiClient
│   ├── router/        # AppRoutes / AppRouter (+ initial route logic)
│   ├── storage/       # AppPreferences (shared_preferences)
│   ├── usecases/      # UseCase base class
│   ├── utils/         # colors, styles, assets, validators, helpers
│   └── widgets/       # shared widgets
└── features/
    ├── auth/
    │   ├── data/          # AuthRemoteDataSource (Firebase), UserModel, repo impl
    │   ├── domain/        # UserEntity, AuthRepository
    │   └── presentation/  # AuthCubit, ProfileCubit, AppLanguageCubit, pages
    └── movies/
        ├── data/          # Movies API + user movies (Firestore) data sources, models
        ├── domain/        # entities, repositories, use cases
        └── presentation/  # MoviesBloc, SearchBloc, MovieDetailsBloc,
                           # UserMoviesCubit, pages & widgets
```

Presentation code never talks to Firebase or Dio directly: pages use
blocs/cubits → use cases / repositories → data sources.

## Getting started

Requirements: Flutter **3.41+** (Dart 3.11).

```bash
flutter pub get
flutter run
```

Firebase is already configured for Android and iOS
(`lib/core/utils/firebase_files/firebase_options.dart`,
`android/app/google-services.json`). To use your own project run
`flutterfire configure`.

### Code generation

```bash
# Localizations (after editing lib/core/l10n/*.arb)
flutter gen-l10n

# JSON models / Retrofit client (after editing models or ApiClient)
dart run build_runner build --delete-conflicting-outputs
```

### Checks

```bash
flutter analyze
flutter test
```

## Demo

https://github.com/user-attachments/assets/f1c9fb6a-7fb4-4dc6-9b3e-c519e4324bf3

Feature 1 – Part 1

https://github.com/user-attachments/assets/6f3759b1-282e-4650-82bb-015199f8d8b1

Feature 1 – Part 2

https://github.com/user-attachments/assets/1d03c645-1103-4589-a749-c57e49963bd1

Phase 2 – Part 1

https://github.com/user-attachments/assets/39076c82-d32d-454a-b42e-07b3347c0f57

Phase 2 – Part 2

https://github.com/user-attachments/assets/e9a4462d-21a3-403c-b903-51fcd67b6d

Phase – Part 1

https://github.com/user-attachments/assets/76910243-cb82-4fab-adf1-f0cd97fda323

https://github.com/user-attachments/assets/2d221d82-9a7d-4bd9-aa3c-d0471555ff46

https://github.com/user-attachments/assets/c9ee301b-42d8-49ed-ae77-dfc647828d77

https://github.com/user-attachments/assets/f2c0bbbd-b297-4f12-bb13-1b96e6f2fb7d
