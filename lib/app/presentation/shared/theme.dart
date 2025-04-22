import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';

class AppTheme {
  static ThemeData getTheme(bool isDarkMode) =>
      isDarkMode ? darkTheme : lightTheme;

  // Light theme  ---------------------------------------------------------------------------------------------
  static final ThemeData lightTheme = ThemeData.light().copyWith(
    //al ser copywith solo se modifica lo especificado aqui
    primaryColor: const Color.fromARGB(255, 146, 4, 82),
    primaryColorDark: Colors.black,
    scaffoldBackgroundColor: const Color.fromARGB(255, 247, 216, 238),
    appBarTheme: const AppBarTheme(
      color: AppColors.lightBg,
      iconTheme: IconThemeData(color: Color.fromARGB(255, 87, 84, 84)),
      titleTextStyle: TextStyle(
        color: AppColors.dark,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
      elevation: 4, // Un poco de sombra para el appBar
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: Color.fromARGB(255, 199, 185, 185),
      scrimColor: Color.fromARGB(137, 245, 235, 235),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Color.fromARGB(45, 228, 52, 252)),

    // Text styles
    textTheme: const TextTheme(
      bodyLarge: TextStyle(
          color: Color.fromARGB(179, 0, 0, 0), fontSize: 16), // Texto normal
      bodyMedium: TextStyle(
          color: Color.fromARGB(137, 0, 0, 0),
          fontSize: 14), // Texto más pequeño
      headlineLarge: TextStyle(
          color: Color.fromARGB(255, 0, 0, 0),
          fontSize: 32,
          fontWeight: FontWeight.bold), // Títulos grandes
      headlineMedium: TextStyle(
          color: Color.fromARGB(179, 0, 0, 0),
          fontSize: 28,
          fontWeight: FontWeight.w500), // Subtítulos
    ),
    iconTheme: const IconThemeData(
        color: Color.fromARGB(255, 8, 8, 8)), // Íconos blancos
    buttonTheme: const ButtonThemeData(
      buttonColor: Color(0xFF6200EE),
    ),
    colorScheme: const ColorScheme.dark(
      primary: Color.fromARGB(255, 243, 17, 142),
    ),
    // Ajuste del color de los elementos deseleccionados (como Checkboxes, etc)
    unselectedWidgetColor: const Color.fromARGB(179, 55, 10, 114),
  );

  // darktheme  ---------------------------------------------------------------------------------------------
  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    primaryColor: const Color.fromARGB(255, 223, 154, 5),
    primaryColorDark: const Color.fromARGB(255, 255, 255, 255),
    scaffoldBackgroundColor: const Color.fromARGB(255, 66, 66, 66),
    appBarTheme: const AppBarTheme(
      color: Color.fromARGB(255, 0, 0, 0),
      iconTheme: IconThemeData(color: Color.fromARGB(255, 197, 191, 191)),
      titleTextStyle: TextStyle(
        color: Color.fromARGB(255, 236, 174, 2),
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
      elevation: 12,
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: AppColors.dark2,
      scrimColor: Color(0x8A000000),
    ),
    colorScheme: const ColorScheme.dark(
      primary: Color.fromARGB(255, 37, 128, 2),
    ),

    bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Color.fromARGB(255, 110, 107, 109)),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color.fromARGB(255, 223, 154, 5), // Amarillo
      foregroundColor: Colors.black, // Color del ícono
    ),
    dialogTheme: const DialogTheme(
      backgroundColor: Color.fromARGB(255, 66, 66, 66),
      titleTextStyle: TextStyle(
        color: Color.fromARGB(255, 223, 154, 5),
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
      contentTextStyle: TextStyle(
        color: Colors.white70,
        fontSize: 16,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 223, 154, 5),
        foregroundColor: Colors.black,
        textStyle: const TextStyle(fontSize: 16),
      ),
    ),
    // Text styles
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white70, fontSize: 16), // Texto normal
      bodyMedium:
          TextStyle(color: Colors.white54, fontSize: 14), // Texto más pequeño
      headlineLarge: TextStyle(
          color: Color.fromARGB(255, 255, 255, 255),
          fontSize: 32,
          fontWeight: FontWeight.bold), // Títulos grandes
      headlineMedium: TextStyle(
          color: Colors.white70,
          fontSize: 28,
          fontWeight: FontWeight.w500), // Subtítulos
    ),
    iconTheme: const IconThemeData(color: Color.fromARGB(255, 255, 255, 255)),
    buttonTheme: const ButtonThemeData(
      buttonColor: Color.fromARGB(255, 209, 182, 27),
    ),
    // Ajuste del color de los elementos deseleccionados (como Checkboxes, etc)
    unselectedWidgetColor: Colors.white70,
  );
}
