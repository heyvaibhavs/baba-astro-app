# Baba App - Astrology Flutter Application

A beautiful Flutter application with Google Sign-In, onboarding flow, and astro-themed UI.

## Features Implemented

✅ **Native Splash Screen** - Beautiful astro-themed splash screen with animations
✅ **Google Authentication** - Secure login with Google Sign-In
✅ **Smart Navigation** - Automatic routing based on authentication and onboarding status
✅ **Onboarding Flow** - Profile setup with name, age, and city selection
✅ **Home Screen** - Personalized dashboard for authenticated users
✅ **Responsive Design** - Optimized for various screen sizes
✅ **Professional UI** - Astro-themed design with gradients and animations

## Project Structure

```
lib/
├── constants/          # App colors, themes, and constants
├── models/            # Data models for API responses
├── screens/           # UI screens (splash, login, onboarding, home)
├── services/          # API service, auth provider, storage
├── widgets/           # Reusable UI components
└── main.dart          # App entry point
```

## API Integration

The app integrates with the following API endpoints:

### Google Authentication
- **Endpoint**: `{{base_url}}/api/auth/google`
- **Method**: POST
- **Body**: `{"idToken": "eyJhbGciOiJSUzI..."}`

### Onboarding Submission
- **Endpoint**: `{{base_url}}/api/onboarding/submit`
- **Method**: POST  
- **Headers**: `Authorization: Bearer {token}`
- **Body**: `{"name": "John Doe", "age": 25, "city": "Mumbai"}`

## Setup Instructions

### 1. Install Dependencies
```bash
flutter pub get
```

### 2. Configure API Base URL
Update the base URL in `lib/constants/app_constants.dart`:
```dart
static const String baseUrl = 'https://your-actual-api-domain.com';
```

### 3. Configure Google Sign-In

#### Android Configuration
1. Go to the [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select an existing one
3. Enable the Google Sign-In API
4. Create credentials (OAuth 2.0 client ID) for Android
5. Add your app's SHA-1 fingerprint
6. Update `android/app/google-services.json` with your configuration

#### iOS Configuration
1. In Google Cloud Console, create credentials for iOS
2. Update `ios/Runner/GoogleService-Info.plist` with your configuration
3. Update `ios/Runner/Info.plist` with URL schemes

### 4. Add App Logo (Optional)
1. Place your logo image at `assets/images/logo.png`
2. Update `pubspec.yaml` to uncomment the logo configuration:
```yaml
flutter_native_splash:
  color: "#1a1a2e"
  image: "assets/images/logo.png"  # Uncomment this line
```
3. Regenerate splash screen: `dart run flutter_native_splash:create`

### 5. Run the Application
```bash
flutter run
```

## App Flow

1. **Splash Screen** - Shows loading animation while initializing
2. **Authentication Check** - Automatically determines user state
3. **Login Screen** - Google Sign-In for new/unauthenticated users
4. **Onboarding Screen** - Profile setup for first-time users
5. **Home Screen** - Main dashboard for completed users

## Navigation Logic

The app automatically navigates users based on their status:

- **Not Authenticated** → Login Screen
- **Authenticated + Not Onboarded** → Onboarding Screen  
- **Authenticated + Onboarded** → Home Screen

## State Management

- **Provider Pattern** - Used for authentication state management
- **Local Storage** - SharedPreferences for persistent user data
- **Automatic State Sync** - Seamless state management across app lifecycle

## UI Features

- **Astro Theme** - Dark theme with purple/gold gradient colors
- **Smooth Animations** - Fade and slide transitions between screens
- **Responsive Layout** - Adapts to different screen sizes
- **Input Validation** - Form validation with error handling
- **Loading States** - Beautiful loading indicators during API calls

## Dependencies

- `provider` - State management
- `google_sign_in` - Google authentication
- `http` - API requests
- `shared_preferences` - Local storage
- `flutter_native_splash` - Native splash screen

## Contributing

1. Follow the coding standards outlined in `instruction.md`
2. Use the established project structure
3. Maintain consistent naming conventions
4. Write tests for new features
5. Follow the astro theme design patterns

## Development Notes

- **Base URL**: Update in `app_constants.dart` before production
- **API Keys**: Configure Google Sign-In credentials properly
- **Assets**: Add actual logo file for production use
- **Testing**: Run tests with `flutter test`
- **Formatting**: Format code with `flutter format .`

## Future Enhancements

The home screen includes placeholders for future features:
- Daily Horoscope
- Birth Chart Analysis  
- Compatibility Matching
- Cosmic Insights

---

Built with ❤️ using Flutter following professional development standards.
