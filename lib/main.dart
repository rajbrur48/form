import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/landing_screen.dart';
import 'theme/app_theme.dart';
import 'screens/components/error_boundary.dart';

void main() {
  runApp(ProviderScope(child: ErrorBoundary(child: MyApp())));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ব্যাংক হিসাব খোলার আবেদন',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: LandingScreen(),
    );
  }
}
