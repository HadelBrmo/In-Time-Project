# ⏱️ In Time Platform
**A Time-Based Service Exchange Ecosystem**

<div align="center">

<img src="screenShots/logo.png" width="20%" />

[![Flutter](https://img.shields.io/badge/Flutter-3.x-blue.svg)](https://flutter.dev)
[![Architecture](https://img.shields.io/badge/Architecture-Clean%20Architecture-green.svg)]()
[![State Management](https://img.shields.io/badge/State%20Management-BLoC-orange.svg)]()
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)]()

</div>

---

## 📑 Table of Contents
1. [About the Project](#-about-the-project)
2. [Vision & Mission](#-vision--mission)
3. [Key Features](#-key-features)
4. [Technical Stack](#-technical-stack)
5. [Architecture & Design Patterns](#-architecture--design-patterns)
6. [Screenshots](#-screenshots)
7. [Project Structure](#-project-structure)
8. [Getting Started](#-getting-started)
9. [Testing & Quality Assurance](#-testing--quality-assurance)
10. [Team & University](#-team--university)
11. [License](#-license)

---

## 🎯 About the Project
**In Time** is an innovative digital platform that replaces traditional monetary transactions with **"Hours"** as a virtual currency. Designed to alleviate financial burdens and foster cooperative communities, the platform enables users to exchange skills and services directly. Whether it's programming lessons, home maintenance, or language tutoring, users negotiate time commitments and exchange services peer-to-peer.

---

## 👁️ Vision & Mission
- **Vision:** To become the leading platform for building cooperative communities where **time and skills** are the fundamental units of economic value.
- **Mission:** Empowering individuals to securely exchange services using **"Hours"** as an alternative to money, promoting mutual aid, skill-sharing, and sustainable community growth.

---

## ✨ Key Features
| Feature | Description |
|:---|:---|
| 🔄 **Time-Based Exchange** | Three economic models: `Barter`, `Paid`, and `Volunteer` services. |
| 💰 **Hour Wallet** | Users start with 2 initial hours. Earn more by providing services to others. |
| 🗺️ **Smart Map & Nearby** | GPS-powered service discovery with offline fallback & distance sorting. |
| 💬 **Real-Time Negotiation** | In-app WebSocket chat for scheduling, details, and file exchange. |
| 🏆 **Gamification & Leaderboard** | Badges, progress tracking, and monthly Top 5 rankings to boost engagement. |
| 📝 **Complaint & Dispute System** | Trackable tickets (`Pending`, `Processing`, `Resolved/Rejected`) with admin moderation. |
| ⭐ **Ratings & Threaded Comments** | Verified reviews and nested replies to build platform trust. |
| 👤 **Guest Mode & OCR Verification** | Browse freely without login. Register with OCR-based ID/Passport verification. |
| 📦 **Service Bundles** | Package multiple services into single "vouchers" for flexible redemption. |
| 🛡️ **Admin Control Panel** | Dispute resolution, service verification, leaderboard management, and user moderation. |

---

## 🛠️ Technical Stack
- **Framework:** Flutter 3.x
- **Language:** Dart
- **State Management:** BLoC Pattern + Dart Streams
- **Architecture:** Clean Architecture (Presentation → Domain → Data)
- **Dependency Injection:** `get_it` + `injectable`
- **Local Storage:** Isar/Hive, `flutter_secure_storage`
- **Networking:** Dio, WebSocket/Socket.io
- **Key Packages:** `google_mlkit_text_recognition`, `geolocator`, `google_maps_flutter`, `connectivity_plus`, `freezed`, `json_serializable`, `bloc_test`

---

## 🏗️ Architecture & Design Patterns
The project strictly follows **Clean Architecture** to ensure separation of concerns, high testability, and long-term maintainability.

| Pattern | Implementation | Benefit |
|:---|:---|:---|
| **Repository Pattern** | `features/*/data/repositories/` | Decouples Domain from Data sources. Enables mock testing. |
| **Strategy Pattern** | `core/strategies/` (Barter, Paid, Volunteer) | Isolates pricing/exchange logic. Easy to add new economic models. |
| **Decorator Pattern** | `core/network/decorators/` | Wraps network calls with Caching, Retry, and Logging without modifying core logic. |
| **Observer Pattern** | BLoC Streams + `BlocBuilder` | Pushes state changes to UI reactively. Eliminates unnecessary rebuilds. |
| **Factory / DI Pattern** | `injection_container.dart` | Centralized, type-safe dependency resolution. Simplifies lifecycle management. |

---

## 📸 Screenshots

<div align="center">

### 🚀 Onboarding & Authentication
<img src="screenShots/Onboarding & Authentication/splash screen.jpg" width="30%" />
<img src="screenShots/Onboarding & Authentication/onBoardingScreen1.png" width="30%" />
<img src="screenShots/Onboarding & Authentication/onBoardingScreen2.jpg" width="30%" />
<img src="screenShots/Onboarding & Authentication/onBoardingScreen3.png" width="30%" />
<img src="screenShots/Onboarding & Authentication/login.png" width="30%" />
<img src="screenShots/Onboarding & Authentication/create an account 1.png" width="30%" />
<img src="screenShots/Onboarding & Authentication/create an account 2.png" width="30%" />
<img src="screenShots/Onboarding & Authentication/create an account 3.png" width="30%" />

### 🏠 Home & Services
<img src="screenShots/Home & Services/home.png" width="30%" />
<img src="screenShots/Home & Services/service details.png" width="30%" />
<img src="screenShots/Home & Services/search.png" width="30%" />
<img src="screenShots/Home & Services/filter.png" width="30%" />
<img src="screenShots/Home & Services/drawer.png" width="30%" />

### 🛠️ Add Services
<img src="screenShots/Add Services/Adding a volunteer service.png" width="30%" />
<img src="screenShots/Add Services/Add an exchange service.png" width="30%" />
<img src="screenShots/Add Services/Add a paid service.png" width="30%" />
<img src="screenShots/Add Services/my hours.png" width="30%" />
<img src="screenShots/Add Services/comments.png" width="30%" />

### 💬 Chat & Groups
<img src="screenShots/Chat & Groups/chats.png" width="30%" />
<img src="screenShots/Chat & Groups/chat1.png" width="30%" />
<img src="screenShots/Chat & Groups/chat2.png" width="30%" />
<img src="screenShots/Chat & Groups/chats in a group.png" width="30%" />
<img src="screenShots/Chat & Groups/create a group.png" width="30%" />
<img src="screenShots/Chat & Groups/group details.png" width="30%" />
<img src="screenShots/Chat & Groups/Volunteer conversations.png" width="30%" />
<img src="screenShots/Chat & Groups/Confirmation of receipt.png" width="30%" />
<img src="screenShots/Chat & Groups/savedMessages.png" width="30%" />
<img src="screenShots/Chat & Groups/notifications.png" width="30%" />

### ⚙️ Settings & Additional Features
<img src="screenShots/ Settings & Additional Features/settings.png" width="30%" />
<img src="screenShots/ Settings & Additional Features/rating.png" width="30%" />
<img src="screenShots/ Settings & Additional Features/filter honor board.png" width="30%" />

### 📋 Activity & Requests
<img src="screenShots/ Activity & Requests/My Requests Activity Log.png" width="30%" />
<img src="screenShots/ Activity & Requests/My Services Activity Log.png" width="30%" />

### 📝 Complaints System
<img src="screenShots/Complaints System/Submit a complaint.png" width="30%" />
<img src="screenShots/Complaints System/fill a complaint.png" width="30%" />
<img src="screenShots/Complaints System/complain details.png" width="30%" />
<img src="screenShots/Complaints System/complain state.png" width="30%" />


### 👤 Profile & Rewards
<img src="screenShots/Profile & Rewards/profile.png" width="30%" />
<img src="screenShots/Profile & Rewards/update profile.png" width="30%" />
<img src="screenShots/Profile & Rewards/Honor board.png" width="30%" />
<img src="screenShots/Profile & Rewards/Viewing other people's profiles.png" width="30%" />
</div>

## 📂 Project Structure
```text
lib/
├── core/
│   ├── constants/          # API, Colors, Strings, Routes
│   ├── error/              # Exceptions & Failures
│   ├── network/            # Dio, Endpoints, Decorators
│   ├── strategies/         # Service Pricing Strategies
│   ├── services/           # SecureStorage, Notifications, Geo
│   ├── utils/              # Validators, Formatters
│   ├── widgets/            # Shared UI Components
│   └── usecase/            # Base UseCase Contract
│
├── features/
│   ├── auth/               # UC-02, UC-13: Login, Register, OCR
│   ├── home/               # UC-04, UC-14: Search, Filters
│   ├── services/           # UC-03, UC-17: Add Services
│   ├── exchange/           # UC-01, UC-07: Requests
│   ├── chat/               # UC-05: Real-time Messaging
│   ├── complaints/         # UC-06: Submit & Track
│   ├── profile/            # UC-10: Edit Profile, Ratings
│   ├── nearby/             # UC-11: GPS Discovery
│   └── rewards/            # UC-15, UC-16: Hours, Leaderboard
│
├── injection_container.dart
└── main.dart

🚀 Getting Started
Prerequisites
Flutter SDK (3.x or higher)
Dart SDK
Android Studio / VS Code
Emulator or Physical Device

# Clone the repository
git clone https://github.com/HadelBrmo/In-Time-Project.git
cd in-time-platform

# Install dependencies
flutter pub get

# Run the app
flutter run

Build for Production
flutter build apk --release      # Android
flutter build ios --release      # iOS

🧪 Testing & Quality Assurance
Unit Testing: bloc_test + mocktail for Business Logic & Repositories
Widget Testing: UI component validation
Code Generation: freezed + json_serializable for immutable models
Performance: Pagination, compute() for heavy tasks, Firebase Performance Monitoring
Offline-First: Isar/Hive caching with connectivity_plus sync queues
Security: flutter_secure_storage for tokens, Dio interceptors for auto-refresh
Logging: logger (dev) + Firebase Crashlytics (prod)

👥 Team & University
Developers: Hadel Brmo & Baraa Alahmed
University: Damascus University
Project Type: Graduation Project

<div align="center">

Built with ❤️ using Flutter & Clean Architecture
⭐ If you found this project helpful, please consider giving it a star! ⭐
</div>
```