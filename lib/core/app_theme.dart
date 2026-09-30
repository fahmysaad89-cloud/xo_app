import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTheme {
  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.bg,
    textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
  );

  static TextStyle title(double size, {Color color = Colors.white}) =>
      GoogleFonts.caveat(
        fontSize: size,
        fontWeight: FontWeight.w700,
        color: color,
      );
}
