import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/app_theme.dart';

class ThemeViewModel extends StateNotifier<AppThemeMode> {
  static const String _themeKey = 'app_theme_mode';
  
  ThemeViewModel() : super(AppThemeMode.primaryBlue) {
    _loadTheme();
  }

  /// Load saved theme from SharedPreferences
  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedThemeIndex = prefs.getInt(_themeKey);
      
      if (savedThemeIndex != null) {
        state = AppThemeMode.values[savedThemeIndex];
      }
    } catch (e) {
      // If loading fails, keep default theme
    }
  }

  /// Save theme to SharedPreferences
  Future<void> _saveTheme(AppThemeMode theme) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themeKey, theme.index);
    } catch (e) {
      // Handle save error if needed
    }
  }

  /// Switch to Primary Blue theme
  Future<void> setPrimaryBlueTheme() async {
    if (state != AppThemeMode.primaryBlue) {
      state = AppThemeMode.primaryBlue;
      await _saveTheme(state);
    }
  }

  /// Switch to Medical Green theme
  Future<void> setMedicalGreenTheme() async {
    if (state != AppThemeMode.medicalGreen) {
      state = AppThemeMode.medicalGreen;
      await _saveTheme(state);
    }
  }

  /// Toggle between themes
  Future<void> toggleTheme() async {
    switch (state) {
      case AppThemeMode.primaryBlue:
        await setMedicalGreenTheme();
        break;
      case AppThemeMode.medicalGreen:
        await setPrimaryBlueTheme();
        break;
    }
  }

  /// Get current primary color
  int get primaryColorValue {
    switch (state) {
      case AppThemeMode.primaryBlue:
        return 0xFF0165FC;
      case AppThemeMode.medicalGreen:
        return 0xFF2E7D32;
    }
  }

  /// Get current theme name
  String get themeName {
    switch (state) {
      case AppThemeMode.primaryBlue:
        return 'Primary Blue';
      case AppThemeMode.medicalGreen:
        return 'Medical Green';
    }
  }

  /// Check if current theme is primary blue
  bool get isPrimaryBlueTheme => state == AppThemeMode.primaryBlue;

  /// Check if current theme is medical green
  bool get isMedicalGreenTheme => state == AppThemeMode.medicalGreen;
}

// Provider for ThemeViewModel
final themeViewModelProvider = StateNotifierProvider<ThemeViewModel, AppThemeMode>((ref) {
  return ThemeViewModel();
});

// Convenience providers
final currentThemeProvider = Provider<AppThemeMode>((ref) {
  return ref.watch(themeViewModelProvider);
});

final primaryColorProvider = Provider<int>((ref) {
  final themeNotifier = ref.watch(themeViewModelProvider.notifier);
  return themeNotifier.primaryColorValue;
});

final themeNameProvider = Provider<String>((ref) {
  final themeNotifier = ref.watch(themeViewModelProvider.notifier);
  return themeNotifier.themeName;
});