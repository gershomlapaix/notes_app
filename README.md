# Notes App - Flutter Firebase CRUD Application

A comprehensive notes application built with Flutter, featuring Firebase Authentication and Firestore integration. This app demonstrates clean architecture principles, state management with BLoC, and full CRUD operations.

## 📱 Features

### Authentication
- **Email/Password Authentication** with Firebase Auth
- **Input Validation** with specific error messages
- **User Registration** and login functionality
- **Session Management** with automatic state persistence
- **Secure Logout** with confirmation

### Notes Management (CRUD)
- **Create** new notes with title and content
- **Read** all user notes from Firestore
- **Update** existing notes with real-time synchronization
- **Delete** notes with confirmation dialog
- **Real-time Data Sync** with Firestore

### User Interface
- **Material Design** components with Cards and ListTiles
- **Responsive Design** for different screen orientations
- **Loading States** during data operations
- **Success/Error Feedback** with colored SnackBars
- **Empty State Handling** with helpful hints
- **Floating Action Button** for quick note creation

### Architecture & Code Quality
- **Clean Architecture** with separation of concerns
- **BLoC State Management** for reactive programming
- **Repository Pattern** for data abstraction
- **Error Handling** throughout the application
- **Type Safety** with proper Dart practices

## 🚀 Getting Started

### Prerequisites
- **Flutter SDK** (>=3.0.0)
- **Dart SDK** (>=3.0.0)
- **Android Studio** or **VS Code**
- **Firebase Project** with Authentication and Firestore enabled

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/gershomlapaix/notes_app.git
   cd notes_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**

   #### Android Setup:
    - Download `google-services.json` from Firebase Console
    - Place it in `android/app/`
    - Update `android/app/build.gradle`:
   ```gradle
   android {
       compileSdk 34
       ndkVersion = "27.0.12077973"
       defaultConfig {
           minSdk 21
           targetSdk 34
           multiDexEnabled true
       }
   }
   ```

   #### iOS Setup:
    - Download `GoogleService-Info.plist` from Firebase Console
    - Add it to `ios/Runner/` in Xcode

4. **Configure Firestore Security Rules**
   ```javascript
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       match /users/{userId}/notes/{document=**} {
         allow read, write: if request.auth != null && request.auth.uid == userId;
       }
     }
   }
   ```

5. **Run the application**
   ```bash
   flutter run
   ```

## 🔥 Firebase Configuration

### Authentication Setup
1. Go to Firebase Console → Authentication
2. Enable "Email/Password" sign-in method
3. Optionally enable "Email link (passwordless sign-in)"

### Firestore Setup
1. Go to Firebase Console → Firestore Database
2. Create database in test mode
3. Update security rules (see above)
4. Data structure will be automatically created as:
   ```
   users/
     {userId}/
       notes/
         {noteId}/
           - title: string
           - content: string
           - createdAt: timestamp
           - updatedAt: timestamp
   ```

## 📦 Dependencies

### Main Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^2.24.2      # Firebase core functionality
  firebase_auth: ^4.15.3      # Authentication
  cloud_firestore: ^4.13.6    # NoSQL database
  flutter_bloc: ^8.1.3        # State management
  equatable: ^2.0.5           # Value equality

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0       # Linting rules
```

### Why These Dependencies?
- **firebase_core**: Required for all Firebase functionality
- **firebase_auth**: Handles user authentication securely
- **cloud_firestore**: Real-time NoSQL database
- **flutter_bloc**: Predictable state management
- **equatable**: Simplifies equality comparisons in BLoC

## 🧪 Testing

### Running Tests
```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run integration tests
flutter drive --target=test_driver/app.dart
```

## 📊 Dart Analyzer Report

To generate a Dart analyzer report for code quality:

```bash
# Generate analyzer report
flutter analyze > dart_analyzer_report.txt

# View warnings and errors
flutter analyze

# Fix auto-fixable issues
dart fix --apply
```

**Target**: Zero warnings and errors for clean code.


**Gershom Nsengiyumva**
- GitHub: [@gershomlapaix](https://github.com/gershomlapaix)
- Email: nsengiyumv33@gmail.com / gershom.nsengiyum@alustudent.com
