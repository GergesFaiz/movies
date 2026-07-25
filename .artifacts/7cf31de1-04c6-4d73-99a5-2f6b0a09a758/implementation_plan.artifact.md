# Project Review & Improvement Plan

Based on the initial review of the project, here is an analysis of the current state and a plan for improvements.

## Current State Analysis

### Strengths
- **Architecture**: Good adoption of Clean Architecture (Domain, Data, Presentation layers).
- **State Management**: Uses `flutter_bloc` which is scalable and well-integrated.
- **Dependency Injection**: `get_it` is set up and used for most components.
- **Modern Stack**: Uses `Dio`, `Retrofit`, `Firebase`, `ScreenUtil`, and `go_router` (partially).

### Weaknesses & Gaps
- **Project Structure**: Presence of redundant directories (`lib/tabs`) and broken ones (`lib/{core...`).
- **Inconsistent Routing**: Using `onGenerateRoute` despite having `go_router` in `pubspec.yaml`. No auth-aware routing logic.
- **Missing Features**: Empty widget files (`movie_screenshots.dart`) and incomplete localization in some places.
- **Logging**: Using basic `LogInterceptor` instead of the included `pretty_dio_logger`.
- **Testing**: Very few unit tests and no widget or integration tests.
- **Performance**: Potential redundant rebuilds in some Blocs.

---

## Proposed Changes

### 1. Cleanup & Organization
- [DELETE] `lib/tabs/` - Redundant code replaced by `lib/features/`.
- [DELETE] `lib/{core...` - Broken directory from previous operations.
- [DELETE] `lib/api/` - (If any remains) should be fully moved to `lib/core/network` or features.

### 2. Networking & Logging
- [MODIFY] `lib/core/network/dio_factory.dart`: Replace `LogInterceptor` with `PrettyDioLogger` for better debugging output.

### 3. Navigation & Auth Flow
- [NEW] `lib/features/auth/presentation/pages/splash_screen.dart`: A splash screen to check if the user is logged in or if they've seen the onboarding.
- [MODIFY] `lib/core/router/app_router.dart`: Add the Splash screen and ensure routes are properly protected.
- [MODIFY] `lib/main.dart`: Set the Splash screen as the initial route.

### 4. UI/UX Polishing
- [MODIFY] `lib/features/movies/presentation/pages/movie_details_page.dart`: Implement or remove the screenshots section.
- [FIX] `lib/core/widgets/movie_screenshots.dart`: Either implement a proper screenshots gallery or remove the file.

### 5. Dependency Injection Refinement
- Ensure all services (like `SharedPreferences` for onboarding status) are registered in `injection.dart`.

---

## Verification Plan

### Automated Tests
- Run existing tests: `flutter test`
- Add unit tests for `AuthCubit` and `MoviesBloc`.

### Manual Verification
- Verify the onboarding -> login/register -> home flow works seamlessly.
- Check the log output in the console to see the improved network logging.
- Verify that the `lib/tabs` directory removal doesn't break anything.
