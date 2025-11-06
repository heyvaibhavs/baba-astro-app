import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:developer' as developer;
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../services/auth_provider.dart';
import '../services/storage_service.dart';
import 'login_screen.dart';
import 'home_screen.dart';
import 'onboarding_screen.dart';

/// Splash screen to handle app initialization
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeApp();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _animationController.forward();
  }

  Future<void> _initializeApp() async {
    // Initialize storage
    await StorageService.init();

    // Initialize auth
    if (mounted) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.initializeAuth();

      // Fetch user config if authenticated and onboarded
      if (authProvider.isAuthenticated && authProvider.isOnboarded) {
        print('🔄 Fetching user config on splash...');
        developer.log('Fetching user config on splash', name: 'SplashScreen');
        await authProvider.fetchUserConfig();
        print('✅ User config fetched and premium flag saved');

        // Log the updated premium status
        final isPremium = authProvider.user?.isPremium ?? false;
        print('🎯 Premium status after fetch: $isPremium');
        developer.log(
          'Premium status after fetch: $isPremium',
          name: 'SplashScreen',
        );
      }
    }

    // Wait for animation to complete
    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      _navigateToNextScreen();
    }
  }

  void _navigateToNextScreen() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    print('=== SPLASH SCREEN NAVIGATION ===');
    print('isAuthenticated: ${authProvider.isAuthenticated}');
    print('isOnboarded: ${authProvider.isOnboarded}');
    print('isPremium: ${authProvider.user?.isPremium}');

    developer.log('=== NAVIGATION DECISION START ===', name: 'SplashScreen');
    developer.log(
      'isAuthenticated: ${authProvider.isAuthenticated}',
      name: 'SplashScreen',
    );
    developer.log(
      'isOnboarded: ${authProvider.isOnboarded}',
      name: 'SplashScreen',
    );
    developer.log(
      'isPremium: ${authProvider.user?.isPremium}',
      name: 'SplashScreen',
    );

    if (authProvider.isAuthenticated) {
      if (authProvider.isOnboarded) {
        print('✅ User authenticated & onboarded - Going to HomeScreen');
        print(
          '   (HomeScreen will check premium status and show gate if needed)',
        );
        developer.log(
          'User is authenticated and onboarded - navigating to HomeScreen',
          name: 'SplashScreen',
        );

        // User is logged in and onboarded - go to home
        // HomeScreen will handle premium check in its initState
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } else {
        print(
          '📝 User authenticated but NOT onboarded - Going to OnboardingScreen',
        );
        developer.log(
          'User is authenticated but not onboarded - navigating to OnboardingScreen',
          name: 'SplashScreen',
        );
        // User is logged in but not onboarded - go to onboarding
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const OnboardingScreen()),
        );
      }
    } else {
      print('🔐 User NOT authenticated - Going to LoginScreen');
      developer.log(
        'User is not authenticated - navigating to LoginScreen',
        name: 'SplashScreen',
      );
      // User is not logged in - go to login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo placeholder - replace with actual astro logo
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary,
                            AppColors.galaxyPurple,
                            AppColors.starGold,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: const Icon(
                        Icons.auto_awesome,
                        size: 60,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Baba App',
                      style: AppTextStyles.h2.copyWith(
                        color: AppColors.starGold,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Discover Your Cosmic Journey',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 48),
                    // Loading indicator
                    const SizedBox(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.starGold,
                        ),
                        strokeWidth: 3,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
