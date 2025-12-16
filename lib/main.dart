import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/main_form_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ব্যাংক হিসাব খোলার আবেদন',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: MainFormScreen(),
    );
  }
}
