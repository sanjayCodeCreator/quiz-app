import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../providers/selectedanswers_provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../providers/selectedanswers_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/selectedanswers_provider.dart';
import 'category_screen.dart';
class QuestionScreen extends ConsumerStatefulWidget {
  const QuestionScreen({super.key});

  @override
  ConsumerState<QuestionScreen> createState() => _QuestionState();
}

class _QuestionState extends ConsumerState<QuestionScreen> {
  int currentIndex = 0;
  bool isAnswered = false;

  void selectAnswer(int selectedIndex) {
    if (isAnswered) return;
    isAnswered = true;

    final questions = ref.read(questionsProvider);
    final currentQuestion = questions[currentIndex];


    print("selectAnswer questions ${questions.toString()} currentQuestion -->${currentQuestion} selectedIndex ${selectedIndex}");
    /// ✅ GET SUBCATEGORY
    final subCategory = ref.read(selectedSubCategoryProvider);
    print("selectAnswer questions ${subCategory}");

    /// SAVE ANSWER
    ref.read(selectedAnswersProvider.notifier).chooseAnswer(
      currentQuestion.id,
      selectedIndex,
      subCategory!.id,
    );

    /// NEXT / RESULT
    Future.delayed(const Duration(milliseconds: 300), () {
      if (currentIndex < questions.length - 1) {
        setState(() {
          currentIndex++;
          isAnswered = false;
        });
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const ResultScreen(),
          ),
        );
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    final questions = ref.watch(questionsProvider);

    if (questions.isEmpty) {
      return const Scaffold(
        body: Center(child: Text("No Questions Found")),
      );
    }

    final question = questions[currentIndex];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade800, Colors.purple.shade800],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                /// PROGRESS
                LinearProgressIndicator(
                  value: (currentIndex + 1) / questions.length,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  valueColor:
                  const AlwaysStoppedAnimation<Color>(Colors.white),
                ),

                const SizedBox(height: 20),

                Text(
                  "Question ${currentIndex + 1}/${questions.length}",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),

                const SizedBox(height: 30),

                /// QUESTION
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      question.question,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                /// OPTIONS
                Expanded(
                  child: ListView.builder(
                    itemCount: question.options.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: ElevatedButton(
                          onPressed: () {
                             selectAnswer(index);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.blue.shade800,
                            padding:
                            const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            question.options[index],
                            style: GoogleFonts.poppins(fontSize: 18),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



class ResultScreen extends ConsumerWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questions = ref.watch(questionsProvider);
    final answers = ref.watch(selectedAnswersProvider);

    /// ✅ Convert answers list -> Map (questionId based)
    final answerMap = {
      for (var a in answers) a.questionId: a
    };

    /// ✅ Correct Score Calculation
    int score = 0;
    for (final q in questions) {
      final answer = answerMap[q.id];

      if (answer != null &&
          answer.selectedIndex == q.correctAnswerIndex) {
        score++;
      }
    }

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const CategoryScreen()),
              (route) => false,
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Result"),
          backgroundColor: Colors.transparent, // important
          elevation: 0, // shadow hata do clean look ke liye

          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue.shade800,
                  Colors.purple.shade800,
                ],
              ),
            ),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade800, Colors.purple.shade800],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                /// ✅ SCORE
                Text(
                  "Score: $score / ${questions.length}",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                /// ✅ LIST
                Expanded(
                  child: ListView.builder(
                    itemCount: questions.length,
                    itemBuilder: (context, index) {
                      final question = questions[index];

                      /// ✅ GET ANSWER FROM MAP
                      final answer = answerMap[question.id];
                      final selectedAnswerIndex = answer?.selectedIndex;

                      final isCorrect =
                          selectedAnswerIndex == question.correctAnswerIndex;

                      return Card(
                        color: isCorrect
                            ? Colors.green[50]
                            : Colors.red[50],
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          title: Text(question.question),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                selectedAnswerIndex != null
                                    ? "Your answer: ${question.options[selectedAnswerIndex]}"
                                    : "You didn't answer this question",
                                style: TextStyle(
                                  color: isCorrect
                                      ? Colors.green
                                      : Colors.red,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Correct answer: ${question.options[question.correctAnswerIndex]}",
                                style: const TextStyle(
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

                const SizedBox(height: 10),

                /// ✅ RESTART BUTTON
                // ElevatedButton(
                //   onPressed: () {
                //     /// answers reset (optional but recommended)
                //     ref.read(selectedAnswersProvider.notifier).restart();
                //
                //     /// back to Category
                //     Navigator.pushAndRemoveUntil(
                //       context,
                //       MaterialPageRoute(
                //           builder: (_) => const CategoryScreen()),
                //           (route) => false,
                //     );
                //   },
                //   child: const Text("Restart Quiz"),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}