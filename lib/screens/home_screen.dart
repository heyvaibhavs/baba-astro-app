import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:developer' as developer;
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../constants/app_constants.dart';
import '../services/auth_provider.dart';
import '../services/storage_service.dart';
import 'subscription_gate.dart';
import 'settings_screen.dart';

/// Home screen for onboarded users
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _checkPremiumStatus();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _animationController.forward();
  }

  Future<void> _checkPremiumStatus() async {
    // Wait for the first frame to be rendered
    await Future.delayed(const Duration(milliseconds: 100));

    if (!mounted) return;

    print('🏠 HomeScreen: Checking premium status from SharedPreferences...');
    developer.log(
      'Checking premium status from SharedPreferences',
      name: 'HomeScreen',
    );

    // Get premium status from SharedPreferences (already fetched on splash)
    final isPremium = StorageService.getPremiumStatus();

    print('🏠 isPremium from storage: $isPremium');
    developer.log('isPremium from storage: $isPremium', name: 'HomeScreen');

    if (!mounted) return;

    if (!isPremium) {
      print('🚀 HomeScreen: Showing subscription gate');
      developer.log('Showing subscription gate', name: 'HomeScreen');

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const SubscriptionGate(),
          fullscreenDialog: true,
        ),
      );
    } else {
      print('✅ User is premium - no gate needed');
      developer.log('User is premium - no gate needed', name: 'HomeScreen');
    }
  }

  void _navigateToSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SettingsScreen()),
    );
  }

  /// Handle feature card tap - check premium status and show gate if needed
  Future<void> _handleFeatureTap(String featureName) async {
    print('🎯 Feature tapped: $featureName');
    developer.log('Feature tapped: $featureName', name: 'HomeScreen');

    // Check premium status from SharedPreferences
    final isPremium = StorageService.getPremiumStatus();
    print('💎 Premium status: $isPremium');

    if (!isPremium) {
      print('🚀 Showing subscription gate for feature: $featureName');
      developer.log(
        'Showing subscription gate for feature: $featureName',
        name: 'HomeScreen',
      );

      // Show subscription gate
      final result = await Navigator.of(context).push<bool>(
        MaterialPageRoute(
          builder: (_) => const SubscriptionGate(),
          fullscreenDialog: true,
        ),
      );

      // If user purchased, check again and navigate to feature
      if (result == true) {
        print('✅ User purchased subscription - navigating to $featureName');
        // TODO: Navigate to the actual feature screen
      } else {
        print('❌ User cancelled subscription');
      }
    } else {
      print('✅ User is premium - navigating to $featureName');
      // TODO: Navigate to the actual feature screen
      // For now, just show a message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '$featureName coming soon!',
              style: TextStyle(color: AppColors.background),
            ),
            backgroundColor: AppColors.primary,
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
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Baba App'),
        backgroundColor: AppColors.surface,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _navigateToSettings,
            tooltip: 'Settings',
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                final user = authProvider.user;

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(AppConstants.defaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Welcome section
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(
                          AppConstants.largePadding,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primary.withOpacity(0.1),
                              AppColors.galaxyPurple.withOpacity(0.1),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.3),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: AppColors.starGold,
                                  backgroundImage:
                                      user?.profile.avatar.isNotEmpty == true
                                      ? NetworkImage(user!.profile.avatar)
                                      : null,
                                  child: user?.profile.avatar.isEmpty != false
                                      ? Text(
                                          user?.profile.name.isNotEmpty == true
                                              ? user!.profile.name[0]
                                                    .toUpperCase()
                                              : 'U',
                                          style: AppTextStyles.h3.copyWith(
                                            color: AppColors.background,
                                          ),
                                        )
                                      : null,
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Welcome back,',
                                        style: AppTextStyles.bodyMedium
                                            .copyWith(
                                              color: AppColors.textSecondary,
                                            ),
                                      ),
                                      Text(
                                        user?.profile.name ?? 'User',
                                        style: AppTextStyles.h3.copyWith(
                                          color: AppColors.starGold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.cardBackground.withOpacity(
                                  0.5,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    color: AppColors.starGold,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    user?.profile.city ?? 'Location not set',
                                    style: AppTextStyles.bodyMedium,
                                  ),
                                  const Spacer(),
                                  Icon(
                                    Icons.cake,
                                    color: AppColors.starGold,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${user?.profile.age ?? 0} years',
                                    style: AppTextStyles.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Features section
                      Text(
                        'Explore Your Cosmic Journey',
                        style: AppTextStyles.h2,
                      ),
                      const SizedBox(height: 16),

                      // Feature cards
                      GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        children: [
                          _buildFeatureCard(
                            icon: Icons.auto_awesome,
                            title: 'Daily Horoscope',
                            subtitle: 'Your cosmic forecast',
                            onTap: () => _handleFeatureTap('Daily Horoscope'),
                          ),
                          _buildFeatureCard(
                            icon: Icons.stars,
                            title: 'Birth Chart',
                            subtitle: 'Discover your stars',
                            onTap: () => _handleFeatureTap('Birth Chart'),
                          ),
                          _buildFeatureCard(
                            icon: Icons.favorite,
                            title: 'Compatibility',
                            subtitle: 'Find your match',
                            onTap: () => _handleFeatureTap('Compatibility'),
                          ),
                          _buildFeatureCard(
                            icon: Icons.psychology,
                            title: 'Insights',
                            subtitle: 'Cosmic wisdom',
                            onTap: () => _handleFeatureTap('Insights'),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),

                      // Coming soon section
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(
                          AppConstants.largePadding,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.cardBackground,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.rocket_launch,
                              size: 48,
                              color: AppColors.starGold,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'More Features Coming Soon!',
                              style: AppTextStyles.h3,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'We\'re working hard to bring you more amazing astrology features. Stay tuned!',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      color: AppColors.cardBackground,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: AppColors.starGold),
              const SizedBox(height: 12),
              Text(title, style: AppTextStyles.h4, textAlign: TextAlign.center),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
