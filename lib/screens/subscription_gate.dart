import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/subscription_provider.dart';
import '../services/auth_provider.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../widgets/gradient_button.dart';

/// Reusable subscription gate screen/widget.
/// Present this from any screen when content is locked and user is not premium.
class SubscriptionGate extends StatefulWidget {
  /// If provided, called when gate is dismissed
  final VoidCallback? onClose;

  const SubscriptionGate({Key? key, this.onClose}) : super(key: key);

  @override
  State<SubscriptionGate> createState() => _SubscriptionGateState();
}

class _SubscriptionGateState extends State<SubscriptionGate> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      final subProv = Provider.of<SubscriptionProvider>(context, listen: false);
      if (auth.token != null) {
        subProv.fetchPlans(auth.token!);
      }
      _initialized = true;
    }
  }

  /// Handle successful subscription - update premium flag and close with success
  Future<void> _handleSubscriptionSuccess(String planLabel) async {
    print('🎉 Subscription successful for plan: $planLabel');

    // Update premium status locally
    final auth = Provider.of<AuthProvider>(context, listen: false);
    await auth.updatePremiumStatus(true);

    print('✅ Premium flag updated to true');

    // Show modern payment success dialog
    if (mounted) {
      await _showPaymentSuccessDialog(planLabel);
    }
  }

  /// Show modern payment success dialog with refund information
  Future<void> _showPaymentSuccessDialog(String planLabel) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return WillPopScope(
          onWillPop: () async => false, // Prevent back button
          child: Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.cardBackground, AppColors.surface],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.success.withOpacity(0.5),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.success.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Success Icon
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.success.withOpacity(0.2),
                      border: Border.all(color: AppColors.success, width: 3),
                    ),
                    child: const Icon(
                      Icons.check_circle,
                      color: AppColors.success,
                      size: 50,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Title
                  Text(
                    'Payment Successful!',
                    style: AppTextStyles.h2.copyWith(
                      color: AppColors.success,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),

                  // Refund Information
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.warning.withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: AppColors.starGold,
                          size: 32,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Testing Mode',
                          style: AppTextStyles.h3.copyWith(
                            color: AppColors.starGold,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'We are currently testing our payment system. We promise to refund your full amount within 3-5 working days to your original payment source.',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textPrimary,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Buttons
                  Row(
                    children: [
                      // Help Button
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Help & Support - Coming Soon!',
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                backgroundColor: AppColors.primary,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: BorderSide(
                              color: AppColors.primary,
                              width: 2,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.help_outline,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Help',
                                style: AppTextStyles.buttonMedium.copyWith(
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // OK Button
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(dialogContext).pop(); // Close dialog
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: AppColors.success,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.check, color: AppColors.textPrimary),
                              const SizedBox(width: 8),
                              Text(
                                'OK',
                                style: AppTextStyles.buttonMedium.copyWith(
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    // After dialog closes, close the subscription gate
    if (mounted) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final subProv = Provider.of<SubscriptionProvider>(context);

    // Decide whether to show this gate: if user is premium or subscription active, we shouldn't show
    final user = auth.user;
    final isPremium = user?.isPremium ?? user?.subscription.isActive ?? false;

    if (isPremium) {
      // If user is premium and this was pushed accidentally, just close after frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (widget.onClose != null) widget.onClose!();
        Navigator.of(context).maybePop();
      });
      return const SizedBox.shrink();
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textPrimary),
          onPressed: () {
            if (widget.onClose != null) widget.onClose!();
            Navigator.of(context).pop();
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (widget.onClose != null) widget.onClose!();
              Navigator.of(context).pop();
            },
            child: Text(
              'Maybe later',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
      body: subProv.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.starGold),
            )
          : subProv.error != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppColors.error,
                  ),
                  const SizedBox(height: 16),
                  Text('Failed to load plans', style: AppTextStyles.h3),
                  const SizedBox(height: 8),
                  Text(
                    subProv.error!,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Premium icon
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            AppColors.starGold,
                            AppColors.starGold.withOpacity(0.6),
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
                      child: const Icon(
                        Icons.workspace_premium,
                        size: 40,
                        color: AppColors.background,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Title
                    Text(
                      'Unlock Premium',
                      style: AppTextStyles.h1.copyWith(
                        color: AppColors.starGold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),

                    // Subtitle
                    Text(
                      'Get unlimited access to all features',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),

                    // Benefits
                    _buildBenefit(
                      Icons.psychology,
                      'Personalized Predictions',
                      'Get accurate astrology readings',
                    ),
                    const SizedBox(height: 16),
                    _buildBenefit(
                      Icons.auto_awesome,
                      'Daily Horoscope',
                      'Access detailed daily insights',
                    ),
                    const SizedBox(height: 16),
                    _buildBenefit(
                      Icons.explore,
                      'Compatibility Reports',
                      'Discover relationship insights',
                    ),
                    const SizedBox(height: 32),

                    // Trial banner
                    if (subProv.trialEligible)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.success.withOpacity(0.2),
                              AppColors.success.withOpacity(0.05),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.success.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.success.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.local_offer,
                                color: AppColors.success,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Special Offer',
                                    style: AppTextStyles.bodyLarge.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.success,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'You are eligible for a free trial',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (subProv.trialEligible) const SizedBox(height: 24),

                    // Plans
                    if (subProv.plans.isEmpty)
                      Center(
                        child: Text(
                          'No plans available at the moment.',
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      )
                    else
                      ...subProv.plans.map((plan) {
                        final showTrial =
                            subProv.trialEligible && plan.freeTrial;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.primary.withOpacity(0.3),
                                AppColors.galaxyPurple.withOpacity(0.1),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.primary.withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Plan label
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Monthly Plan',
                                      style: AppTextStyles.h3.copyWith(
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    if (showTrial)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.starGold,
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: Text(
                                          'FREE TRIAL',
                                          style: AppTextStyles.caption.copyWith(
                                            color: AppColors.background,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 16),

                                // Price
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${plan.currency} ',
                                      style: AppTextStyles.h3.copyWith(
                                        color: AppColors.starGold,
                                      ),
                                    ),
                                    Text(
                                      '${plan.price.toStringAsFixed(0)}',
                                      style: AppTextStyles.h1.copyWith(
                                        color: AppColors.starGold,
                                        fontSize: 48,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    if (plan.strikePrice != null)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 8,
                                        ),
                                        child: Text(
                                          '${plan.currency} ${plan.strikePrice!.toStringAsFixed(0)}',
                                          style: AppTextStyles.bodyLarge
                                              .copyWith(
                                                decoration:
                                                    TextDecoration.lineThrough,
                                                color: AppColors.textHint,
                                              ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 8), // Duration
                                Text(
                                  'Valid for ${plan.validityInDays} days',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Billed ${plan.billingCycle}',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.textHint,
                                  ),
                                ),
                                const SizedBox(height: 20),

                                // Subscribe button
                                GradientButton(
                                  onPressed: () {
                                    // TODO: Integrate actual payment gateway here
                                    // For now, simulate successful payment
                                    print(
                                      '💳 Processing payment for: ${plan.label}',
                                    );

                                    // Call success handler which updates premium flag
                                    _handleSubscriptionSuccess(plan.label);
                                  },
                                  child: Text(
                                    showTrial
                                        ? 'Start Free Trial'
                                        : 'Subscribe Now',
                                    style: AppTextStyles.buttonLarge,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    const SizedBox(height: 16),

                    // Footer
                    Text(
                      'Cancel anytime. Terms and conditions apply.',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textHint,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildBenefit(IconData icon, String title, String description) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.starGold, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
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
    );
  }
}
