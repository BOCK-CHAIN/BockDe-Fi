📂 Branch Structure

| Branch | Description |
|------|------------|
| `main` | Contains both Web & App source code |
| `web` | Contains only Web version |
| `app` | Contains only Android App version |

 🔧 Prerequisites

Make sure you have:

- Flutter SDK (stable)
- Dart (comes with Flutter)
- Chrome browser (for web)
- Android Studio / Emulator (for app)
- Git

Check installation:
flutter doctor

Step 1:git clone https://github.com/BOCK-CHAIN/BockDe-Fi.git
cd BockDe-Fi

Step 2: Ensure you are on main branch:
git checkout main

Step 3: Install Dependencies
flutter pub get

Step 4: Run Web Version (Localhost)
flutter run -d chrome
This will start the app on:
http://localhost:xxxx

Run on Android Emulator

Step 1:Open Android Studio

Step 2:Start an Android Emulator

Step 3:Run:
flutter run

Build Android APK
flutter build apk --release

APK will be generated at:

build/app/outputs/flutter-apk/app-release.apk

Install APK on Physical Mobile
Method 1: USB Transfer
Copy app-release.apk to your phone
Enable Install from Unknown Sources
Tap APK → Install
