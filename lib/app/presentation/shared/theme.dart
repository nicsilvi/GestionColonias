import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';

class AppTheme {
  static ThemeData getTheme(bool isDarkMode) =>
      isDarkMode ? darkTheme : lightTheme;

  // Light theme  ---------------------------------------------------------------------------------------------
  static final ThemeData lightTheme = ThemeData.light().copyWith(
    //al ser copywith solo se modifica lo especificado aqui
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,
    appBarTheme: const AppBarTheme(
      color: AppColors.surface,
      iconTheme: IconThemeData(color: AppColors.accent),
      titleTextStyle: TextStyle(
        color: AppColors.primary,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
      elevation: 4, // Un poco de sombra para el appBar
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: AppColors.surface,
      scrimColor: Color.fromARGB(137, 245, 235, 235),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        )),
    dialogTheme: const DialogTheme(
      backgroundColor: AppColors.surface, // Definiendo el fondo del diálogo
      titleTextStyle: TextStyle(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.bold,
      ),
      contentTextStyle: TextStyle(
        color: AppColors.textPrimary,
      ),
    ),
    // Text styles
    textTheme: const TextTheme(
      bodyLarge:
          TextStyle(color: AppColors.textPrimary, fontSize: 16), // Texto normal
      bodyMedium: TextStyle(
          color: AppColors.textSecondary, fontSize: 14), // Texto más pequeño
      headlineLarge: TextStyle(
          color: AppColors.accent,
          fontSize: 32,
          fontWeight: FontWeight.bold), // Títulos grandes
      headlineMedium: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w500), // Subtítulos
    ),
    iconTheme: const IconThemeData(color: AppColors.accent),
    buttonTheme: const ButtonThemeData(
      buttonColor: Color(0xFF6200EE),
    ),
    colorScheme: const ColorScheme.dark(
      primary: AppColors.accent,
      secondary: AppColors.secondary,
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.accent,
      foregroundColor: Colors.white,
    ),
    // Ajuste del color de los elementos deseleccionados (como Checkboxes, etc)
    unselectedWidgetColor: const Color.fromARGB(255, 163, 160, 160),
  );

  // darktheme  ---------------------------------------------------------------------------------------------
  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    primaryColor: const Color.fromARGB(255, 243, 186, 80),
    scaffoldBackgroundColor: AppColors.backgroundDark,
    appBarTheme: const AppBarTheme(
      color: AppColors.surface,
      iconTheme: IconThemeData(color: AppColors.accentDark),
      titleTextStyle: TextStyle(
        color: AppColors.primaryDark,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
      elevation: 4, // Un poco de sombra para el appBar
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: AppColors.surfaceDark,
      scrimColor: Color.fromARGB(137, 245, 235, 235),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        )),
    dialogTheme: const DialogTheme(
      backgroundColor: AppColors.surfaceDark, // Definiendo el fondo del diálogo
      titleTextStyle: TextStyle(
        color: AppColors.primaryDark,
        fontWeight: FontWeight.bold,
      ),
      contentTextStyle: TextStyle(
        color: AppColors.textPrimaryDark,
      ),
    ),

    // Text styles
    textTheme: const TextTheme(
      bodyLarge: TextStyle(
          color: AppColors.textPrimaryDark, fontSize: 16), // Texto normal
      bodyMedium: TextStyle(
          color: AppColors.textSecondaryDark,
          fontSize: 14), // Texto más pequeño
      bodySmall:
          TextStyle(color: Color.fromARGB(255, 92, 88, 88), fontSize: 14),
      headlineLarge: TextStyle(
          color: AppColors.primaryDark,
          fontSize: 32,
          fontWeight: FontWeight.bold), // Títulos grandes
      headlineMedium: TextStyle(
          color: AppColors.textPrimaryDark,
          fontSize: 20,
          fontWeight: FontWeight.w500), // Subtítulos
    ),

    iconTheme: const IconThemeData(color: AppColors.accentDark),
    buttonTheme: const ButtonThemeData(
      buttonColor: Color(0xFF6200EE),
    ),
    colorScheme: const ColorScheme.dark(
      primary: Color.fromARGB(255, 245, 179, 58),
      secondary: AppColors.secondaryDark,
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.accentDark,
      foregroundColor: Colors.black,
    ),
    // Ajuste del color de los elementos deseleccionados (como Checkboxes, etc)
    unselectedWidgetColor: const Color.fromARGB(255, 56, 55, 55),
  );
}
