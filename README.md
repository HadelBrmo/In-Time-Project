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
| 🗺️ **Smart Map & Nearby** | GPS-powered live service discovery with Google Maps integration and distance-based sorting. |
| 💬 **In-App Messaging** | Built-in chat system with automated polling queues for reliable messaging, scheduling, and service confirmation. |
| 🏆 **Gamification & Leaderboard** | Honor board tracking, user progress, and monthly rankings to boost community engagement. |
| 📝 **Complaint & Dispute System** | Trackable tickets (`Processing`, `Done`, `Rejected`) with full theme support and context-aware error handling. |
| ⭐ **Ratings & Reviews** | Verified reviews, ratings, and feedback systems to build platform trust. |
| 👤 **Guest Mode** | Allows users to browse active services and explore the platform freely without initial login. |

---
## 🛠️ Technical Stack
- **Framework:** Flutter 3.x
- **Language:** Dart
- **State Management:** BLoC Pattern (flutter_bloc) + Dart Streams
- **Architecture:** Clean Architecture (Presentation → Domain → Data)
- **Dependency Injection:** `get_it` (Service Locator)
- **Functional Programming:** `dartz` (Either Left/Right Error handling)
- **Local Storage / Caching:** `hive` (Fast NoSQL local object storage),`flutter_secure_storage` (Encrypted storage for sensitive data like Tokens)
- **Networking:** `dio` (HTTP client with interceptors) & `http`
- **Key UI & Animation Packages:** `flutter_animate`, `lottie`, `confetti`, `smooth_page_indicator`, `flutter_screenutil`
- **Location Services:** `google_maps_flutter` & `geolocator`

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
<img src="screenShots/Onboarding & Authentication/otp.png" width="30%" />

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
│   ├── constants/          # الأكواد الثابتة: API, Colors, Strings, Routes
│   ├── error/              # إدارة الأخطاء: Exceptions & Failures
│   ├── network/            # إعدادات الشبكة: Dio Client, Interceptors, Decorators
│   ├── theme/              # التصميم: AppTheme, GlowingBorder, Custom Styles
│   ├── utils/              # أدوات مساعدة: AuthUtils, SnackBarUtils, Validators
│   ├── widgets/            # عناصر واجهة مستخدم مشتركة: CustomAppBar, LoadingWidget
│   └── services/           # خدمات النظام: LocationService, NotificationService
│
├── features/
│   ├── auth/               # تسجيل الدخول، إنشاء الحساب، ونظام الـ OTP
│   ├── home/               # الصفحة الرئيسية، البحث، والخدمات القريبة (Nearby)
│   ├── servings/           # إضافة وإدارة الخدمات، التعليقات، وأنماط التسعير (Strategies)
│   ├── requests/           # إدارة الطلبات المرسلة والمستلمة (بدل exchange)
│   ├── chat/               # المحادثات الفورية، المجموعات، ونظام الـ Polling
│   ├── complaints/         # تقديم الشكاوى وتتبع حالتها (Processing, Done)
│   ├── profile/            # الملف الشخصي، التقييمات، ومعرض الأعمال
│   ├── wallet/             # المحفظة الزمنية وعرض رصيد الساعات
│   ├── rewards/            # لوحة الشرف (Leaderboard)، الأوسمة، والجوائز
│   ├── splash/             # شاشة البداية المتحركة
│   └── onboarding/         # شاشات التعريف بالتطبيق للمستخدم الجديد
│
├── injection_container.dart # محرك حقن التبعيات (Service Locator)
└── main.dart                # نقطة انطلاق التطبيق وإعدادات التشغيل الأساسية

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
Performance: Pagination, compute() for heavy tasks, Firebase Performance Monitoring
Offline-First: Hive caching with connectivity_plus sync queues
Security: flutter_secure_storage for tokens, Dio interceptors for auto-refresh
Logging: logger (dev) + Firebase Crashlytics (prod)

👥 Team & University
Developers: Hadel Brmo 
University: Damascus University
Project Type: Graduation Project


Built with ❤️ using Flutter & Clean Architecture
⭐ If you found this project helpful, please consider giving it a star! ⭐

```