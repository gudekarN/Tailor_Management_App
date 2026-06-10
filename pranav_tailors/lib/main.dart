// ════════════════════════════════════════════════════════════════════════════
//  main.dart
//  Pranav Ladies Tailors — App Entry Point
// ════════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:pranav_tailors/core/navigation/app_router.dart';
import 'package:pranav_tailors/core/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PranavTailorsApp());
}

class PranavTailorsApp extends StatelessWidget {
  const PranavTailorsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Pranav Ladies Tailors',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: appRouter,
    );
  }
}
