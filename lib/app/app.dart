import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/quiz/presentation/quiz_screen.dart';
import '../features/character/presentation/character_screen.dart';
import 'theme.dart';

class GoalQuestApp extends StatelessWidget {
  const GoalQuestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'GoalQuest',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      routerConfig: _router,
    );
  }
}

final _router = GoRouter(
  initialLocation: '/quiz',
  routes: [
    GoRoute(
      path: '/quiz',
      builder: (context, state) => const QuizScreen(),
    ),
    GoRoute(
      path: '/character',
      builder: (context, state) => const CharacterScreen(),
    ),
  ],
);