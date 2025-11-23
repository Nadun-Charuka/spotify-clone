import 'package:flutter/material.dart';
import 'package:spotify_client/core/theme/theme.dart';
import 'package:spotify_client/features/auth/view/pages/login_page.dart';
import 'package:spotify_client/features/auth/view/pages/signup_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkThemeMode,
      home: LoginPage(),
    );
  }
}
