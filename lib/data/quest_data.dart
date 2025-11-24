import '../models/quest.dart';

/// Centralized data source for quests
class QuestData {
  /// Get all available quests
  static List<Quest> getAllQuests() {
    return [
      const Quest(
        id: 'sundarkand',
        title: 'सुन्दरकाण्ड',
        imagePath: 'assets/images/sundarkand.jpg',
        learningCount: 2340,
        colorValue: 0xFF4A90E2,
      ),
      const Quest(
        id: 'ramayana',
        title: 'रामायण',
        imagePath: 'assets/images/ramayana.jpg',
        learningCount: 2340,
        colorValue: 0xFF50C878,
      ),
      const Quest(
        id: 'bhagavad_gita',
        title: 'श्रीमद् भगवद् गीता',
        imagePath: 'assets/images/bhagavad_gita.jpg',
        learningCount: 2340,
        colorValue: 0xFF8E44AD,
      ),
      const Quest(
        id: 'durga_saptashati',
        title: 'दुर्गा सप्तशती',
        imagePath: 'assets/images/durga_saptashati.jpg',
        learningCount: 2340,
        colorValue: 0xFFE67E22,
      ),
    ];
  }

  /// Get quest by ID
  static Quest? getQuestById(String id) {
    try {
      return getAllQuests().firstWhere((quest) => quest.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get premium quests only
  static List<Quest> getPremiumQuests() {
    return getAllQuests().where((quest) => quest.isPremium).toList();
  }

  /// Get free quests only
  static List<Quest> getFreeQuests() {
    return getAllQuests().where((quest) => !quest.isPremium).toList();
  }
}
