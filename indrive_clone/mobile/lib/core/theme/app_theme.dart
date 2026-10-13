import 'package:flutter/material.dart';

/// InDrive brand colors: lime green + black.
class AppColors {
  static const lime = Color(0xFFC1F11D);
  static const limeDark = Color(0xFF9BC70A);
  static const black = Color(0xFF141414);
  static const grey900 = Color(0xFF1F1F1F);
  static const grey = Color(0xFF8A8A8A);
  static const greyLight = Color(0xFFF2F3F5);
  static const line = Color(0xFFE6E7EA);
  static const red = Color(0xFFE53935);
  static const green = Color(0xFF2E7D32);
  static const blue = Color(0xFF1E88E5);
}

class AppTheme {
  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.lime,
      brightness: Brightness.light,
      primary: AppColors.black,
      onPrimary: Colors.white,
      secondary: AppColors.lime,
      onSecondary: AppColors.black,
      surface: Colors.white,
      error: AppColors.red,
    );
    return _base(scheme).copyWith(scaffoldBackgroundColor: Colors.white);
  }

  static ThemeData dark() {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.lime,
      brightness: Brightness.dark,
      primary: AppColors.lime,
      onPrimary: AppColors.black,
      secondary: AppColors.lime,
      onSecondary: AppColors.black,
      surface: AppColors.grey900,
      error: AppColors.red,
    );
    return _base(scheme).copyWith(scaffoldBackgroundColor: AppColors.black);
  }

  static ThemeData _base(ColorScheme scheme) {
    final isDark = scheme.brightness == Brightness.dark;
    final fill = isDark ? const Color(0xFF2A2A2A) : AppColors.greyLight;
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      fontFamily: 'Roboto',
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: scheme.onSurface),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.lime,
          foregroundColor: AppColors.black,
          disabledBackgroundColor: fill,
          minimumSize: const Size.fromHeight(54),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(50),
          foregroundColor: scheme.onSurface,
          side: BorderSide(color: isDark ? Colors.white24 : AppColors.line),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: fill,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: isDark ? AppColors.lime : AppColors.black, width: 1.5),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: BorderSide.none,
        backgroundColor: fill,
        selectedColor: AppColors.lime,
        labelStyle: TextStyle(color: scheme.onSurface, fontWeight: FontWeight.w600),
        secondaryLabelStyle: const TextStyle(color: AppColors.black, fontWeight: FontWeight.w600),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surface,
        showDragHandle: true,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      ),
      snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
      dividerTheme: DividerThemeData(color: isDark ? Colors.white12 : AppColors.line, thickness: 1, space: 1),
    );
  }
}
