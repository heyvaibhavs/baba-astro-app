import 'package:flutter/material.dart';
import 'package:baba_app/models/quest.dart';
import 'package:baba_app/widgets/quest_card.dart';

/// Reusable Quest Grid Widget
class QuestGrid extends StatelessWidget {
  final List<Quest> quests;
  final Function(Quest) onQuestTap;

  const QuestGrid({super.key, required this.quests, required this.onQuestTap});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        mainAxisExtent: 264,
      ),
      itemCount: quests.length,
      itemBuilder: (context, index) {
        final quest = quests[index];
        return QuestCard(
          title: quest.title,
          learningCount: quest.learningCount,
          gradientColor: Color(quest.colorValue),
          onTap: () => onQuestTap(quest),
        );
      },
    );
  }
}
