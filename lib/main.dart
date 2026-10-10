import 'package:flutter/material.dart';
import 'screens/main_layout.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const DartCodeCampusApp());
}

class DartCodeCampusApp extends StatelessWidget {
  const DartCodeCampusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DartCode Campus',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // Supports both light and dark modes
      home: const MainLayout(),
    );
  }
}
