import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/category.dart';

/// LOAD JSON
final categoryProvider = FutureProvider<List<CategoryModel>>((ref) async {
  final data = await rootBundle.loadString('assets/questions.json');
  final jsonData = json.decode(data) as List;

  return jsonData
      .map((e) => CategoryModel.fromJson(e))
      .toList();
});

/// SELECTED CATEGORY
final selectedCategoryProvider = StateProvider<String?>((ref) => null);

/// FILTER QUESTIONS BASED ON CATEGORY
final selectedSubCategoryProvider = StateProvider<SubCategoryModel?>((ref) => null);
final questionsProvider = Provider<List<QuestionModel>>((ref) {
  final subCategory = ref.watch(selectedSubCategoryProvider);

  if (subCategory == null) return [];

  return subCategory.questions;
});
/// =============================
/// ✅ SELECTED ANSWER MODEL
/// =============================
class SelectedAnswer {
  final String questionId;
  final int selectedIndex;
  final String subCategoryName;

  SelectedAnswer({
    required this.questionId,
    required this.selectedIndex,
    required this.subCategoryName,
  });
}

/// =============================
/// ✅ NOTIFIER
/// =============================
class SelectedAnswersNotifier extends StateNotifier<List<SelectedAnswer>> {
  SelectedAnswersNotifier() : super([]);
  void chooseAnswer(String questionId, int selectedIndex, String subCategoryName) {
    state = [
      ...state,
      SelectedAnswer(
        questionId: questionId,
        selectedIndex: selectedIndex,
        subCategoryName: subCategoryName,
      ),
    ];

    /// ✅ DEBUG PRINT (बस data dekhne ke liye)
    debugPrint("--------- ANSWER ADDED ---------");
    debugPrint("QuestionId: $questionId");
    debugPrint("Selected Index: $selectedIndex");
    debugPrint("SubCategory: $subCategoryName");

    /// पूरा state print
    for (var a in state) {
      debugPrint(
          "Q: ${a.questionId}, Ans: ${a.selectedIndex}, Sub: ${a.subCategoryName}");
    }

    debugPrint("Total Answers: ${state.length}");
    debugPrint("--------------------------------");
  }
  void restart() {
    state = [];
  }
}

/// =============================
/// ✅ PROVIDER
/// =============================
final selectedAnswersProvider =
StateNotifierProvider<SelectedAnswersNotifier, List<SelectedAnswer>>(
      (ref) => SelectedAnswersNotifier(),
);