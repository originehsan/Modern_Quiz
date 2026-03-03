# Modern Quiz App

A Flutter application for taking category-based quizzes with multiple difficulty levels, real-time scoring, and a modern, clean user interface.

---

## Overview

Modern Quiz App is a structured Flutter project built to demonstrate practical mobile development using clean architecture principles. The application allows users to select quiz categories, choose difficulty levels, answer dynamically fetched multiple-choice questions, and receive performance feedback through an animated results screen.

The main focus of this project is maintainable code, proper separation of concerns, and scalable architecture. It follows the MVVM pattern and uses Provider for state management, making it a strong example project for internship and junior-level Flutter roles.

---

## Features

- **Category Selection** – Browse and choose from multiple quiz categories  
- **Difficulty Levels** – Easy, Medium, and Hard question sets  
- **Dynamic Question Fetching** – Questions retrieved in real time from an external service  
- **Timer-Based Quiz Flow** – Countdown timer for each question  
- **Real-Time Score Calculation** – Immediate answer validation  
- **Detailed Results Screen**
  - Percentage score calculation  
  - Accuracy statistics  
  - Time tracking  
  - Category and difficulty summary  
- **Performance-Based Confetti Animation** – Celebration effects based on results  
- **Modern UI Design**
  - Warm gradient backgrounds  
  - Glass-style cards with backdrop blur  
  - Smooth and subtle animations  
  - Responsive typography  
- **Network Error Handling** – Graceful handling of connectivity issues  
- **Session State Management** – Quiz state maintained throughout the session  

---

## Architecture

The project follows the **MVVM (Model–View–ViewModel)** architectural pattern to ensure clean code organization and easier testing.

### View Layer (UI)

- Stateless and Stateful widgets  
- Screen components organized into dedicated folders  
- Responsive layout handling  
- Animation and transition management  

### ViewModel Layer (Business Logic)

- Uses `ChangeNotifier` with Provider  
- Handles quiz flow and score calculation  
- Manages user interaction logic  
- Performs validation and state updates  

### Model Layer (Data Representation)

- Question and Category models  
- QuizResult data structure  
- API response mapping  

### Service & Repository Layer

- API communication using Dio  
- Data transformation into model classes  
- Error handling for failed network requests  
- Repository pattern to abstract service implementation from ViewModels  

---

## State Management

The application uses **Provider** for dependency injection and reactive state updates.

Example:

```dart
class QuizViewModel extends ChangeNotifier {
  void selectAnswer(String answer) {
    // Business logic here
    notifyListeners();
  }
}

Consumer<QuizViewModel>(
  builder: (context, viewModel, child) {
    return Text('Score: ${viewModel.score}');
  },
)
```

---

## Project Structure

```
lib/
├── core/
│   ├── constants/
│   │   ├── app_constants.dart
│   │   └── app_colors.dart
│   ├── theme/
│   │   └── app_theme.dart
│   ├── services/
│   └── utils/
│
├── data/
│   ├── models/
│   ├── remote/
│   │   └── quiz_service.dart
│   └── repositories/
│
├── viewmodel/
│   ├── quiz/
│   ├── home/
│   ├── auth/
│
├── views/
│   ├── screens/
│   └── widgets/
│
├── routes/
│   └── app_routes.dart
│
├── main.dart
└── pubspec.yaml
```

This structure keeps the codebase organized and easier to maintain as the app grows.



## API Integration

Quiz questions are fetched from an external trivia service.  
All networking logic is handled in a **dedicated service layer**, keeping the UI clean and focused on presentation only.

---

### How It Works

1. `QuizViewModel` requests quiz data  
2. The `QuizRepository` forwards the request  
3. The `QuizService` performs the API call  
4. The JSON response is mapped into **model classes**  
5. The `ViewModel` updates the state  
6. The UI rebuilds automatically using **Provider**

---

### Data Flow

```
QuizScreen
    ↓
QuizViewModel
    ↓
QuizRepository
    ↓
QuizService (API)
    ↓
External Trivia Service
```

---

## Environment Configuration

The application uses a `.env` file for configuration management.

- Environment variables are loaded at startup using `flutter_dotenv`
- Configuration values remain separate from source code
- Supports flexible development setups


---

## Setup Instructions

### Prerequisites

- Flutter SDK (3.0 or higher)
- Dart SDK
- Android Studio, Xcode, or VS Code with Flutter extension
- Git

### Installation Steps

1. **Clone the Repository**
   ```bash
   git clone [repository-url]
   cd modern_quiz_app
   ```

2. **Install Dependencies**
   ```bash
   flutter pub get
   ```

3. **Create Environment File**
   
   Create a `.env` file in the project root:
   ```bash
   touch .env
   ```

4. **Run the Application**
   ```
   flutter run
   ```

### Build for Release

```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release
```

---

## UI Design Highlights

### Design Philosophy

The app follows modern Material Design principles with custom enhancements:

**Gradient Backgrounds**
- Warm cream-to-white gradient
- Applied consistently across all screens

**Glass-Style Cards**
- Backdrop blur effect for depth
- Semi-transparent backgrounds
- Subtle borders and soft shadows

**Typography**
- Google Fonts (Poppins) for consistency
- Clear text hierarchy with weight variations


**Animations**
- Smooth transitions between questions
- Subtle scale and fade effects
- Confetti animation upon quiz completion

---

## Dependencies

Key packages used in this project:

- **provider**: State management and dependency injection
- **dio**: HTTP client for API requests
- **google_fonts**: Custom typography
- **flutter_dotenv**: Environment configuration
- **flutter_screenutil**: Responsive design
- **confetti**: Celebration animations
- **circular_countdown_timer**: Quiz timer widget
- **phosphor_flutter**: Icon library

Full dependency list available in `pubspec.yaml`.

---

## Future Improvements

- Local storage for persistent quiz history
- Dark mode support
- Offline question caching
- Expanded unit and widget testing
- Leaderboard functionality
- Accessibility improvements


## Deployment

The app is production-ready and can be deployed to:

- Google Play Store (Android)
- Apple App Store (iOS)

Follow official Flutter deployment guides for your target platform.

---

## Performance Considerations

- Efficient provider rebuilds with Consumer widgets
- Lazy loading of quiz questions
- Debounced timer updates to prevent excessive rebuilds
- Optimized animations with flutter_animate
- Memory management for image assets

---

## Troubleshooting

### Common Issues

**Issue**: Dependency conflicts
- **Solution**: Run `flutter pub get` and `flutter pub upgrade`

**Issue**: API connection failures
- **Solution**: Verify `.env` configuration and check network connectivity

**Issue**: UI rendering issues
- **Solution**: Clear build cache with `flutter clean` and rebuild

---

## Contributing

This project is a portfolio demonstration. However, best practices for contributions include:

1. Create a feature branch
2. Make focused changes
3. Write descriptive commit messages
4. Submit pull requests with clear descriptions

---

## License

This project is provided for educational and portfolio purposes.

---

## Author

**Ehsan Ali**  
Flutter Developer  

GitHub: [github.com/originehsan](https://github.com/originehsan)  
LinkedIn: [linkedin.com/in/ehsan-7x](https://www.linkedin.com/in/ehsan-7x/)  
Email: originehsan.email@example.com  

---

## Acknowledgments

- Flutter team for the excellent framework
- Open source community for helpful packages
- Modern design principles from Material Design

---

## Contact & Support

For questions or feedback, please reach out through GitHub issues or email.

---