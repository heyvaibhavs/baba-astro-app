import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../providers/subscription_provider.dart';
import '../services/auth_provider.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../widgets/gradient_button.dart';

/// New subscription screen with promotional video
class SubscriptionVideoScreen extends StatefulWidget {
  /// If provided, called when gate is dismissed
  final VoidCallback? onClose;

  const SubscriptionVideoScreen({Key? key, this.onClose}) : super(key: key);

  @override
  State<SubscriptionVideoScreen> createState() =>
      _SubscriptionVideoScreenState();
}

class _SubscriptionVideoScreenState extends State<SubscriptionVideoScreen> {
  VideoPlayerController? _videoController;
  bool _isVideoLoading = true;
  bool _videoError = false;
  bool _initialized = false;
  String? _videoUrl;
  Map<String, dynamic>? _videoData;
  
  // Toggle this to switch between temporary trial plan and API plan
  static const bool useTemporaryTrialPlan = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      // Use addPostFrameCallback to avoid setState during build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final auth = Provider.of<AuthProvider>(context, listen: false);
        final subProv = Provider.of<SubscriptionProvider>(
          context,
          listen: false,
        );
        if (auth.token != null) {
          print('🎬 Starting subscription and video initialization...');
          subProv.fetchPlans(auth.token!);
          _fetchPromotionalVideo(auth.token!);
        } else {
          print('❌ No auth token available');
          setState(() {
            _videoError = true;
            _isVideoLoading = false;
          });
        }
      });
    }
  }

  Future<void> _fetchPromotionalVideo(String token) async {
    try {
      print('🎬 Fetching promotional video...');
      const baseUrl =
          'https://learner.netaapp.in/api'; // Using the same base URL as auth
      final response = await http.get(
        Uri.parse('$baseUrl/promotional-video'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('🎬 Video API Response Status: ${response.statusCode}');
      print('🎬 Video API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          setState(() {
            _videoData = data['data'];
            _videoUrl = data['data']['videoUrl'];
          });
          print('🎬 Video URL obtained: $_videoUrl');
          await _initializeVideo();
        } else {
          print('❌ Video API returned success: false');
          setState(() {
            _videoError = true;
            _isVideoLoading = false;
          });
        }
      } else {
        print('❌ Video API failed with status: ${response.statusCode}');
        setState(() {
          _videoError = true;
          _isVideoLoading = false;
        });
      }
    } catch (e) {
      print('❌ Error fetching promotional video: $e');
      setState(() {
        _videoError = true;
        _isVideoLoading = false;
      });
    }
  }

  Future<void> _initializeVideo() async {
    if (_videoUrl == null || _videoUrl!.isEmpty) {
      print('❌ Video URL is null or empty');
      setState(() {
        _videoError = true;
        _isVideoLoading = false;
      });
      return;
    }

    try {
      print('🎬 Initializing video with URL: $_videoUrl');
      _videoController = VideoPlayerController.networkUrl(
        Uri.parse(_videoUrl!),
      );
      await _videoController!.initialize();
      _videoController!.setLooping(true);
      _videoController!.play(); // Auto-play the video

      if (mounted) {
        setState(() {
          _isVideoLoading = false;
          _videoError = false;
        });
        print('✅ Video initialized and auto-playing');
      }
    } catch (e) {
      print('❌ Error initializing video: $e');
      if (mounted) {
        setState(() {
          _videoError = true;
          _isVideoLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  /// Handle successful subscription - update premium flag and close with success
  Future<void> _handleSubscriptionSuccess(String planLabel) async {
    print('🎉 Subscription successful for plan: $planLabel');

    // Pause video when showing dialog
    _videoController?.pause();

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

    // After dialog closes, close the subscription screen
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
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // Video Section - Takes remaining space
          Expanded(
            child: Stack(
              children: [
                // Video player
                _buildVideoSection(),

                // Close button overlay
                Positioned(
                  top: MediaQuery.of(context).padding.top + 16,
                  left: 16,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () {
                        if (widget.onClose != null) widget.onClose!();
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom section with plans - Fixed height
          Container(
            decoration: BoxDecoration(
              color: AppColors.background,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 5,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: _buildPlansSection(subProv),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoSection() {
    if (_isVideoLoading) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: AppColors.starGold),
              SizedBox(height: 16),
              Text(
                'Loading promotional video...',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    if (_videoError || _videoController == null) {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary.withOpacity(0.8),
              AppColors.galaxyPurple.withOpacity(0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.auto_awesome, size: 80, color: AppColors.starGold),
              const SizedBox(height: 24),
              Text(
                'Unlock Premium Features',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Get unlimited access to all astrology insights',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Stack(
      children: [
        // Video player
        SizedBox.expand(
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: _videoController!.value.size.width,
              height: _videoController!.value.size.height,
              child: VideoPlayer(_videoController!),
            ),
          ),
        ),

        // Gradient overlay for better text readability
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 100,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.black.withOpacity(0.7), Colors.transparent],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlansSection(SubscriptionProvider subProv) {
    print(
      '🎯 Building plans section - Loading: ${subProv.isLoading}, Error: ${subProv.error}, Plans: ${subProv.plans.length}',
    );

    // If using temporary trial plan, show it regardless of API state
    if (useTemporaryTrialPlan) {
      return _buildTemporaryTrialPlan();
    }

    if (subProv.isLoading) {
      return const SizedBox(
        height: 250,
        child: Center(
          child: CircularProgressIndicator(color: AppColors.starGold),
        ),
      );
    }

    if (subProv.error != null) {
      return SizedBox(
        height: 250,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: AppColors.error),
              const SizedBox(height: 16),
              Text(
                'Failed to load plans',
                style: AppTextStyles.h4,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    if (subProv.plans.isEmpty) {
      return SizedBox(
        height: 250,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textSecondary.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Spacer(),
              Text(
                'No plans available',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      );
    }

    // Show plans similar to original subscription gate
    final plan = subProv.plans.first;
    final showTrial = subProv.trialEligible && plan.freeTrial;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textSecondary.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),

            // Plan Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Plan label with trial badge
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            borderRadius: BorderRadius.circular(20),
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
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            '${plan.currency} ${plan.strikePrice!.toStringAsFixed(0)}',
                            style: AppTextStyles.bodyLarge.copyWith(
                              decoration: TextDecoration.lineThrough,
                              color: AppColors.textHint,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Duration
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
                      print('💳 Processing payment for: ${plan.label}');
                      _handleSubscriptionSuccess(plan.label);
                    },
                    child: Text(
                      showTrial ? 'Start Free Trial' : 'Subscribe Now',
                      style: AppTextStyles.buttonLarge,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Footer
            Text(
              'Cancel anytime. Terms apply.',
              style: AppTextStyles.caption.copyWith(color: AppColors.textHint),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Build temporary 1-day trial plan
  Widget _buildTemporaryTrialPlan() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textSecondary.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),

            // Plan card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Free Trial Badge
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '1-Day Free Trial',
                        style: AppTextStyles.h3.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
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
                        'INR ',
                        style: AppTextStyles.h3.copyWith(
                          color: AppColors.starGold,
                        ),
                      ),
                      Text(
                        '1',
                        style: AppTextStyles.h1.copyWith(
                          color: AppColors.starGold,
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          'INR 99',
                          style: AppTextStyles.bodyLarge.copyWith(
                            decoration: TextDecoration.lineThrough,
                            color: AppColors.textHint,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Duration
                  Text(
                    'Valid for 1 Day',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Auto-renews at INR 99/month',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textHint,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Subscribe button
                  GradientButton(
                    onPressed: () {
                      print('💳 Processing payment for: 1-Day Free Trial');
                      _handleSubscriptionSuccess('1-Day Free Trial');
                    },
                    child: Text(
                      'Subscribe Now',
                      style: AppTextStyles.buttonLarge,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Footer
            Text(
              'Cancel anytime. Terms apply.',
              style: AppTextStyles.caption.copyWith(color: AppColors.textHint),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
