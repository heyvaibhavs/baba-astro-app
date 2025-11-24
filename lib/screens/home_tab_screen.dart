import 'package:flutter/material.dart';
import 'package:baba_app/constants/app_colors.dart';
import 'package:baba_app/services/storage_service.dart';
import 'package:baba_app/screens/hinid_subscription_screen.dart';
import 'package:baba_app/models/quest.dart';
import 'package:baba_app/data/quest_data.dart';
import 'package:baba_app/widgets/app_header.dart';
import 'package:baba_app/widgets/quest_grid.dart';
import 'package:baba_app/widgets/dashed_border_button.dart';
import 'dart:developer' as developer;

class HomeTabScreen extends StatefulWidget {
  const HomeTabScreen({super.key});

  @override
  State<HomeTabScreen> createState() => _HomeTabScreenState();
}

class _HomeTabScreenState extends State<HomeTabScreen> {
  late List<Quest> _quests;

  @override
  void initState() {
    super.initState();
    _quests = QuestData.getAllQuests();
    _checkPremiumStatus();
  }

  Future<void> _checkPremiumStatus() async {
    // Wait for the first frame to be rendered
    await Future.delayed(const Duration(milliseconds: 100));

    if (!mounted) return;

    print(
      '🏠 HomeTabScreen: Checking premium status from SharedPreferences...',
    );
    developer.log(
      'Checking premium status from SharedPreferences',
      name: 'HomeTabScreen',
    );

    // Get premium status from SharedPreferences (already fetched on splash)
    final isPremium = StorageService.getPremiumStatus();

    print('🏠 isPremium from storage: $isPremium');
    developer.log('isPremium from storage: $isPremium', name: 'HomeTabScreen');

    if (!mounted) return;

    if (!isPremium) {
      print('🚀 HomeTabScreen: Showing subscription gate');
      developer.log('Showing subscription gate', name: 'HomeTabScreen');

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => HindiSubscriptionScreen(),
          fullscreenDialog: true,
        ),
      );
    } else {
      print('✅ User is premium - no gate needed');
      developer.log('User is premium - no gate needed', name: 'HomeTabScreen');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Fixed Header - Using reusable component
          const AppHeader(),

          // Scrollable Content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Quests Section
                  _buildQuestsSection(),

                  // Suggest Topic Button - Using reusable component
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: DashedBorderButton(
                      text: 'Suggest a topic',
                      icon: Icons.add,
                      onTap: _showSuggestTopicDialog,
                    ),
                  ),

                  const SizedBox(height: 80), // Space for bottom navigation
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestsSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quests Title
          const Text(
            'Quests',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 16),

          // Quest Grid - Using reusable component
          QuestGrid(quests: _quests, onQuestTap: _handleQuestTap),
        ],
      ),
    );
  }

  /// Handle quest card tap - check premium status and show gate if needed
  Future<void> _handleQuestTap(Quest quest) async {
    print('🎯 Quest tapped: ${quest.title}');
    developer.log('Quest tapped: ${quest.title}', name: 'HomeTabScreen');

    // Check premium status from SharedPreferences
    final isPremium = StorageService.getPremiumStatus();
    print('💎 Premium status: $isPremium');

    if (!isPremium) {
      print('🚀 Showing subscription gate for quest: ${quest.title}');
      developer.log(
        'Showing subscription gate for quest: ${quest.title}',
        name: 'HomeTabScreen',
      );

      // Show subscription gate
      final result = await Navigator.of(context).push<bool>(
        MaterialPageRoute(
          builder: (_) => HindiSubscriptionScreen(),
          fullscreenDialog: true,
        ),
      );

      // If user purchased, check again and navigate to quest
      if (result == true) {
        print('✅ User purchased subscription - navigating to ${quest.title}');
        _navigateToQuest(quest);
      } else {
        print('❌ User cancelled subscription');
      }
    } else {
      print('✅ User is premium - navigating to ${quest.title}');
      _navigateToQuest(quest);
    }
  }

  /// Navigate to the specific quest screen
  void _navigateToQuest(Quest quest) {
    // TODO: Navigate to quest content screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${quest.title} content coming soon!',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  void _showSuggestTopicDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text(
          'Suggest a Topic',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                hintText: 'Enter your topic suggestion...',
                hintStyle: TextStyle(color: Colors.grey.shade600),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.black, width: 2),
                ),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Thank you for your suggestion!',
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
            child: const Text('Submit', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
