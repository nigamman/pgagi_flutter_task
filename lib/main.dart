import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/ideas_provider.dart';
import 'screens/submit_idea_screen.dart';
import 'theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (_) => IdeasProvider(),
      child: const StartupEvaluatorApp(),
    ),
  );
}

class StartupEvaluatorApp extends StatelessWidget {
  const StartupEvaluatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<IdeasProvider>().isDarkMode;
    return MaterialApp(
      title: 'Startup Evaluator',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      home: const SubmitIdeaScreen(),
    );
  }
}
