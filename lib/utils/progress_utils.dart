



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/category.dart';
import '../providers/selectedanswers_provider.dart';

/// ✅ SubCategory Completion
int getCompletedSubCategories(
    CategoryModel category,
    List<SelectedAnswer> answers,
    ) {
  int completed = 0;

  for (var sub in category.subCategories) {
    int correct = 0;
    int total = sub.questions.length;

    for (var q in sub.questions) {
      final ans = answers.firstWhere(
            (a) =>
        a.questionId == q.id &&
            a.subCategoryId == sub.id,
        orElse: () => SelectedAnswer(
          questionId: '',
          selectedIndex: -1,
          subCategoryId: '',
        ),
      );

      if (ans.selectedIndex == q.correctAnswerIndex) {
        correct++;
      }
    }

    double percentage = total == 0 ? 0 : (correct / total) * 100;

    if (percentage >= 60) {
      completed++;
    }
  }

  return completed;
}

/// ✅ Category Completion
int getCompletedCategories(
    List<CategoryModel> categories,
    List<SelectedAnswer> answers,
    ) {
  int completedCategories = 0;

  for (var cat in categories) {
    int completedSub = getCompletedSubCategories(cat, answers);

    /// ✅ reuse above function 🔥
    if (completedSub == cat.subCategories.length) {
      completedCategories++;
    }
  }

  return completedCategories;
}

IconData getCategoryIcon(String category) {
  switch (category.toLowerCase()) {
    case "technical":
      return Icons.computer;

    case "historical":
      return Icons.history_edu;

    case "gk":
      return Icons.public;

    case "maths":
      return Icons.calculate;

    case "science":
      return Icons.science;

    case "agriculture":
      return Icons.agriculture;

    default:
      return Icons.quiz;
  }
}
