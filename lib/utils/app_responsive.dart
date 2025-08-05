import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppResponsive {
  // Private constructor to prevent instantiation
  AppResponsive._();

  // Screen dimensions
  static double get screenWidth => 1.sw;
  static double get screenHeight => 1.sh;
  static double get statusBarHeight => ScreenUtil().statusBarHeight;
  static double get bottomBarHeight => ScreenUtil().bottomBarHeight;

  // Responsive width and height
  static double width(double width) => width.w;
  static double height(double height) => height.h;

  // Responsive font sizes
  static double fontSize(double size) => size.sp;

  // Responsive radius
  static double radius(double radius) => radius.r;

  // Common responsive spacing values
  static double get spacingXs => 4.h;      // Extra small spacing
  static double get spacingSm => 8.h;      // Small spacing
  static double get spacingMd => 16.h;     // Medium spacing
  static double get spacingLg => 24.h;     // Large spacing
  static double get spacingXl => 32.h;     // Extra large spacing
  static double get spacingXxl => 48.h;    // Extra extra large spacing

  // Common responsive font sizes
  static double get fontXs => 10.sp;    // Extra small text
  static double get fontSm => 12.sp;    // Small text
  static double get fontMd => 14.sp;    // Medium text (body)
  static double get fontLg => 16.sp;    // Large text
  static double get fontXl => 18.sp;    // Extra large text
  static double get fontXxl => 20.sp;   // Extra extra large text
  static double get fontTitle => 24.sp; // Title text
  static double get fontHeading => 28.sp; // Heading text
  static double get fontDisplay => 32.sp; // Display text

  // Common responsive icon sizes
  static double get iconXs => 12.r;     // Extra small icon
  static double get iconSm => 16.r;     // Small icon
  static double get iconMd => 20.r;     // Medium icon
  static double get iconLg => 24.r;     // Large icon
  static double get iconXl => 32.r;     // Extra large icon
  static double get iconXxl => 48.r;    // Extra extra large icon

  // Common responsive border radius
  static double get radiusXs => 4.r;      // Extra small radius
  static double get radiusSm => 8.r;      // Small radius
  static double get radiusMd => 12.r;     // Medium radius
  static double get radiusLg => 16.r;     // Large radius
  static double get radiusXl => 20.r;     // Extra large radius
  static double get radiusXxl => 24.r;    // Extra extra large radius
  static double get radiusCircle => 50.r; // Circle radius

  // Common responsive button heights
  static double get buttonSm => 32.h;     // Small button
  static double get buttonMd => 44.h;     // Medium button
  static double get buttonLg => 56.h;     // Large button
  static double get buttonXl => 64.h;     // Extra large button

  // Check device type
  static bool get isMobile => screenWidth < 768;
  static bool get isTablet => screenWidth >= 768 && screenWidth < 1024;
  static bool get isDesktop => screenWidth >= 1024;

  // Check screen orientation
  static bool get isPortrait => screenHeight > screenWidth;
  static bool get isLandscape => screenWidth > screenHeight;

  // Get responsive padding
  static double get horizontalPadding => isMobile ? 16.w : 24.w;
  static double get verticalPadding => isMobile ? 16.h : 24.h;

  // Screen breakpoints
  static bool isSmallScreen(double width) => width < 600;
  static bool isMediumScreen(double width) => width >= 600 && width < 1200;
  static bool isLargeScreen(double width) => width >= 1200;
}