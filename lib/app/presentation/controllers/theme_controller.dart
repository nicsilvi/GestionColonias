import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeControllerProvider =
    StateNotifierProvider<ThemeController, bool>((ref) => ThemeController());

class ThemeController extends StateNotifier<bool> {
  ThemeController() : super(true);

  void updateTheme() {
    state = !state;
  }
}
