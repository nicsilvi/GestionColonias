import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color error = Colors.red;

  // Light mode ------------------------------------------------
  static const primary = Color.fromARGB(255, 228, 154, 16); // Mostaza vibrante
  static const secondary = Color(0xFF6C6C6C); // Gris medio elegante
  static const background =
      Color.fromARGB(255, 247, 245, 238); // Beige claro casi blanco
  static const surface = Color(0xFFFFFFFF); // Blanco puro
  static const textPrimary = Color(0xFF1E1E1E); // Gris muy oscuro (casi negro)
  static const textSecondary = Color(0xFF4F4F4F);
  static const accent = Color.fromARGB(255, 245, 188, 124);

  // Dark Theme
  static const primaryDark =
      Color.fromARGB(255, 241, 191, 96); // Mostaza más cálido
  static const secondaryDark =
      Color.fromARGB(255, 92, 91, 91); // Gris oscuro elegante
  static const backgroundDark =
      Color.fromARGB(255, 66, 66, 66); // Negro profundo
  static const surfaceDark = Color.fromARGB(255, 61, 61, 61); // Gris muy oscuro
  static const textPrimaryDark = Color(0xFFFDF6E3); // Crema claro
  static const textSecondaryDark = Color(0xFFB3B3B3); // Gris claro
  static const accentDark =
      Color.fromARGB(255, 243, 168, 56); // Mostaza claro con luz
}
