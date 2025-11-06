/// App constants and configuration
class AppConstants {
  // App information
  static const String appName = 'Baba App';
  static const String appVersion = '1.0.0';

  // API configuration
  // Local server configuration
  // static const String baseUrl = 'http://192.168.29.176:3000'; // Local server
  static const String baseUrl = 'https://learner.netaapp.in'; // Production server
  static const String googleAuthEndpoint = '/api/auth/google';
  static const String onboardingEndpoint = '/api/onboarding/submit';
  static const String userConfigEndpoint = '/api/config/user';

  // Storage keys
  static const String userTokenKey = 'user_token';
  static const String userDataKey = 'user_data';
  static const String isOnboardedKey = 'is_onboarded';
  static const String firstLaunchKey = 'first_launch';

  // Validation
  static const int minAge = 13;
  static const int maxAge = 100;
  static const int maxNameLength = 50;

  // UI constants
  static const double defaultPadding = 16.0;
  static const double largePadding = 24.0;
  static const double smallPadding = 8.0;
  static const double borderRadius = 12.0;
  static const double buttonHeight = 48.0;
  static const double inputHeight = 56.0;

  // Animation durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 400);
  static const Duration longAnimation = Duration(milliseconds: 600);

  // Cities list for location selection
  static const List<String> cities = [
    'Mumbai',
    'Delhi',
    'Bangalore',
    'Hyderabad',
    'Ahmedabad',
    'Chennai',
    'Kolkata',
    'Surat',
    'Pune',
    'Jaipur',
    'Lucknow',
    'Kanpur',
    'Nagpur',
    'Indore',
    'Thane',
    'Bhopal',
    'Visakhapatnam',
    'Pimpri-Chinchwad',
    'Patna',
    'Vadodara',
    'Ghaziabad',
    'Ludhiana',
    'Agra',
    'Nashik',
    'Faridabad',
    'Meerut',
    'Rajkot',
    'Kalyan-Dombivli',
    'Vasai-Virar',
    'Varanasi',
    'Srinagar',
    'Aurangabad',
    'Dhanbad',
    'Amritsar',
    'Navi Mumbai',
    'Allahabad',
    'Ranchi',
    'Howrah',
    'Coimbatore',
    'Jabalpur',
    'Gwalior',
    'Vijayawada',
    'Jodhpur',
    'Madurai',
    'Raipur',
    'Kota',
    'Guwahati',
    'Chandigarh',
    'Solapur',
    'Hubli–Dharwad',
  ];
}
