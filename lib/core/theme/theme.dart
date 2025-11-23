import 'package:flutter/material.dart';
import 'package:spotify_client/core/theme/app_pallete.dart';

class AppTheme {
  //outline border for text f
  static OutlineInputBorder _border(Color color) => OutlineInputBorder(
    borderSide: BorderSide(
      width: 3,
      color: color,
    ),
    borderRadius: BorderRadius.circular(10),
  );
  static final darkThemeMode = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: Pallete.backgroundColor,
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: EdgeInsets.all(27),
      enabledBorder: _border(Pallete.borderColor),
      focusedBorder: _border(Pallete.gradient2),
    ),
  );
}
