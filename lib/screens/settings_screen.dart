import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../constants/app_constants.dart';
import '../services/auth_provider.dart';
import '../services/storage_service.dart';
import 'login_screen.dart';
import 'web_view_screen.dart';
import 'notifications_screen.dart';
import 'about_app_screen.dart';

/// Settings screen with profile card and various options
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _handleLogout(BuildContext context) async {
    // Show confirmation dialog
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: Text('Logout', style: AppTextStyles.h3),
        content: Text(
          'Are you sure you want to logout?',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Logout',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error),
            ),
          ),
        ],
      ),
    );

    if (shouldLogout == true && context.mounted) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.signOut();

      if (context.mounted) {
        // Clear entire navigation stack and go to login screen
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false, // Remove all previous routes
        );
      }
    }
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$feature - Coming Soon!',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.help_outline, color: AppColors.starGold, size: 24),
            const SizedBox(width: 8),
            Text(
              'Help & Support',
              style: AppTextStyles.h3.copyWith(color: AppColors.starGold),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Need assistance? Contact our support team through any of these channels:',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 20),

            // WhatsApp
            _buildContactOption(
              icon: Icons.message,
              title: 'WhatsApp',
              subtitle: 'Chat with us on WhatsApp',
              color: const Color(0xFF25D366),
              onTap: () {
                _launchUrl('https://wa.me/918618187668');
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 12),

            // Phone Call
            _buildContactOption(
              icon: Icons.phone,
              title: 'Call Us',
              subtitle: '8618187668',
              color: AppColors.primary,
              onTap: () {
                _launchUrl('tel:8618187668');
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 12),

            // Email
            _buildContactOption(
              icon: Icons.email,
              title: 'Email',
              subtitle: 'babaapp@gumbotech.in',
              color: AppColors.starGold,
              onTap: () {
                _launchUrl('mailto:babaapp@gumbotech.in');
                Navigator.pop(context);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: ListTile(
        leading: Icon(icon, color: color, size: 24),
        title: Text(
          title,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: color, size: 16),
        onTap: onTap,
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: AppColors.surface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            final user = authProvider.user;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Card
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
                                        ? user!.profile.name[0].toUpperCase()
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user?.profile.name ?? 'User',
                                  style: AppTextStyles.h3.copyWith(
                                    color: AppColors.starGold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  user?.email ?? '',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                if (user?.phoneNumber.isNotEmpty == true)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 4),
                                    child: Row(
                                      children: [
                                        // Icon(
                                        //   Icons.phone,
                                        //   size: 14,
                                        //   color: AppColors.textSecondary,
                                        // ),
                                        // const SizedBox(width: 6),
                                        Text(
                                          user!.phoneNumber,
                                          style: AppTextStyles.bodySmall
                                              .copyWith(
                                                color: AppColors.textSecondary,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                const SizedBox(height: 8),

                                // Premium Badge
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: (user?.isPremium ?? false)
                                        ? AppColors.starGold
                                        : AppColors.textSecondary.withOpacity(
                                            0.3,
                                          ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        (user?.isPremium ?? false)
                                            ? Icons.workspace_premium
                                            : Icons.person_outline,
                                        size: 14,
                                        color: (user?.isPremium ?? false)
                                            ? AppColors.background
                                            : AppColors.textSecondary,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        (user?.isPremium ?? false)
                                            ? 'Premium'
                                            : 'Free User',
                                        style: AppTextStyles.caption.copyWith(
                                          color: (user?.isPremium ?? false)
                                              ? AppColors.background
                                              : AppColors.textSecondary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Edit button
                          IconButton(
                            icon: Icon(Icons.edit, color: AppColors.starGold),
                            onPressed: () =>
                                _showComingSoon(context, 'Edit Profile'),
                            tooltip: 'Edit Profile',
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.cardBackground.withOpacity(0.5),
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

                // General Settings
                Text(
                  'General',
                  style: AppTextStyles.h3.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),

                // Notifications
                _buildSettingsTile(
                  context: context,
                  icon: Icons.notifications_outlined,
                  title: 'Notifications',
                  subtitle: 'Manage your notification preferences',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const NotificationsScreen(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 8),

                // About App
                _buildSettingsTile(
                  context: context,
                  icon: Icons.info_outline,
                  title: 'About App',
                  subtitle: 'Learn more about Baba App',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AboutAppScreen()),
                    );
                  },
                ),

                const SizedBox(height: 8),

                // Help & Support
                _buildSettingsTile(
                  context: context,
                  icon: Icons.help_outline,
                  title: 'Help & Support',
                  subtitle: 'Get help or contact support',
                  onTap: () => _showHelpDialog(context),
                ),

                const SizedBox(height: 24),

                // Legal Section
                Text(
                  'Legal',
                  style: AppTextStyles.h3.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),

                // Privacy Policy
                _buildSettingsTile(
                  context: context,
                  icon: Icons.privacy_tip_outlined,
                  title: 'Privacy Policy',
                  subtitle: 'Read our privacy policy',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WebViewScreen(
                          url: 'https://gumbotech.in/Baba-app-privacy-policy',
                          title: 'Privacy Policy',
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 8),

                // Terms & Conditions
                _buildSettingsTile(
                  context: context,
                  icon: Icons.description_outlined,
                  title: 'Terms & Conditions',
                  subtitle: 'Read our terms and conditions',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WebViewScreen(
                          url:
                              'https://gumbotech.in/Baba-app-terms-and-conditions',
                          title: 'Terms & Conditions',
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 8),

                // Refund Policy
                _buildSettingsTile(
                  context: context,
                  icon: Icons.policy_outlined,
                  title: 'Refund Policy',
                  subtitle: 'Read our refund and cancellation policy',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WebViewScreen(
                          url:
                              'https://gumbotech.in/Baba-app-refund-cancellation-policy',
                          title: 'Refund Policy',
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 24),

                // Account Section
                Text(
                  'Account',
                  style: AppTextStyles.h3.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),

                // Manage Subscription - Show only if user is premium
                if (StorageService.getPremiumStatus())
                  Column(
                    children: [
                      _buildSettingsTile(
                        context: context,
                        icon: Icons.card_membership_outlined,
                        title: 'Manage Subscription',
                        subtitle: 'View and manage your subscription plan',
                        onTap: () =>
                            _showComingSoon(context, 'Manage Subscription'),
                        iconColor: AppColors.starGold,
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),

                // Delete Account
                _buildSettingsTile(
                  context: context,
                  icon: Icons.delete_outline,
                  title: 'Delete Account',
                  subtitle: 'Permanently delete your account',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WebViewScreen(
                          url:
                              'https://gumbotech.in/Baba-app-account-deletion-policy',
                          title: 'Account Deletion',
                        ),
                      ),
                    );
                  },
                  iconColor: AppColors.error,
                  titleColor: AppColors.error,
                ),

                const SizedBox(height: 8),

                // Logout
                _buildSettingsTile(
                  context: context,
                  icon: Icons.logout,
                  title: 'Logout',
                  subtitle: 'Sign out of your account',
                  onTap: () => _handleLogout(context),
                  iconColor: AppColors.error,
                  titleColor: AppColors.error,
                ),

                const SizedBox(height: 24),

                // App Version (centered at bottom)
                Center(
                  child: Text(
                    'Version 1.0.0',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? iconColor,
    Color? titleColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: iconColor ?? AppColors.starGold),
        title: Text(
          title,
          style: AppTextStyles.h4.copyWith(
            color: titleColor ?? AppColors.textPrimary,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        trailing: Icon(Icons.chevron_right, color: AppColors.textSecondary),
        onTap: onTap,
      ),
    );
  }
}
