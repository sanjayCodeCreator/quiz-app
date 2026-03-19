import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:quiz_app/providers/selectedanswers_provider.dart';


import 'package:quiz_app/screens/category_screen.dart';
class Quiz extends ConsumerStatefulWidget {
  const Quiz({super.key});

  @override
  ConsumerState<Quiz> createState() => _QuizState();
}

class _QuizState extends ConsumerState<Quiz> {
  String activeScreen = 'start_screen';

  /// START → CATEGORY
  void goToCategory() {
    setState(() {
      activeScreen = 'category_screen';
    });
  }

  /// CATEGORY → QUIZ
  void startQuiz() {
    setState(() {
      activeScreen = 'question_screen';
    });
  }

  /// QUIZ → RESULT
  void showResult() {
    final selectedAnswers = ref.read(selectedAnswersProvider);
    final questions = ref.read(questionsProvider);

    if (selectedAnswers.length == questions.length) {
      setState(() {
        activeScreen = 'result_screen';
      });
    }
  }

  /// RESET ALL
  void restart() {
    ref.read(selectedAnswersProvider.notifier).restart();
    ref.read(selectedCategoryProvider.notifier).state = null;

    setState(() {
      activeScreen = 'start_screen';
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget screen;

    return Scaffold(
      body: CategoryScreen(),
    );
  }
}