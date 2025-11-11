import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../constants/app_constants.dart';
import '../widgets/gradient_button.dart';

/// Cosmic insights and wisdom screen
class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen>
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
        title: const Text('Cosmic Insights'),
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
                                  AppColors.galaxyPurple,
                                  AppColors.galaxyPurple.withOpacity(0.8),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.galaxyPurple.withOpacity(
                                    0.3,
                                  ),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.psychology,
                              size: 60,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Cosmic Wisdom',
                            style: AppTextStyles.h1.copyWith(
                              color: AppColors.starGold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Unlock the secrets of the universe and discover profound insights about your life\'s journey',
                            style: AppTextStyles.bodyLarge.copyWith(
                              color: AppColors.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Insight categories
                    Text('Areas of Wisdom', style: AppTextStyles.h2),
                    const SizedBox(height: 20),

                    _buildInsightCategory(
                      icon: Icons.auto_awesome,
                      title: 'Life Purpose',
                      description:
                          'Discover your soul\'s mission and divine calling',
                      color: AppColors.starGold,
                      items: [
                        'Your unique gifts and talents',
                        'Karmic lessons to learn',
                        'Life themes and patterns',
                        'Soul growth opportunities',
                      ],
                    ),

                    const SizedBox(height: 20),

                    _buildInsightCategory(
                      icon: Icons.trending_up,
                      title: 'Personal Growth',
                      description: 'Path to self-improvement and enlightenment',
                      color: AppColors.success,
                      items: [
                        'Areas for development',
                        'Spiritual awakening signs',
                        'Mindfulness practices',
                        'Energy alignment techniques',
                      ],
                    ),

                    const SizedBox(height: 20),

                    _buildInsightCategory(
                      icon: Icons.visibility,
                      title: 'Intuitive Guidance',
                      description:
                          'Connect with your inner wisdom and intuition',
                      color: AppColors.galaxyPurple,
                      items: [
                        'Psychic development tips',
                        'Dream interpretation',
                        'Meditation guidance',
                        'Chakra balancing',
                      ],
                    ),

                    const SizedBox(height: 20),

                    _buildInsightCategory(
                      icon: Icons.calendar_view_month,
                      title: 'Cosmic Timing',
                      description:
                          'Understand the best times for action and reflection',
                      color: AppColors.primary,
                      items: [
                        'Planetary influences',
                        'Moon phase guidance',
                        'Auspicious timing',
                        'Energy forecasts',
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Sample insight card
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.lightbulb,
                                color: AppColors.starGold,
                                size: 28,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Today\'s Insight',
                                style: AppTextStyles.h3.copyWith(
                                  color: AppColors.starGold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '"The universe is constantly conspiring in your favor. Trust the process, embrace change, and remember that every challenge is an opportunity for growth. Your intuition is your compass - listen to its whispers."',
                            style: AppTextStyles.bodyLarge.copyWith(
                              fontStyle: FontStyle.italic,
                              height: 1.6,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '— Ancient Cosmic Wisdom',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
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
                            AppColors.galaxyPurple.withOpacity(0.1),
                            AppColors.galaxyPurple.withOpacity(0.05),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.galaxyPurple.withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.construction,
                            size: 48,
                            color: AppColors.galaxyPurple,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Wisdom Library Coming Soon',
                            style: AppTextStyles.h2.copyWith(
                              color: AppColors.galaxyPurple,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'We\'re curating an extensive library of cosmic wisdom, spiritual insights, and personalized guidance. Prepare for a transformative journey into the mysteries of the universe!',
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
                                    'You\'ll be notified when Cosmic Insights is ready!',
                                    style: TextStyle(
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  backgroundColor: AppColors.success,
                                ),
                              );
                            },
                            gradientColors: [
                              AppColors.galaxyPurple.withOpacity(0.8),
                              AppColors.galaxyPurple,
                            ],
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.notifications,
                                  color: AppColors.textPrimary,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Notify Me When Ready',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.textPrimary,
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

  Widget _buildInsightCategory({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required List<String> items,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.largePadding),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
                    Text(title, style: AppTextStyles.h3.copyWith(color: color)),
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
          const SizedBox(height: 16),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Icon(Icons.fiber_manual_record, color: color, size: 8),
                  const SizedBox(width: 12),
                  Expanded(child: Text(item, style: AppTextStyles.bodyMedium)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
