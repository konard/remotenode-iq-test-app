# IQ Test App

A comprehensive, production-ready IQ Test mobile app built with Flutter 3.x+, designed for release on app stores.

## Features

### Core Functionality
- **5 Cognitive Categories**: Verbal, Numerical, Logical, Spatial, and Pattern Recognition
- **60 Carefully Crafted Questions**: 12 questions per category with varying difficulty levels
- **Multiple Question Types**:
  - Multiple choice (4 options)
  - Select all that apply
  - Sequence completion
  - Matrix reasoning
  - Analogies
  - Number series
  - Figure rotation

### Adaptive Testing
- Intelligent difficulty adjustment based on performance
- Questions start at medium difficulty
- Difficulty increases after 2 consecutive correct answers
- Difficulty decreases after 2 consecutive wrong answers

### Timing System
- Total test timer (25-35 minutes typical)
- Per-question timer display
- Time tracking for performance analysis

### Results & Analytics
- IQ score estimation (70-145+ scale)
- Percentile ranking
- Category breakdown with radar chart
- Detailed interpretation text
- Historical results storage

### User Experience
- Beautiful Material 3 design
- Dark/Light theme support
- Smooth animations throughout
- Responsive layout (phone + tablet)
- Accessibility features (semantic labels, sufficient contrast)

### Internationalization
- English (default)
- Russian
- Spanish

## Screenshots

*(Add screenshots here)*

## Tech Stack

- **Framework**: Flutter 3.x+
- **State Management**: Riverpod
- **Local Storage**: Hive
- **Charts**: fl_chart
- **Animations**: flutter_animate
- **Fonts**: Google Fonts (Poppins, Inter)

## Getting Started

### Prerequisites
- Flutter SDK 3.10.0+
- Dart SDK 3.0.0+

### Installation

```bash
# Clone the repository
git clone https://github.com/remotenode/iq-test-app.git

# Navigate to project
cd iq-test-app

# Install dependencies
flutter pub get

# Generate localization files
flutter gen-l10n

# Run the app
flutter run
```

## Building for Release

See [BUILD.md](BUILD.md) for detailed build and release instructions.

### Quick Build Commands

```bash
# Android APK
flutter build apk --release

# Android App Bundle (Play Store)
flutter build appbundle --release

# iOS
flutter build ipa --release
```

## Project Structure

```
lib/
├── main.dart              # App entry point
├── data/                  # Question data (60 questions)
├── models/                # Data models
├── providers/             # State management (Riverpod)
├── screens/               # App screens
├── utils/                 # Theme & responsive utilities
├── widgets/               # Reusable widgets
└── l10n/                  # Localization files
```

## Question Categories

| Category | Description | Questions |
|----------|-------------|-----------|
| Verbal | Language comprehension, vocabulary, analogies | 12 |
| Numerical | Mathematical aptitude, number series | 12 |
| Logical | Deductive reasoning, syllogisms | 12 |
| Spatial | Visual-spatial awareness, mental rotation | 12 |
| Pattern | Pattern identification, sequence completion | 12 |

## IQ Score Interpretation

| Score Range | Classification |
|-------------|----------------|
| < 85 | Below Average |
| 85-89 | Low Average |
| 90-109 | Average |
| 110-119 | Above Average |
| 120-129 | High |
| 130-139 | Very High |
| 140-144 | Superior |
| 145+ | Gifted |

## Contributing

Contributions are welcome! Please read our contributing guidelines before submitting a PR.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Question design based on established IQ test methodologies
- UI/UX inspired by modern cognitive assessment tools
- Built with Flutter and the amazing Flutter community packages
