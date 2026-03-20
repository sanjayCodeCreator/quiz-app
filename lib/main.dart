import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_app/auth/login.dart';
// import 'package:quiz_app/quiz.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:quiz_app/quiz.dart';
import 'package:quiz_app/screens/category_screen.dart';
import 'package:quiz_app/utils/prefs_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await PrefsService.init();

  runApp(
    const ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: StartQuizScreen(),
      ),
    ),
  );
}
