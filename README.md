# Ad Campaign Dashboard

Flutter mobile app for monitoring ad campaign performance — campaigns, spend summary, real-time anomaly alerts, and profile settings. Supports light and dark mode.

## How to run

**Requirements:** Flutter SDK (latest stable channel)

```bash
flutter pub get
flutter run
```

**Run tests:**

```bash
flutter test
```

## Architecture

Feature-first, three-layer architecture:

```
Presentation (Pages + Widgets)
        │  events / states
      Bloc  (flutter_bloc)
        │  Either<Failure, T>
   Repository (abstract, domain)
        │
 RepositoryImpl (data)  ──►  RemoteDataSource (Dio)
                         └►  LocalDataSource (SharedPreferences cache)
```

| Layer | Responsibility |
|-------|----------------|
| **Presentation** | Pages, widgets, Blocs — no business logic in `build()` |
| **Domain** | Abstract repository contracts (pure Dart) |
| **Data** | API models with `fromJson()`, Dio data sources, repository implementations |

**Stack:** `flutter_bloc` · `dio` · `go_router` · `fl_chart` · `flutter_local_notifications` · `get_it` · `shared_preferences` · `dartz`

## Technical Requirements

### Mandatory

| Requirement | Implementation |
|-------------|----------------|
| Flutter SDK — latest stable | Flutter (stable channel) |
| Dio or http for all API calls | `dio` |
| Bloc or Riverpod for state management | `flutter_bloc` (no `setState` beyond widget level) |
| fl_chart or Syncfusion for charts | `fl_chart` |
| Named route navigation | `go_router` named routes between all screens |
| Anomaly push alerts | `flutter_local_notifications` |

### Code Quality

- No business logic inside Widget `build()` methods
- All API models are separate Dart classes with `fromJson()` factory constructors
- Every API call wrapped in `try/catch` with user-facing error messages
- Loading indicators on every async operation

### Bonus

- Offline caching of last fetched campaign list (`SharedPreferences`)
- Animated transitions between list and detail screens
- Unit tests for repository and Bloc classes
- Dark mode support (toggle on Profile screen)

## Assumptions

- Currency displayed as SAR
- Dark theme available; light/dark toggle persisted locally
- Anomaly feed polls the Ads API every 30 seconds
- Forecast and anomaly detection use dedicated API endpoints
- Cached campaign list is shown if a refresh fails while offline

## Screenshots

<table>
  <tr>
    <td align="center"><img src="screenshots/01_campaign_list.png" width="260" alt="Campaign List"/><br/><sub>Campaign List</sub></td>
    <td align="center"><img src="screenshots/05_campaign_list_paused.png" width="260" alt="Campaign List Paused"/><br/><sub>Paused filter</sub></td>
    <td align="center"><img src="screenshots/06_campaign_list_ended.png" width="260" alt="Campaign List Ended"/><br/><sub>Ended filter</sub></td>
  </tr>
  <tr>
    <td align="center"><img src="screenshots/07_campaign_detail.png" width="260" alt="Campaign Detail"/><br/><sub>Campaign Detail</sub></td>
    <td align="center"><img src="screenshots/08_campaign_detail_forecast.png" width="260" alt="CTR Forecast"/><br/><sub>CTR history & forecast</sub></td>
    <td align="center"><img src="screenshots/09_campaign_detail_audience.png" width="260" alt="Audience"/><br/><sub>Budget & audience</sub></td>
  </tr>
  <tr>
    <td align="center"><img src="screenshots/02_spend_summary.png" width="260" alt="Spend Summary"/><br/><sub>Spend Summary</sub></td>
    <td align="center"><img src="screenshots/03_alerts.png" width="260" alt="Alerts"/><br/><sub>Anomaly Alerts</sub></td>
    <td align="center"><img src="screenshots/04_profile.png" width="260" alt="Profile"/><br/><sub>Profile</sub></td>
  </tr>
</table>
