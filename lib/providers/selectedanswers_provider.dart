import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/category.dart';
import '../utils/prefs_service.dart';

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
  final String subCategoryId;

  SelectedAnswer({
    required this.questionId,
    required this.selectedIndex,
    required this.subCategoryId,
  });

  /// ✅ TO JSON
  Map<String, dynamic> toJson() {
    return {
      "questionId": questionId,
      "selectedIndex": selectedIndex,
      "subCategoryId": subCategoryId,
    };
  }

  /// ✅ FROM JSON
  factory SelectedAnswer.fromJson(Map<String, dynamic> json) {
    return SelectedAnswer(
      questionId: json["questionId"],
      selectedIndex: json["selectedIndex"],
      subCategoryId: json["subCategoryId"],
    );
  }
}

/// =============================
/// ✅ NOTIFIER
/// =============================
class SelectedAnswersNotifier extends StateNotifier<List<SelectedAnswer>> {
  SelectedAnswersNotifier() : super([]) {
    loadAnswers(); // ✅ app start pe load
  }
  /// LOAD
  void loadAnswers() {
    final data = PrefsService.getString("answers");

    if (data != null) {
      final decoded = jsonDecode(data) as List;

      state = decoded
          .map((e) => SelectedAnswer.fromJson(e))
          .toList();
    }
  }

  /// SAVE
  void saveAnswers() {
    final jsonList = state.map((e) => e.toJson()).toList();
    PrefsService.setString("answers", jsonEncode(jsonList));
  }
  /// =========================
  /// ADD / UPDATE ANSWER
  void chooseAnswer(String questionId, int selectedIndex, String subCategoryId) {
    state = state.where((a) => a.questionId != questionId).toList();

    state = [
      ...state,
      SelectedAnswer(
        questionId: questionId,
        selectedIndex: selectedIndex,
        subCategoryId: subCategoryId,
      ),
    ];

    saveAnswers(); // ✅ clean
  }
  /// =========================
  /// RESET
  /// =========================
  void restart() async {
    state = [];

    final prefs = await SharedPreferences.getInstance();
    prefs.remove("answers"); // ✅ clear storage
  }
}

/// =============================
/// ✅ PROVIDER
/// =============================
final selectedAnswersProvider =
StateNotifierProvider<SelectedAnswersNotifier, List<SelectedAnswer>>(
      (ref) => SelectedAnswersNotifier(),
);