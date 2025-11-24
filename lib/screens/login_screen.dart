// ignore_for_file: use_build_context_synchronously

import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../constants/app_constants.dart';
import '../services/auth_provider.dart';
import '../widgets/gradient_button.dart';
import 'onboarding_screen.dart';
import 'main_tab_screen.dart';
import 'email_login_screen.dart';
import 'home_screen.dart';

/// Login screen with Google Sign-In
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  int _tapCount = 0;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.3, 1.0, curve: Curves.easeOutBack),
          ),
        );

    _animationController.forward();
  }

  void _handleIconTap() {
    setState(() {
      _tapCount++;
    });

    developer.log('Icon tapped: $_tapCount times', name: 'LoginScreen');

    if (_tapCount >= 7) {
      developer.log('Opening email login screen', name: 'LoginScreen');
      // Reset counter
      setState(() {
        _tapCount = 0;
      });

      // Navigate to email login screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const EmailLoginScreen()),
      );
    }
  }

  Future<void> _handleGoogleSignIn() async {
    developer.log('Login screen: Starting Google Sign-In', name: 'LoginScreen');
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    try {
      developer.log(
        'Login screen: Calling authProvider.signInWithGoogle()',
        name: 'LoginScreen',
      );
      final success = await authProvider.signInWithGoogle();
      developer.log(
        'Login screen: Sign-in result: $success',
        name: 'LoginScreen',
      );

      if (success && mounted) {
        developer.log(
          'Login screen: Sign-in successful, checking onboarding status',
          name: 'LoginScreen',
        );

        // Re-read AuthProvider after async gap to avoid using BuildContext synchronously
        final freshAuth = Provider.of<AuthProvider>(context, listen: false);
        developer.log(
          'Login screen: Is onboarded: ${freshAuth.isOnboarded}',
          name: 'LoginScreen',
        );

        if (freshAuth.isOnboarded) {
          developer.log(
            'Login screen: Navigating to HomeScreen',
            name: 'LoginScreen',
          );
          // Navigate to selected home implementation
          final useTab = AppConstants.useHomeTab;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  useTab ? const MainTabScreen() : const HomeScreen(),
            ),
          );
        } else {
          developer.log(
            'Login screen: Navigating to OnboardingScreen',
            name: 'LoginScreen',
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const OnboardingScreen()),
          );
        }
      } else if (mounted) {
        final freshAuth = Provider.of<AuthProvider>(context, listen: false);
        if (freshAuth.error != null) {
          developer.log(
            'Login screen: Sign-in failed with error: ${freshAuth.error}',
            name: 'LoginScreen',
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                freshAuth.error!,
                style: TextStyle(color: AppColors.textPrimary),
              ),
              backgroundColor: AppColors.error,
              duration: const Duration(seconds: 5),
            ),
          );
        }
      } else if (!success) {
        developer.log(
          'Login screen: Sign-in failed without specific error',
          name: 'LoginScreen',
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Sign-in failed. Please try again.',
              style: TextStyle(color: AppColors.textPrimary),
            ),
            backgroundColor: AppColors.error,
            duration: Duration(seconds: 5),
          ),
        );
      }
    } catch (e) {
      developer.log(
        'Login screen: Exception during sign-in: ${e.toString()}',
        name: 'LoginScreen',
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Sign-in error: ${e.toString()}',
              style: TextStyle(color: AppColors.textPrimary),
            ),
            backgroundColor: AppColors.error,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // Prevent back button on login screen
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: AppColors.background,
        // appBar: AppBar(
        //   backgroundColor: AppColors.background,
        //   elevation: 0,
        //   automaticallyImplyLeading: false, // Remove back button
        //   actions: [
        //     IconButton(
        //       icon: const Icon(Icons.bug_report, color: AppColors.textHint),
        //       onPressed: () {
        //         Navigator.push(
        //           context,
        //           MaterialPageRoute(builder: (_) => const DebugScreen()),
        //         );
        //       },
        //       tooltip: 'Debug Information',
        //     ),
        //   ],
        // ),
        body: SafeArea(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Padding(
                    padding: const EdgeInsets.all(AppConstants.largePadding),
                    child: Column(
                      children: [
                        // Stars background effect
                        Expanded(
                          flex: 2,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Astro Logo
                                GestureDetector(
                                  onTap: _handleIconTap,
                                  child: Container(
                                    width: 160,
                                    height: 160,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.primary.withOpacity(
                                            0.3,
                                          ),
                                          blurRadius: 20,
                                          spreadRadius: 5,
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(80),
                                      child: Image.asset(
                                        'assets/images/ig_logo_jano.png',
                                        width: 160,
                                        height: 160,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 32),

                                // App title
                                Text(
                                  'Welcome to Jano',
                                  style: AppTextStyles.h1.copyWith(
                                    color: AppColors.starGold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 12),

                                // Subtitle
                                Text(
                                  'Discover your cosmic journey\nwith personalized astrology insights',
                                  style: AppTextStyles.bodyLarge.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Login section
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Google Sign-In Button
                              Consumer<AuthProvider>(
                                builder: (context, authProvider, child) {
                                  return GradientButton(
                                    onPressed: authProvider.isLoading
                                        ? null
                                        : _handleGoogleSignIn,
                                    isLoading: authProvider.isLoading,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 24,
                                          height: 24,
                                          decoration: const BoxDecoration(
                                            color: AppColors.textPrimary,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.g_mobiledata,
                                            color: AppColors.googleButtonColor,
                                            size: 20,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          'Continue with Google',
                                          style: AppTextStyles.buttonLarge,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),

                              const SizedBox(height: 24),

                              // Terms and Privacy
                              Text(
                                'By continuing, you agree to our Terms of Service\nand Privacy Policy',
                                style: AppTextStyles.caption,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
