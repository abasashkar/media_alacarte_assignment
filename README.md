# Ad Campaign Performance Dashboard

A production-ready Flutter application built for the Media Alacarte Mobile App
Developer coding challenge. It visualises ad-campaign performance across four
screens: a campaign list, a campaign detail view with an ML CTR forecast, an
aggregated spend summary, and a real-time anomaly alerts feed.

## Features

- **Campaign List** — all campaigns with spend-vs-budget progress, impressions,
  clicks and CTR; live search, status filter chips (All / Active / Paused /
  Ended) and pull-to-refresh.
- **Campaign Detail & ML Forecast** — full campaign metrics plus a line chart of
  30-day historical CTR (solid) and a 7-day forecast (dashed) with a confidence
  band, and a budget recommendation card from the ML endpoint.
- **Spend Summary** — total-spend KPI, spend-by-channel donut chart, top-3
  campaigns by CTR, and a 7 / 14 / 30-day range selector that re-fetches.
- **Anomaly Alerts** — polls live metrics every 30 seconds, runs anomaly
  detection, renders colour-coded alert cards (red = spend spike, amber = CTR
  drop) and fires a local push notification for each newly detected anomaly.
- Material 3 theming with light/dark modes (dark by default), responsive
  layouts, reusable widgets, and explicit loading / empty / error states.

## Architecture

Feature-first, three-layer (presentation / domain / data) architecture.

```
Presentation (Pages + Widgets)
        |  events / states
      Bloc  (flutter_bloc)
        |  Either<Failure, T>
   Repository (abstract, domain)
        |
 RepositoryImpl (data)  --->  RemoteDataSource (Dio)
                         \-->  LocalDataSource (SharedPreferences cache)
```

- **Presentation** depends only on Blocs; no business logic in `build()`.
- **Domain** holds abstract repository contracts (pure Dart).
- **Data** holds `fromJson` models, Dio data sources and repository
  implementations that wrap calls in `try/catch` and map errors to typed
  `Failure`s (`dartz` `Either`).
- **Dependency injection** via `get_it` in `lib/app/di/service_locator.dart`.

### Folder structure

```
lib/
  main.dart
  app/                 # app root + DI
  core/                # constants, network, error, theme, router, utils, widgets, services
  features/
    campaigns/         # Screens 1 & 2  (data / domain / presentation)
    spend_summary/     # Screen 3
    anomalies/         # Screen 4
    profile/           # settings + theme toggle
    shell/             # bottom-nav scaffold
test/                  # repository + bloc unit tests
```

## Tech stack

| Concern            | Package |
|--------------------|---------|
| State management   | `flutter_bloc`, `equatable` |
| Networking         | `dio` |
| Routing            | `go_router` (`StatefulShellRoute`) |
| DI                 | `get_it` |
| Charts             | `fl_chart` |
| Notifications      | `flutter_local_notifications` |
| Error handling     | `dartz` |
| Formatting         | `intl` |
| Offline cache      | `shared_preferences` |
| Fonts              | `google_fonts` |
| Testing            | `bloc_test`, `mocktail` |

## API

Base URL: `https://e5eb0d84-2b7e-4c32-98b9-233668b4e189.mock.pstmn.io/v1`

| Method | Endpoint | Purpose |
|--------|----------|---------|
| GET  | `/campaigns` | List all campaigns |
| GET  | `/campaigns/:id` | Campaign detail |
| GET  | `/campaigns/:id/history` | 30-day CTR history |
| GET  | `/campaigns/summary` | Aggregated spend |
| GET  | `/campaigns/metrics/live` | Latest metrics snapshot |
| POST | `/forecast/ctr` | 7-day CTR forecast |
| POST | `/anomaly/detect` | Anomaly flags |

## Getting started

Requirements: Flutter (stable, tested on 3.27.x / Dart 3.6).

```bash
flutter pub get
flutter run
```

### Run tests

```bash
flutter test
```

### Build a release APK

```bash
flutter build apk --release
# output: build/app/outputs/flutter-apk/app-release.apk
```

## Assumptions & decisions

- Dark theme is the default to match the Figma; a light theme and a toggle
  (persisted via `shared_preferences`) are provided on the Profile screen.
- The two base URLs in the spec are identical, so a single `DioClient` serves
  every endpoint.
- The campaign detail screen re-fetches by `id` (rather than passing the object)
  so it survives deep links and refresh.
- The forecast endpoint already returns a recommendation, which is shown
  directly instead of being re-derived on the client.
- Currency is displayed as SAR, per the designs.
- The campaign list is cached locally; if a refresh fails while a cache exists,
  the cached list is shown so the app remains usable offline.
- Anomaly notifications are primed on first load (no notification spam for
  pre-existing anomalies) and only fire for anomaly IDs seen for the first time.
