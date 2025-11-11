import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../constants/app_constants.dart';
import '../services/horoscope_service.dart';
import '../widgets/gradient_button.dart';

/// Compatibility analysis screen for relationship matching
class CompatibilityScreen extends StatefulWidget {
  const CompatibilityScreen({super.key});

  @override
  State<CompatibilityScreen> createState() => _CompatibilityScreenState();
}

class _CompatibilityScreenState extends State<CompatibilityScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  String _yourSign = 'Cancer';
  String _partnerSign = 'Leo';

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
        title: const Text('Compatibility'),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.starGold,
                                      AppColors.starGold.withOpacity(0.8),
                                    ],
                                  ),
                                ),
                                child: Icon(
                                  Icons.person,
                                  size: 32,
                                  color: AppColors.background,
                                ),
                              ),
                              const SizedBox(width: 20),
                              Icon(
                                Icons.favorite,
                                size: 40,
                                color: AppColors.error,
                              ),
                              const SizedBox(width: 20),
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.galaxyPurple,
                                      AppColors.galaxyPurple.withOpacity(0.8),
                                    ],
                                  ),
                                ),
                                child: Icon(
                                  Icons.person,
                                  size: 32,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Find Your Match',
                            style: AppTextStyles.h1.copyWith(
                              color: AppColors.starGold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Discover the cosmic chemistry between you and your partner through astrological compatibility',
                            style: AppTextStyles.bodyLarge.copyWith(
                              color: AppColors.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Sign selection section
                    Text('Select Zodiac Signs', style: AppTextStyles.h2),
                    const SizedBox(height: 20),

                    // Your sign
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.cardBackground,
                        borderRadius: BorderRadius.circular(12),
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
                                Icons.person,
                                color: AppColors.starGold,
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Your Sign',
                                style: AppTextStyles.h4.copyWith(
                                  color: AppColors.starGold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _yourSign,
                                isExpanded: true,
                                style: AppTextStyles.bodyLarge,
                                dropdownColor: AppColors.surface,
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    setState(() {
                                      _yourSign = newValue;
                                    });
                                  }
                                },
                                items: HoroscopeService.zodiacSigns
                                    .map<DropdownMenuItem<String>>((
                                      String value,
                                    ) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.stars,
                                              color: AppColors.starGold,
                                              size: 16,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(value),
                                          ],
                                        ),
                                      );
                                    })
                                    .toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Partner sign
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.cardBackground,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.galaxyPurple.withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.favorite,
                                color: AppColors.galaxyPurple,
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Partner\'s Sign',
                                style: AppTextStyles.h4.copyWith(
                                  color: AppColors.galaxyPurple,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _partnerSign,
                                isExpanded: true,
                                style: AppTextStyles.bodyLarge,
                                dropdownColor: AppColors.surface,
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    setState(() {
                                      _partnerSign = newValue;
                                    });
                                  }
                                },
                                items: HoroscopeService.zodiacSigns
                                    .map<DropdownMenuItem<String>>((
                                      String value,
                                    ) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.stars,
                                              color: AppColors.galaxyPurple,
                                              size: 16,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(value),
                                          ],
                                        ),
                                      );
                                    })
                                    .toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Analysis button
                    GradientButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Analyzing compatibility between $_yourSign and $_partnerSign...',
                              style: TextStyle(color: AppColors.textPrimary),
                            ),
                            backgroundColor: AppColors.primary,
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.psychology,
                            color: AppColors.textPrimary,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Analyze Compatibility',
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // What you'll learn section
                    Text('What You\'ll Learn', style: AppTextStyles.h2),
                    const SizedBox(height: 20),

                    _buildInsightCard(
                      icon: Icons.favorite,
                      title: 'Love Compatibility',
                      description:
                          'How well you connect romantically and emotionally',
                      color: AppColors.error,
                    ),

                    const SizedBox(height: 16),

                    _buildInsightCard(
                      icon: Icons.chat,
                      title: 'Communication Style',
                      description:
                          'How you understand and communicate with each other',
                      color: AppColors.primary,
                    ),

                    const SizedBox(height: 16),

                    _buildInsightCard(
                      icon: Icons.handshake,
                      title: 'Relationship Dynamics',
                      description: 'Power balance and partnership patterns',
                      color: AppColors.galaxyPurple,
                    ),

                    const SizedBox(height: 16),

                    _buildInsightCard(
                      icon: Icons.trending_up,
                      title: 'Growth Potential',
                      description: 'Areas where your relationship can flourish',
                      color: AppColors.success,
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
                            'We\'re developing a comprehensive compatibility analysis system that will reveal the deeper connections between cosmic energies. Get ready for amazing insights!',
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
                                    'You\'ll be notified when Compatibility Analysis is ready!',
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

  Widget _buildInsightCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
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
}
