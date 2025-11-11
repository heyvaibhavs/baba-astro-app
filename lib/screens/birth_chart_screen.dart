import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../constants/app_constants.dart';
import '../widgets/gradient_button.dart';

/// Birth Chart analysis screen
class BirthChartScreen extends StatefulWidget {
  const BirthChartScreen({super.key});

  @override
  State<BirthChartScreen> createState() => _BirthChartScreenState();
}

class _BirthChartScreenState extends State<BirthChartScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutBack,
          ),
        );

    _animationController.forward();
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
        title: const Text('Birth Chart'),
        backgroundColor: AppColors.surface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hero section
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppConstants.largePadding),
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
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.starGold,
                                  AppColors.starGold.withOpacity(0.8),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.starGold.withOpacity(0.3),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.stars,
                              size: 60,
                              color: AppColors.background,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Discover Your Stars',
                            style: AppTextStyles.h1.copyWith(
                              color: AppColors.starGold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Unveil the cosmic blueprint of your personality through detailed birth chart analysis',
                            style: AppTextStyles.bodyLarge.copyWith(
                              color: AppColors.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Features section
                    Text('What You\'ll Discover', style: AppTextStyles.h2),
                    const SizedBox(height: 20),

                    _buildFeatureItem(
                      icon: Icons.psychology,
                      title: 'Personality Insights',
                      description:
                          'Deep analysis of your core personality traits and characteristics',
                      color: AppColors.primary,
                    ),

                    const SizedBox(height: 16),

                    _buildFeatureItem(
                      icon: Icons.favorite,
                      title: 'Relationship Patterns',
                      description:
                          'How you connect with others and your romantic tendencies',
                      color: AppColors.galaxyPurple,
                    ),

                    const SizedBox(height: 16),

                    _buildFeatureItem(
                      icon: Icons.work,
                      title: 'Career Guidance',
                      description:
                          'Professional paths that align with your cosmic blueprint',
                      color: AppColors.starGold,
                    ),

                    const SizedBox(height: 16),

                    _buildFeatureItem(
                      icon: Icons.trending_up,
                      title: 'Life Themes',
                      description:
                          'Major life lessons and growth opportunities',
                      color: AppColors.success,
                    ),

                    const SizedBox(height: 32),

                    // Birth details form section
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppConstants.largePadding),
                      decoration: BoxDecoration(
                        color: AppColors.cardBackground,
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
                              Icon(
                                Icons.event,
                                color: AppColors.starGold,
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Birth Information Required',
                                style: AppTextStyles.h3,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'To generate your personalized birth chart, we need:',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 16),

                          _buildInfoItem('📅', 'Exact date of birth'),
                          _buildInfoItem('🕐', 'Precise time of birth'),
                          _buildInfoItem('📍', 'City and country of birth'),

                          const SizedBox(height: 20),

                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.warning.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.warning.withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: AppColors.warning,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Time accuracy is crucial for precise analysis',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.warning,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Coming soon section
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppConstants.largePadding),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.starGold.withOpacity(0.1),
                            AppColors.starGold.withOpacity(0.05),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.starGold.withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.construction,
                            size: 48,
                            color: AppColors.starGold,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Feature Coming Soon',
                            style: AppTextStyles.h2.copyWith(
                              color: AppColors.starGold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'We\'re crafting an amazing birth chart experience that will reveal the secrets of your cosmic blueprint. Stay tuned for this powerful feature!',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          GradientButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'You\'ll be notified when Birth Chart is available!',
                                    style: TextStyle(
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  backgroundColor: AppColors.success,
                                ),
                              );
                            },
                            gradientColors: [
                              AppColors.starGold.withOpacity(0.8),
                              AppColors.starGold,
                            ],
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.notifications,
                                  color: AppColors.background,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Notify Me When Ready',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.background,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
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
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.h4),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String emoji, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: AppTextStyles.bodyMedium)),
        ],
      ),
    );
  }
}
