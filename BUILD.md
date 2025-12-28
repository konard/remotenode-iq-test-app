# IQ Test App - Build & Release Instructions

## Prerequisites

### Required Software
- Flutter SDK 3.10.0 or higher
- Dart SDK 3.0.0 or higher
- Android Studio (for Android builds)
- Xcode (for iOS builds, macOS only)
- Git

### Setup Flutter

1. Install Flutter: https://docs.flutter.dev/get-started/install
2. Verify installation:
   ```bash
   flutter doctor
   ```

## Project Setup

### 1. Clone and Navigate
```bash
cd iq_test_app
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Generate Localization Files
```bash
flutter gen-l10n
```

### 4. Generate Hive Adapters (if modified)
```bash
dart run build_runner build --delete-conflicting-outputs
```

## Development

### Run in Debug Mode
```bash
# Android
flutter run -d android

# iOS
flutter run -d ios

# Web
flutter run -d chrome
```

### Hot Reload
Press `r` in the terminal or save a file in your IDE.

## App Icon and Splash Screen

### Generate App Icons
1. Place your app icon in `assets/icons/app_icon.png` (1024x1024px recommended)
2. For adaptive icons, also add `assets/icons/app_icon_foreground.png`
3. Run:
   ```bash
   dart run flutter_launcher_icons
   ```

### Generate Splash Screen
1. Place splash logo in `assets/images/splash_logo.png`
2. Run:
   ```bash
   dart run flutter_native_splash:create
   ```

## Building for Release

### Android

#### 1. Configure Signing
Create `android/key.properties`:
```properties
storePassword=<password>
keyPassword=<password>
keyAlias=upload
storeFile=<path-to-keystore>/upload-keystore.jks
```

#### 2. Build APK
```bash
flutter build apk --release
```
Output: `build/app/outputs/flutter-apk/app-release.apk`

#### 3. Build App Bundle (for Play Store)
```bash
flutter build appbundle --release
```
Output: `build/app/outputs/bundle/release/app-release.aab`

### iOS

#### 1. Configure Signing
- Open `ios/Runner.xcworkspace` in Xcode
- Select Runner target > Signing & Capabilities
- Configure your Team and Bundle Identifier

#### 2. Build IPA
```bash
flutter build ipa --release
```
Output: `build/ios/ipa/iq_test_app.ipa`

#### 3. Upload to App Store Connect
```bash
# Using Transporter app or:
xcrun altool --upload-app -f build/ios/ipa/iq_test_app.ipa -t ios -u "your@email.com" -p "app-specific-password"
```

## Testing

### Run Unit Tests
```bash
flutter test
```

### Run Integration Tests
```bash
flutter test integration_test/
```

### Analyze Code
```bash
flutter analyze
```

### Check Formatting
```bash
dart format --set-exit-if-changed .
```

## Release Checklist

### Before Release
- [ ] Update version in `pubspec.yaml`
- [ ] Update changelog
- [ ] Run all tests
- [ ] Test on multiple devices
- [ ] Check accessibility
- [ ] Verify all translations

### App Store Requirements

#### Android (Google Play)
- App icon: 512x512 PNG
- Feature graphic: 1024x500 PNG
- Screenshots: Various device sizes
- Privacy policy URL
- App description (multiple languages)

#### iOS (App Store)
- App icon: 1024x1024 PNG (no transparency)
- Screenshots: iPhone and iPad
- Privacy policy URL
- App description (multiple languages)
- Age rating questionnaire

## Folder Structure

```
lib/
├── main.dart              # App entry point
├── data/                  # Question data
│   ├── questions.dart     # Question aggregation
│   ├── verbal_questions.dart
│   ├── numerical_questions.dart
│   ├── logical_questions.dart
│   ├── spatial_questions.dart
│   └── pattern_questions.dart
├── models/                # Data models
│   ├── models.dart        # Barrel export
│   ├── enums.dart         # Category, difficulty enums
│   ├── question.dart      # Question model
│   └── test_result.dart   # Test result model
├── providers/             # State management
│   ├── providers.dart     # Barrel export
│   ├── theme_provider.dart
│   ├── locale_provider.dart
│   ├── test_provider.dart
│   └── results_provider.dart
├── screens/               # App screens
│   ├── screens.dart       # Barrel export
│   ├── home_screen.dart
│   ├── test_screen.dart
│   ├── results_screen.dart
│   ├── settings_screen.dart
│   └── history_screen.dart
├── utils/                 # Utilities
│   ├── utils.dart         # Barrel export
│   ├── theme.dart         # App theming
│   └── responsive.dart    # Responsive layout
├── widgets/               # Reusable widgets
│   ├── widgets.dart       # Barrel export
│   ├── question_card.dart
│   └── progress_indicator.dart
└── l10n/                  # Localization
    ├── app_en.arb         # English
    ├── app_ru.arb         # Russian
    └── app_es.arb         # Spanish

assets/
├── images/                # App images
├── icons/                 # App icons
└── fonts/                 # Custom fonts (if needed)
```

## Troubleshooting

### Common Issues

#### Build fails with "pub get" error
```bash
flutter clean
flutter pub get
```

#### Localization files not generating
```bash
flutter gen-l10n
```

#### Hive adapter errors
```bash
dart run build_runner build --delete-conflicting-outputs
```

#### iOS build fails with signing error
- Verify Team and Bundle ID in Xcode
- Check provisioning profiles
- Run: `flutter clean && flutter build ios`

## Support

For issues and feature requests, please open an issue on the repository.
