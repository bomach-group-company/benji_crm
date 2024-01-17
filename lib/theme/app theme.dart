// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static CupertinoThemeData iOSLightTheme = const CupertinoThemeData(
    applyThemeToAll: true,
    brightness: Brightness.light,
  );
  static CupertinoThemeData iOSDarkTheme = const CupertinoThemeData(
    applyThemeToAll: true,
    brightness: Brightness.light,
  );
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    textTheme: GoogleFonts.senTextTheme(),
  );
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    textTheme: GoogleFonts.senTextTheme(),
  );
}
