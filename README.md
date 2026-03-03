# Modern Quiz App

A professional Flutter application for taking category-based quizzes with multiple difficulty levels, real-time scoring, and a modern UI design.

---

## Overview

Modern Quiz App is a clean, production-ready Flutter application that demonstrates industry-standard practices in mobile app development. The app allows users to select quiz categories and difficulty levels, answer dynamically fetched multiple-choice questions, and receive real-time performance feedback with animated results.

Built with a focus on maintainability and scalability, the project implements MVVM architecture with proper separation of concerns, making it an ideal reference for Flutter developers and engineering internship candidates.

---

## Features

- **Category Selection**: Browse and select from multiple quiz categories
- **Difficulty Levels**: Choose from Easy, Medium, and Hard question sets
- **Dynamic Question Fetching**: Real-time question retrieval from external service
- **Timer-Based Quizzes**: Countdown timer for each question (customizable duration)
- **Real-Time Score Calculation**: Instant feedback on answer correctness
- **Comprehensive Results Screen**: 
  - Percentage score calculation
  - Accuracy statistics
  - Time spent tracking
  - Category and difficulty summary
- **Conditional Confetti Animation**: Performance-based celebration effects
- **Modern UI Design**:
  - Warm gradient backgrounds
  - Glass-morphism cards
  - Smooth animations
  - Responsive typography
- **Network Error Handling**: Graceful fallback for connection failures
- **State Persistence**: Quiz history and user session management

---

## Architecture

This project follows the **MVVM (Model-View-ViewModel)** architectural pattern, ensuring clean code organization and testability.

### Architecture Components

**View Layer (UI)**
- Stateful and Stateless widgets
- Screen components in dedicated folders
- Responsive design using ScreenUtil
- Animation and transition handling

**ViewModel Layer (Business Logic)**
- ChangeNotifier for state management
- Quiz logic and score calculation
- User interaction handling
- Data validation

**Model Layer (Data Representation)**
- Question and Category models
- QuizResult data class
- User authentication models
- API response mapping

**Service & Repository Layer**
- API communication via Dio
- Data fetching and transformation
- Error handling and retry logic
- Repository pattern for data access

### State Management

The app uses **Provider** for dependency injection and reactive state management:

```dart
// ViewModel listens to changes
class QuizViewModel extends ChangeNotifier {
  // Business logic here
  void selectAnswer(String answer) {
    // Logic...
    notifyListeners(); // Notify UI of changes
  }
}

// UI rebuilds only when state changes
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
│   │   ├── app_constants.dart      # App routes, timeouts, API config
│   │   └── app_colors.dart         # Centralized color palette
│   ├── theme/
│   │   └── app_theme.dart          # Theme configuration
│   ├── services/
│   │   └── [service files]         # API and utility services
│   └── utils/
│       └── [utility files]         # Helper functions
│
├── data/
│   ├── models/
│   │   ├── question_model.dart     # Question and Category models
│   │   └── [other models]
│   ├── remote/
│   │   └── quiz_service.dart       # API client
│   └── repositories/
│       ├── quiz_repository.dart    # Quiz data repository
│       └── auth_repository.dart    # Authentication repository
│
├── viewmodel/
│   ├── quiz/
│   │   └── quiz_viewmodel.dart     # Quiz business logic
│   ├── home/
│   │   └── home_viewmodel.dart     # Home screen logic
│   ├── auth/
│   │   └── auth_viewmodel.dart     # Authentication logic
│   └── [other viewmodels]
│
├── views/
│   ├── screens/
│   │   ├── quiz/
│   │   │   └── quiz_screen.dart    # Quiz UI
│   │   ├── home/
│   │   │   └── home_screen.dart    # Home UI
│   │   ├── result/
│   │   │   └── result_screen.dart  # Results UI
│   │   └── [other screens]
│   └── widgets/
│       └── [custom widgets]        # Reusable UI components
│
├── routes/
│   └── app_routes.dart             # Route definitions
│
├── main.dart                        # App entry point
└── pubspec.yaml                     # Dependencies
```

### Folder Descriptions

- **core/constants**: Application-wide constants and color definitions
- **core/theme**: Theme styles and design tokens
- **core/services**: Utility services for logging, analytics, etc.
- **data/models**: Data classes representing API responses
- **data/remote**: API client and network requests
- **data/repositories**: Data access abstraction layer
- **viewmodel**: Business logic layer using Provider
- **views/screens**: Full-screen UI components
- **views/widgets**: Reusable custom widgets
- **routes**: Navigation and route management

---

## API Integration

The app fetches quiz questions from an external trivia service. The integration is handled through a dedicated service layer, ensuring clean separation from UI logic.

### How It Works

1. **Quiz Service** - Handles all API communication
2. **Query Parameters** - Difficulty, category, and question count are sent as parameters
3. **Response Mapping** - JSON responses are converted to Dart model objects
4. **Error Handling** - Network failures trigger user-friendly error messages
5. **Repository Pattern** - Quiz repository abstracts service implementation from ViewModels

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

The app uses a `.env` file for flexible configuration management. This approach allows different settings for development, staging, and production environments without code changes.

### Configuration Features

- Environment-specific variables
- Loaded at app startup via `flutter_dotenv`
- Prevents hardcoding of configuration values
- Easy deployment across environments

### Setup Instructions

See the [Setup](#setup-instructions) section below for `.env` file creation.

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

4. **Configure Environment Variables**
   
   Add the following to your `.env` file:
   ```
   QUIZ_BASE_URL=https://your-api-endpoint
   ```

5. **Run the Application**
   ```bash
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
- Warm color palette (cream to white gradient)
- Applied consistently across all screens
- Creates visual hierarchy and professional appearance

**Glass-Style Cards**
- Backdrop blur effect for depth
- Semi-transparent backgrounds
- Subtle borders and soft shadows
- Premium visual feel without extra dependencies

**Typography**
- Google Fonts (Poppins) for consistency
- Clear text hierarchy with weight variations
- Optimized readability across screen sizes

**Spacing and Shadows**
- Consistent 16-20px padding standard
- Soft shadows for subtle elevation
- Clean whitespace for visual clarity

**Animations**
- Smooth question transitions
- Scale and fade effects
- Confetti celebration on quiz completion
- No flashy or distracting effects

---

## Dependencies

Key packages used in this project:

- **flutter**: Core Flutter framework
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

- **Local Storage**: SQLite integration for persistent score history
- **Dark Mode**: Theme switching support
- **Offline Support**: Question caching for offline access
- **Unit Testing**: Comprehensive test coverage for business logic
- **Performance Optimization**: Lazy loading and image caching
- **Leaderboard**: Multi-device score synchronization
- **User Profiles**: Detailed statistics and achievements
- **Advanced Filtering**: Additional filter options for questions
- **Analytics**: Track user engagement and quiz performance
- **Accessibility**: Enhanced screen reader support

---

## Testing

### Running Tests

```bash
flutter test
```

### Test Coverage

- Unit tests for ViewModel logic
- Widget tests for UI components
- Integration tests for complete flows

---

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

This project is provided as-is for educational and portfolio purposes.

---

## Author

**Your Name**  
Flutter Developer

GitHub: [Your GitHub Profile](https://github.com/yourprofile)  
LinkedIn: [Your LinkedIn Profile](https://linkedin.com/in/yourprofile)  
Email: your.email@example.com

---

## Acknowledgments

- Flutter team for the excellent framework
- Open source community for helpful packages
- Modern design principles from Material Design

---

## Version History

- **v1.0.0** (March 2026) - Initial release with core features
  - Category-based quiz functionality
  - Modern UI design implementation
  - Result tracking and analytics
  - Error handling and state management

---

## Contact & Support

For questions or feedback, please reach out through GitHub issues or email.

---

**Last Updated**: March 3, 2026
