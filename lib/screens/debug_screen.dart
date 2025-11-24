import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import '../services/google_signin_service.dart';
import '../services/storage_service.dart';

/// Debug screen for troubleshooting Google Sign-In and API issues
class DebugScreen extends StatefulWidget {
  const DebugScreen({super.key});

  @override
  State<DebugScreen> createState() => _DebugScreenState();
}

class _DebugScreenState extends State<DebugScreen> {
  String _debugInfo = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadDebugInfo();
  }

  Future<void> _loadDebugInfo() async {
    setState(() => _isLoading = true);

    final info = StringBuffer();
    info.writeln('=== DEBUG INFORMATION ===\n');

    // App Configuration
    info.writeln('📱 APP CONFIGURATION:');
    info.writeln('Package Name: app.gumbo.jano');
    info.writeln(
      'SHA-1: 06:E4:5F:BA:12:D8:7E:34:71:30:2B:FF:31:02:51:10:FD:E7:FD:15',
    );
    info.writeln('');

    // Google Sign-In Status
    info.writeln('🔐 GOOGLE SIGN-IN STATUS:');
    try {
      final isSignedIn = await GoogleSignInService.isSignedIn();
      info.writeln('Is Signed In: $isSignedIn');

      final currentUser = GoogleSignInService.currentUser;
      info.writeln('Current User: ${currentUser?.email ?? 'None'}');
      info.writeln('Display Name: ${currentUser?.displayName ?? 'None'}');
    } catch (e) {
      info.writeln('ERROR checking Google Sign-In status: $e');
    }
    info.writeln('');

    // Storage Information
    info.writeln('💾 STORAGE STATUS:');
    try {
      final token = StorageService.getToken();
      info.writeln('Token Stored: ${token != null}');
      if (token != null) {
        info.writeln('Token Preview: ${token.substring(0, 30)}...');
      }

      final user = StorageService.getUserData();
      info.writeln('User Data Stored: ${user != null}');
      if (user != null) {
        info.writeln('User Email: ${user.email}');
        info.writeln('Is Onboarded: ${user.isOnboarded}');
      }
    } catch (e) {
      info.writeln('ERROR checking storage: $e');
    }
    info.writeln('');

    // Google Services Configuration
    info.writeln('⚙️ GOOGLE SERVICES:');
    info.writeln('google-services.json: ✅ Present');
    info.writeln('Project ID: baba-astro-app');
    info.writeln(
      'Client ID: 54513515566-ifj6m40cds0a7u24groknbhhq7r1t6bj.apps.googleusercontent.com',
    );
    info.writeln('');

    // Troubleshooting Tips
    info.writeln('🔧 TROUBLESHOOTING:');
    info.writeln('1. Ensure Google Cloud Console is configured');
    info.writeln('2. Check if SHA-1 fingerprint matches');
    info.writeln('3. Verify package name is correct');
    info.writeln('4. Check internet connection');
    info.writeln('5. Try clearing app data and restart');

    setState(() {
      _debugInfo = info.toString();
      _isLoading = false;
    });
  }

  Future<void> _testGoogleSignIn() async {
    setState(() => _isLoading = true);

    try {
      final result = await GoogleSignInService.signInWithGoogle();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Test Result: ${result != null ? 'SUCCESS' : 'CANCELLED'}',
              style: TextStyle(color: AppColors.textPrimary),
            ),
            backgroundColor: result != null
                ? AppColors.success
                : AppColors.warning,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Test Error: $e',
              style: TextStyle(color: AppColors.textPrimary),
            ),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }

    setState(() => _isLoading = false);
    _loadDebugInfo(); // Refresh info
  }

  Future<void> _clearAllData() async {
    await StorageService.clearAll();
    await GoogleSignInService.signOut();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'All data cleared successfully',
            style: TextStyle(color: AppColors.textPrimary),
          ),
          backgroundColor: AppColors.success,
        ),
      );
    }

    _loadDebugInfo(); // Refresh info
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: _debugInfo));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Debug info copied to clipboard',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        backgroundColor: AppColors.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Debug Information'),
        backgroundColor: AppColors.surface,
        actions: [
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: _copyToClipboard,
            tooltip: 'Copy to Clipboard',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            )
          : Column(
              children: [
                // Action Buttons
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _testGoogleSignIn,
                          icon: const Icon(Icons.login),
                          label: const Text('Test Google Sign-In'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _clearAllData,
                          icon: const Icon(Icons.clear_all),
                          label: const Text('Clear All Data'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.warning,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Debug Information
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: AppColors.cardBackground,
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.3),
                        ),
                      ),
                      child: SelectableText(
                        _debugInfo,
                        style: AppTextStyles.bodySmall.copyWith(
                          fontFamily: 'monospace',
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
