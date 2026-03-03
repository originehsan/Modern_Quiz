# 🧠 QuizMaster - Modern Flutter Quiz App

A production-level, premium Flutter quiz application built with MVVM architecture, featuring smooth animations, dark mode support, and modern UI design.

---

## 🎨 Features

### ✨ User Interface
- **Modern, Premium Design** - Gradient backgrounds, glass-morphism cards, soft shadows
- **Responsive UI** - Works seamlessly on all screen sizes using `flutter_screenutil`
- **Dark Mode Support** - Adaptive theme with automatic detection
- **Smooth Animations** - Micro-interactions, page transitions, and loading states
- **Professional Typography** - Using Google Fonts (Poppins)

### 🎯 Core Features
- **Authentication** - Email/password login and signup with password strength checker
- **Quiz System** - Interactive question answering with real-time feedback
- **Category Selection** - Browse and select from multiple quiz categories
- **Performance Metrics** - Score tracking with performance badges (Gold/Silver/Bronze)
- **XP System** - Earn points and level up
- **Leaderboard** - Compare scores with other users
- **Settings** - Dark mode, sound effects, biometric authentication

### 🧩 Technical Highlights
- **Clean MVVM Architecture** - Strict separation of concerns
- **State Management** - Using Provider for reactive UI
- **API Integration** - Open Trivia Database for quiz questions
- **Local Authentication** - Biometric login support
- **Error Handling** - Comprehensive error management

---

## 📂 Project Structure

```
lib/
├── core/
│   ├── constants/          # App constants and configuration
│   ├── theme/              # Color schemes and typography
│   ├── utils/              # Extensions and utility functions
│   └── services/           # Core services (optional)
├── data/
│   ├── models/             # Data models (Question, User, etc.)
│   ├── repositories/       # API & local data repositories
│   └── remote/             # Remote API services
├── viewmodel/
│   ├── auth/               # Authentication logic
│   ├── quiz/               # Quiz game logic
│   ├── home/               # Home screen logic
│   └── profile/            # Settings & profile logic
├── views/
│   ├── screens/            # Full-screen views
│   │   ├── splash/
│   │   ├── auth/
│   │   ├── home/
│   │   ├── quiz/
│   │   ├── result/
│   │   ├── leaderboard/
│   │   └── settings/
│   └── widgets/            # Reusable UI components
├── routes/                 # Navigation configuration
└── main.dart               # App entry point
```

---

## 🚀 Getting Started

### Prerequisites
- Flutter 3.8.1 or higher
- Dart 3.8.1 or higher
- Android SDK / Xcode for iOS

### Installation

1. **Clone the repository**
```bash
git clone <repository-url>
cd modern_quiz_app
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Run the app**
```bash
flutter run
```

---

## 📦 Dependencies

### UI & Design
- `flutter_screenutil` - Responsive design
- `google_fonts` - Modern typography
- `flutter_svg` - Vector graphics
- `gap` - Consistent spacing
- `flutter_animate` - Micro-animations
- `lottie` - Animated elements
- `phosphor_flutter` - Icon library
- `glass_kit` - Glass-morphism effects

### State Management
- `provider` - Reactive state management

### Data & Networking
- `dio` - HTTP client
- `equatable` - Value equality

### Others
- `adaptive_theme` - Dark/Light mode support
- `smooth_page_indicator` - Progress indicators
- `percent_indicator` - Circular progress bars
- `confetti` - Celebration effects
- `shimmer` - Skeleton loading
- `awesome_snackbar_content` - Modern notifications
- `local_auth` - Biometric authentication
- `audioplayers` - Sound effects

---

## 🎮 How to Use

### 1. Registration
- Launch the app and see the animated splash screen
- Sign up with email, username, and password
- Password strength indicator shows real-time feedback

### 2. Home Screen
- Select quiz difficulty (Easy, Medium, Hard)
- Choose number of questions (5, 10, 15, or 20)
- Pick a category from the available options

### 3. Quiz
- Answer multiple-choice questions with timed countdown (30 seconds)
- Get instant feedback on correct/wrong answers
- Progress bar shows your advancement
- Auto-advance or manually proceed to next question

### 4. Results
- See your final score with a performance badge
- View detailed statistics (correct answers, time spent, XP earned)
- Celebrate with confetti animation
- Replay quiz or return to home

### 5. Settings
- Toggle dark mode, sound effects, notifications
- Enable biometric authentication
- Access about and privacy information

---

## 🏗️ MVVM Architecture

### View (UI Layer)
- Pure UI components with no business logic
- Communicates with ViewModel only
- Reactive to state changes

### ViewModel (Presentation Logic)
- Manages business logic and state
- Handles user interactions
- Notifies views of state changes

### Model (Data Layer)
- Repository Pattern for data operations
- Clean separation from UI
- API and local data management

---

## 🎨 Design System

### Colors
- **Primary**: Indigo (#6366F1)
- **Secondary**: Violet (#8B5CF6)
- **Tertiary**: Cyan (#06B6D4)
- **Status**: Green (Success), Red (Error), Orange (Warning)

### Typography
- **Display**: Poppins 32px Bold
- **Heading**: Poppins 20-26px Semi-Bold
- **Body**: Poppins 14-16px Regular
- **Caption**: Poppins 12px Medium

### Components
- **Buttons**: Gradient, rounded corners, shadow effects
- **Cards**: Glass-morphism with soft shadows
- **Progress**: Animated percentage indicators
- **Timers**: Color-coded countdown (Red when < 10s)

---

## 🔧 Customization

### Adding New Questions Source
Edit `lib/data/remote/quiz_service.dart`:
```dart
Future<List<Question>> getQuestions({
  // Add your API endpoint here
}) async {
  // Implement custom API call
}
```

### Changing Theme Colors
Edit `lib/core/theme/app_colors.dart`:
```dart
static const Color primary = Color(0xFF6366F1);
// Change these values to update the app theme
```

### Adding New Screens
1. Create screen file in `lib/views/screens/`
2. Create corresponding ViewModel in `lib/viewmodel/`
3. Add route in `lib/routes/app_routes.dart`
4. Add Provider in `lib/main.dart`

---

## 📱 Supported Platforms
- ✅ Android 5.0+
- ✅ iOS 12.0+
- ✅ Web (with responsive design)
- ✅ Windows (with desktop optimization)

---

## 🔐 Security Features
- ✅ Password strength validation
- ✅ Biometric authentication
- ✅ Secure local storage
- ✅ Input validation and sanitization

---

## 📊 Performance
- **Optimized Builds** - Tree-shaking and code minification
- **Lazy Loading** - On-demand resource loading
- **Efficient State Management** - Provider's selective rebuilds
- **Image Optimization** - SVG vector graphics

---

## 🐛 Known Limitations
- Mock authentication (non-persistent)
- Local data storage (no backend sync)
- Limited to 10 questions per category on Open Trivia DB

---

## 🚀 Future Enhancements
- [ ] Backend API integration
- [ ] User profiles and achievements
- [ ] Social sharing features
- [ ] Offline quiz mode
- [ ] Custom quiz creation
- [ ] Multiplayer quizzes
- [ ] Advanced analytics
- [ ] Push notifications

---

## 📝 License
This project is open source and available under the MIT License.

---

## 👨‍💻 Development Notes

### Running Tests
```bash
flutter test
```

### Building Release
```bash
flutter build apk --release
flutter build ios --release
```

### Code Quality
```bash
flutter analyze
```

### Formatting
```bash
dart format .
```

---

## 🤝 Contributing
Pull requests are welcome! For major changes, please open an issue first to discuss what you would like to change.

---

## 📞 Support
For issues, questions, or suggestions, please open an issue on the GitHub repository.

---

**Built with ❤️ using Flutter**
