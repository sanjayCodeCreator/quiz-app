import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/screens/question_screen.dart';

import '../model/category.dart';
import '../providers/selectedanswers_provider.dart';

class CategoryScreen extends ConsumerWidget {
  const CategoryScreen( {super.key});


  int getCompletedSubCategories(CategoryModel category, List<SelectedAnswer> answers,) {
    int completed = 0;
    for (var sub in category.subCategories) {
      int correct = 0;
      int total = sub.questions.length;

      for (var q in sub.questions) {
        final ans = answers.firstWhere(
              (a) =>
          a.questionId == q.id &&
              a.subCategoryName == sub.name,
          orElse: () => SelectedAnswer(
            questionId: '',
            selectedIndex: -1,
            subCategoryName: '',
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
  int getCompletedCategories(List<CategoryModel> categories, List<SelectedAnswer> answers,) {
    int completedCategories = 0;

    for (var cat in categories) {
      int completedSub = 0;

      for (var sub in cat.subCategories) {
        int correct = 0;
        int total = sub.questions.length;

        for (var q in sub.questions) {
          final ans = answers.firstWhere(
                (a) =>
            a.questionId == q.id &&
                a.subCategoryName == sub.name,
            orElse: () => SelectedAnswer(
              questionId: '',
              selectedIndex: -1,
              subCategoryName: '',
            ),
          );

          if (ans.selectedIndex == q.correctAnswerIndex) {
            correct++;
          }
        }

        double percentage = total == 0 ? 0 : (correct / total) * 100;

        if (percentage >= 60) {
          completedSub++;
        }
      }

      /// ✅ category complete check
      if (completedSub == cat.subCategories.length) {
        completedCategories++;
      }
    }

    return completedCategories;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryAsync = ref.watch(categoryProvider);
    final answers = ref.watch(selectedAnswersProvider);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade800, Colors.purple.shade800],
          ),
        ),
        child: SafeArea(
          child: categoryAsync.when(
            loading: () => const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),

            error: (err, _) => Center(
              child: Text(
                "Error loading categories",
                style: TextStyle(color: Colors.white),
              ),
            ),

            data: (categories) {
              final completedCategories =
              getCompletedCategories(categories, answers);

              final totalCategories = categories.length;
              return Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      "Select Category",
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 30),
                    /// ✅ OVERALL PROGRESS
                    Text(
                      "$completedCategories / $totalCategories Levels Completed",
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    /// GRID
                    Expanded(
                      child: GridView.builder(
                        itemCount: categories.length,
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                        ),
                        itemBuilder: (context, index) {
                          final cat = categories[index];
                          final completed = getCompletedSubCategories(cat, answers);
                          final total = cat.subCategories.length;

                          final isCategoryComplete = completed == total;
                          return GestureDetector(
                            onTap: () {
                              /// SAVE CATEGORY
                              ref.read(selectedCategoryProvider.notifier).state = cat.category;

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => SubCategoryScreen(category: cat),
                                ),
                              );

                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white.withOpacity(0.1),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.quiz,
                                    size: 50,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    cat.category.toUpperCase(),
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 8),

                                  /// ✅ PROGRESS
                                  Text(
                                    "$completed / $total Completed",
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),

                                  const SizedBox(height: 6),

                                  /// ✅ STATUS
                                  Text(
                                    isCategoryComplete ? "Level Completed ✅" : "In Progress",
                                    style: TextStyle(
                                      color: isCategoryComplete ? Colors.greenAccent : Colors.orangeAccent,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

}


class SubCategoryScreen extends ConsumerWidget {
  final CategoryModel category;

  const SubCategoryScreen({super.key, required this.category});

  /// ✅ Correct count function
  int getCorrectCount(
      SubCategoryModel sub,
      List<SelectedAnswer> answers,
      ) {
    int correct = 0;

    for (var q in sub.questions) {
      final ans = answers.firstWhere(
            (a) =>
        a.questionId == q.id &&
            a.subCategoryName == sub.name,
        orElse: () => SelectedAnswer(
          questionId: '',
          selectedIndex: -1,
          subCategoryName: '',
        ),
      );

      if (ans.selectedIndex == q.correctAnswerIndex) {
        correct++;
      }
    }

    return correct;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// ✅ answers yaha read karo
    final answers = ref.watch(selectedAnswersProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(category.category.toUpperCase()),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: category.subCategories.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
        ),
        itemBuilder: (context, index) {
          final sub = category.subCategories[index];

          /// ✅ correct/total calculate
          final correct = getCorrectCount(sub, answers);
          final total = sub.questions.length;
          final percentage = total == 0 ? 0 : (correct / total) * 100;
          final isCompleted = percentage >= 60;
          return GestureDetector(
            onTap: () {
              /// SAVE SUBCATEGORY
              ref.read(selectedSubCategoryProvider.notifier).state = sub;

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const QuestionScreen(),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.blue.shade100,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    sub.name.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// ✅ SHOW SCORE
                  Text(
                    "$correct / $total",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: correct == total
                          ? Colors.green
                          : Colors.black,
                    ),
                  ),
                  Text(
                    isCompleted ? "Level Completed ✅" : "In Progress",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isCompleted ? Colors.green : Colors.orange,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}