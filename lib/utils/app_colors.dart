import 'package:flutter/material.dart';

class AppColors {
  // Primary Theme Colors
  static const Color primaryBlue = Color(0xFF0165FC);
  static const Color primaryBlueLight = Color(0xFF4A90FF);
  static const Color primaryBlueDark = Color(0xFF0149CC);
  
  // Secondary Theme Colors (Medical Green)
  static const Color secondaryGreen = Color(0xFF2E7D32);
  static const Color secondaryGreenLight = Color(0xFF4CAF50);
  static const Color secondaryGreenDark = Color(0xFF1B5E20);
  
  // Alias for medical theme
  static const Color medicalGreen = secondaryGreen;
  static const Color medicalGreenLight = secondaryGreenLight;
  static const Color medicalGreenDark = secondaryGreenDark;
  
  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);
  
  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color successLight = Color(0xFFC8E6C9);
  static const Color error = Color(0xFFF44336);
  static const Color errorLight = Color(0xFFFFCDD2);
  static const Color warning = Color(0xFFFF9800);
  static const Color warningLight = Color(0xFFFFE0B2);
  static const Color info = Color(0xFF2196F3);
  static const Color infoLight = Color(0xFFBBDEFB);
  
  // Background Colors
  static const Color backgroundLight = Color(0xFFFFFFFF);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  
  // Text Colors
  static const Color textPrimaryLight = Color(0xFF212121);
  static const Color textSecondaryLight = Color(0xFF757575);
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFFB3B3B3);
  
  // Border Colors
  static const Color borderLight = Color(0xFFE0E0E0);
  static const Color borderDark = Color(0xFF333333);
  
  // Shadow Colors
  static const Color shadowLight = Color(0x1A000000);
  static const Color shadowDark = Color(0x1AFFFFFF);
}

class AppGradients {
  // Primary Gradients
  static const LinearGradient primaryBlueGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.primaryBlue,
      AppColors.primaryBlueDark,
    ],
  );
  
  static const LinearGradient primaryBlueReversed = LinearGradient(
    begin: Alignment.bottomRight,
    end: Alignment.topLeft,
    colors: [
      AppColors.primaryBlue,
      AppColors.primaryBlueDark,
    ],
  );
  
  // Secondary Gradients
  static const LinearGradient secondaryGreenGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.secondaryGreen,
      AppColors.secondaryGreenDark,
    ],
  );
  
  // Neutral Gradients
  static const LinearGradient greyGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      AppColors.grey100,
      AppColors.grey200,
    ],
  );
  
  // Status Gradients
  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.success,
      Color(0xFF388E3C),
    ],
  );
  
  static const LinearGradient errorGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.error,
      Color(0xFFD32F2F),
    ],
  );
}