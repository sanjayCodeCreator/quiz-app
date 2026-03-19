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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CategoryScreen(),
    );
  }
}