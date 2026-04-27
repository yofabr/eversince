import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brutalist color palette
  static const Color primary = Color(0xFF000000);
  static const Color primaryMuted = Color(0xFF333333);
  static const Color accent = Color(0xFFF5FF00);
  static const Color accentDark = Color(0xFFD4DD00);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF0F0F0);
  static const Color background = Color(0xFFFAFAFA);
  static const Color muted = Color(0xFF888888);
  static const Color border = Color(0xFF000000);
  static const Color success = Color(0xFF00C853);
  static const Color warning = Color(0xFFFF6D00);
  static const Color error = Color(0xFFD50000);

  static TextTheme _buildTextTheme() {
    return GoogleFonts.soraTextTheme(
      const TextTheme(
        displayLarge: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.w700,
          color: primary,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: primary,
        ),
        displaySmall: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: primary,
        ),
        headlineLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: primary,
        ),
        headlineMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: primary,
        ),
        headlineSmall: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: primary,
        ),
        titleLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: primary,
        ),
        titleMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: primary,
        ),
        titleSmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: primary,
        ),
        bodyLarge: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: primary,
        ),
        bodyMedium: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: primary,
        ),
        bodySmall: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w400,
          color: muted,
        ),
        labelLarge: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: primary,
          letterSpacing: 0.5,
        ),
        labelMedium: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: primary,
          letterSpacing: 0.4,
        ),
        labelSmall: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w400,
          color: muted,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      primary: primary,
      onPrimary: surface,
      secondary: accent,
      onSecondary: primary,
      surface: surface,
      onSurface: primary,
      error: error,
      onError: surface,
      outline: border,
      outlineVariant: Color(0xFFDDDDDD),
      surfaceContainerHighest: surfaceVariant,
    ),
    scaffoldBackgroundColor: background,
    textTheme: _buildTextTheme(),
    appBarTheme: AppBarThemeData(
      backgroundColor: background,
      elevation: 0,
      scrolledUnderElevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      titleTextStyle: GoogleFonts.sora(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: primary,
        letterSpacing: -0.5,
      ),
      iconTheme: const IconThemeData(color: primary),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: surface,
      indicatorColor: Colors.transparent,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return GoogleFonts.sora(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: primary,
          );
        }
        return GoogleFonts.sora(
          fontSize: 10,
          fontWeight: FontWeight.w400,
          color: muted,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: primary, size: 22);
        }
        return const IconThemeData(color: muted, size: 22);
      }),
      height: 64,
      elevation: 0,
    ),
    inputDecorationTheme: InputDecorationThemeData(
      filled: false,
      border: const UnderlineInputBorder(
        borderSide: BorderSide(color: border, width: 2),
      ),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFCCCCCC), width: 1.5),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: primary, width: 2),
      ),
      errorBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: error, width: 2),
      ),
      focusedErrorBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: error, width: 2),
      ),
      labelStyle: GoogleFonts.sora(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: muted,
      ),
      hintStyle: GoogleFonts.sora(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: muted,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: surface,
        elevation: 0,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        textStyle: GoogleFonts.sora(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primary,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        textStyle: GoogleFonts.sora(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: Color(0xFFE0E0E0),
      thickness: 1,
      space: 0,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: primary,
      contentTextStyle: GoogleFonts.sora(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: surface,
      ),
      behavior: SnackBarBehavior.floating,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
    ),
  );

  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.dark(
      primary: surface,
      onPrimary: primary,
      secondary: accent,
      onSecondary: primary,
      surface: Color(0xFF111111),
      onSurface: surface,
      error: Color(0xFFFF5252),
      onError: primary,
      outline: surface,
      outlineVariant: Color(0xFF333333),
      surfaceContainerHighest: Color(0xFF1E1E1E),
    ),
    scaffoldBackgroundColor: const Color(0xFF0A0A0A),
    textTheme: GoogleFonts.soraTextTheme(
      const TextTheme(
        displayLarge: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.w700,
          color: surface,
        ),
        headlineSmall: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: surface,
        ),
        titleLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: surface,
        ),
        bodyLarge: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: surface,
        ),
        bodyMedium: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: surface,
        ),
        bodySmall: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w400,
          color: Color(0xFF888888),
        ),
      ),
    ),
    appBarTheme: AppBarThemeData(
      backgroundColor: const Color(0xFF0A0A0A),
      elevation: 0,
      scrolledUnderElevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      titleTextStyle: GoogleFonts.sora(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: surface,
        letterSpacing: -0.5,
      ),
      iconTheme: const IconThemeData(color: surface),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: const Color(0xFF111111),
      indicatorColor: Colors.transparent,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return GoogleFonts.sora(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: surface,
          );
        }
        return GoogleFonts.sora(
          fontSize: 10,
          fontWeight: FontWeight.w400,
          color: const Color(0xFF888888),
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: surface, size: 22);
        }
        return const IconThemeData(color: Color(0xFF888888), size: 22);
      }),
      height: 64,
      elevation: 0,
    ),
    inputDecorationTheme: InputDecorationThemeData(
      filled: false,
      border: const UnderlineInputBorder(
        borderSide: BorderSide(color: surface, width: 2),
      ),
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF444444), width: 1.5),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: surface, width: 2),
      ),
      errorBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFFF5252), width: 2),
      ),
      labelStyle: GoogleFonts.sora(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF888888),
      ),
      hintStyle: GoogleFonts.sora(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: const Color(0xFF666666),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: surface,
        foregroundColor: primary,
        elevation: 0,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        textStyle: GoogleFonts.sora(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      ),
    ),
  );
}
