# BockDe-Fi (Android App) 📱

This branch contains **only the Android App version** of BockDe-Fi.

---

## 📥 Clone & Switch Branch
git clone https://github.com/BOCK-CHAIN/BockDe-Fi.git
cd BockDe-Fi
git checkout app

📦 Install Dependencies
flutter pub get

▶️ Run on Android Emulator
Ensure emulator is running, then:
flutter run

📦 Build Release APK
flutter build apk --release
APK location:
build/app/outputs/flutter-apk/app-release.apk

📲 Install on Physical Device
adb install build/app/outputs/flutter-apk/app-release.apk
