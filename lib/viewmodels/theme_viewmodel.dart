import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Theme mode enum
enum AppThemeMode {
  primaryBlue,
  medicalGreen,
}

// Theme view model
class ThemeViewModel extends StateNotifier<AppThemeMode> {
  ThemeViewModel() : super(AppThemeMode.primaryBlue);

  // Get current theme name
  String get themeName {
    switch (state) {
      case AppThemeMode.primaryBlue:
        return 'Primary Blue';
      case AppThemeMode.medicalGreen:
        return 'Medical Green';
    }
  }

  // Get primary color value
  int get primaryColorValue {
    switch (state) {
      case AppThemeMode.primaryBlue:
        return 0xFF0165FC;
      case AppThemeMode.medicalGreen:
        return 0xFF2E7D32;
    }
  }

  // Set primary blue theme
  void setPrimaryBlueTheme() {
    state = AppThemeMode.primaryBlue;
  }

  // Set medical green theme
  void setMedicalGreenTheme() {
    state = AppThemeMode.medicalGreen;
  }
}

// Providers
final themeViewModelProvider = StateNotifierProvider<ThemeViewModel, AppThemeMode>((ref) {
  return ThemeViewModel();
});

final currentThemeProvider = Provider<AppThemeMode>((ref) {
  return ref.watch(themeViewModelProvider);
});

