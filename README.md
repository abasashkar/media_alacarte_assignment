# 📊 Ad Campaign Dashboard

A modern Flutter application for monitoring and analyzing digital advertising campaigns. The app provides campaign management, spend analytics, anomaly detection, forecasting, and profile management with support for both Light and Dark themes.

---

## ✨ Features

- 📢 Campaign listing with Active, Paused and Ended filters
- 🔍 Campaign search
- 📈 Campaign performance metrics
- 💰 Spend Summary dashboard
- 🥧 Spend distribution by marketing channel
- 📊 Top performing campaigns by CTR
- 📉 CTR history & forecast visualization
- 🚨 Real-time anomaly alerts
- 🔔 Local notifications
- 👤 Profile & Theme Settings
- 🌙 Light / Dark Mode
- 💾 Offline campaign caching
- 🔄 Pull-to-refresh
- ✨ Smooth page animations

---

# 📱 Screenshots

<table>
  <tr>
    <td align="center"><img src="screenshots/01_campaign_list.png" width="260"/><br/><sub>Campaign List</sub></td>
    <td align="center"><img src="screenshots/05_campaign_list_paused.png" width="260"/><br/><sub>Paused Campaigns</sub></td>
    <td align="center"><img src="screenshots/06_campaign_list_ended.png" width="260"/><br/><sub>Ended Campaigns</sub></td>
  </tr>

  <tr>
    <td align="center"><img src="screenshots/07_campaign_detail.png" width="260"/><br/><sub>Campaign Details</sub></td>
    <td align="center"><img src="screenshots/08_campaign_detail_forecast.png" width="260"/><br/><sub>CTR Forecast</sub></td>
    <td align="center"><img src="screenshots/09_campaign_detail_audience.png" width="260"/><br/><sub>Audience & Budget</sub></td>
  </tr>

  <tr>
    <td align="center"><img src="screenshots/02_spend_summary.png" width="260"/><br/><sub>Spend Summary</sub></td>
    <td align="center"><img src="screenshots/03_alerts.png" width="260"/><br/><sub>Anomaly Alerts</sub></td>
    <td align="center"><img src="screenshots/04_profile.png" width="260"/><br/><sub>Profile</sub></td>
  </tr>
</table>

---

# Apk Link
https://drive.google.com/file/d/18miO5InsijPxI1v1Jod4_gKlvkjg9S-d/view?usp=sharing


# 🏗 Architecture

The project follows a **Feature-First Clean Architecture**.

```
lib
│
├── app
│   ├── di
│   └── app.dart
│
├── core
│   ├── constants
│   ├── network
│   ├── router
│   ├── services
│   ├── theme
│   ├── utils
│   └── widgets
│
└── features
    ├── campaigns
    │   ├── data
    │   ├── domain
    │   └── presentation
    │
    ├── spend_summary
    │   ├── data
    │   ├── domain
    │   └── presentation
    │
    ├── anomalies
    │   ├── data
    │   ├── domain
    │   └── presentation
    │
    ├── profile
    │
    └── shell
```

Application flow

```
Presentation
      │
Flutter Bloc
      │
Repository
      │
Remote Data Source (Dio)
      │
REST API

      +
Local Cache (SharedPreferences)
```

---

# 🛠 Tech Stack

| Technology | Usage |
|------------|------|
| Flutter | Cross-platform Mobile Development |
| flutter_bloc | State Management |
| Dio | REST API Client |
| go_router | Navigation |
| fl_chart | Analytics Charts |
| flutter_local_notifications | Local Notifications |
| shared_preferences | Offline Cache |
| get_it | Dependency Injection |
| dartz | Functional Programming |

---

# 📋 Technical Requirements

### Mandatory

- ✅ Flutter (Latest Stable)
- ✅ Dio for Networking
- ✅ flutter_bloc State Management
- ✅ go_router Navigation
- ✅ fl_chart
- ✅ Local Notifications

### Code Quality

- Feature-first architecture
- Repository Pattern
- Dependency Injection
- API Models using `fromJson()`
- Error handling using `try/catch`
- Loading indicators for async operations
- No business logic inside `build()`

### Bonus Features

- Offline caching
- Theme persistence
- Animated transitions
- Unit Tests
- Forecast Charts
- Pull-to-refresh

---

# 📂 Folder Structure

```
lib
│
├── app
│
├── core
│   ├── constants
│   ├── network
│   ├── router
│   ├── services
│   ├── theme
│   ├── utils
│   └── widgets
│
├── features
│
│   ├── campaigns
│   │
│   ├── anomalies
│   │
│   ├── spend_summary
│   │
│   ├── profile
│   │
│   └── shell
│
└── main.dart
```

---

# 🚀 Getting Started

### Clone Repository

```bash
git clone https://github.com/yourusername/ad_campaign_dashboard.git
```

Move inside project

```bash
cd ad_campaign_dashboard
```

Install packages

```bash
flutter pub get
```

Run the application

```bash
flutter run
```

---

# 🧪 Running Tests

```bash
flutter test
```

---

# 📌 Assumptions

- Currency displayed in **SAR**
- Local notifications simulate anomaly alerts
- Theme preference is persisted locally
- Campaign list is cached for offline viewing
- Forecast values are provided by the API
- API failures display cached data when available

---

# 👨‍💻 Author

**Abas Ashkar S A**

Flutter Developer

```
