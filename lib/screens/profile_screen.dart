import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:baba_app/constants/app_colors.dart';
import 'package:baba_app/constants/app_text_styles.dart';
import 'package:baba_app/services/auth_provider.dart';
import 'package:baba_app/screens/settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          final user = authProvider.user;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 20),

                // Profile Avatar
                CircleAvatar(
                  radius: 60,
                  backgroundColor: AppColors.starGold,
                  backgroundImage: user?.profile.avatar.isNotEmpty == true
                      ? NetworkImage(user!.profile.avatar)
                      : null,
                  child: user?.profile.avatar.isEmpty != false
                      ? Text(
                          user?.profile.name.isNotEmpty == true
                              ? user!.profile.name[0].toUpperCase()
                              : 'U',
                          style: AppTextStyles.h1.copyWith(
                            color: AppColors.background,
                          ),
                        )
                      : null,
                ),

                const SizedBox(height: 20),

                // User Name
                Text(
                  user?.profile.name ?? 'User',
                  style: AppTextStyles.h2.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 8),

                // User Email
                Text(
                  user?.email ?? 'No email',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 30),

                // Profile Info Cards
                _buildInfoCard(
                  icon: Icons.location_on,
                  title: 'Location',
                  value: user?.profile.city ?? 'Not set',
                ),

                const SizedBox(height: 16),

                _buildInfoCard(
                  icon: Icons.cake,
                  title: 'Age',
                  value: '${user?.profile.age ?? 0} years',
                ),

                const SizedBox(height: 16),

                _buildInfoCard(
                  icon: Icons.phone,
                  title: 'Phone',
                  value: user?.profile.phoneNumber ?? 'Not provided',
                ),

                const SizedBox(height: 30),

                // Action Buttons
                _buildActionButton(
                  icon: Icons.edit,
                  title: 'Edit Profile',
                  onTap: () {
                    // TODO: Navigate to edit profile screen
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Edit Profile coming soon!',
                          style: TextStyle(color: AppColors.textPrimary),
                        ),
                        backgroundColor: AppColors.primary,
                      ),
                    );
                  },
                ),

                const SizedBox(height: 12),

                _buildActionButton(
                  icon: Icons.notifications,
                  title: 'Notifications',
                  onTap: () {
                    // TODO: Navigate to notifications screen
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Notifications settings coming soon!',
                          style: TextStyle(color: AppColors.textPrimary),
                        ),
                        backgroundColor: AppColors.primary,
                      ),
                    );
                  },
                ),

                const SizedBox(height: 12),

                _buildActionButton(
                  icon: Icons.help,
                  title: 'Help & Support',
                  onTap: () {
                    // TODO: Navigate to help screen
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Help & Support coming soon!',
                          style: TextStyle(color: AppColors.textPrimary),
                        ),
                        backgroundColor: AppColors.primary,
                      ),
                    );
                  },
                ),

                const SizedBox(height: 30),

                // Logout Button
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      _showLogoutDialog(context, authProvider);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Logout',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.starGold, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      child: Material(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, color: AppColors.starGold, size: 24),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.textSecondary,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: Text(
          'Logout',
          style: AppTextStyles.h3.copyWith(color: AppColors.textPrimary),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await authProvider.signOut();
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
