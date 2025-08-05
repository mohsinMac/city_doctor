import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final String? heroTag;
  final bool showShadow;
  final double borderRadius;
  final VoidCallback? onTap;

  const AppLogo({
    super.key,
    this.size = 120,
    this.heroTag,
    this.showShadow = true,
    this.borderRadius = 20,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget logoWidget = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: showShadow
            ? [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Image.asset(
          'assets/logo/logo.jpg',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1976D2),
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              child: Icon(
                Icons.local_hospital,
                size: size * 0.5,
                color: Colors.white,
              ),
            );
          },
        ),
      ),
    );

    if (onTap != null) {
      logoWidget = GestureDetector(
        onTap: onTap,
        child: logoWidget,
      );
    }

    if (heroTag != null) {
      logoWidget = Hero(
        tag: heroTag!,
        child: logoWidget,
      );
    }

    return logoWidget;
  }
}

class AppLogoWithText extends StatelessWidget {
  final double logoSize;
  final String? heroTag;
  final bool showShadow;
  final String appName;
  final String? tagline;
  final TextStyle? appNameStyle;
  final TextStyle? taglineStyle;
  final MainAxisAlignment alignment;
  final VoidCallback? onTap;

  const AppLogoWithText({
    super.key,
    this.logoSize = 120,
    this.heroTag,
    this.showShadow = true,
    this.appName = 'City Doctor',
    this.tagline = 'Your Health, Our Priority',
    this.appNameStyle,
    this.taglineStyle,
    this.alignment = MainAxisAlignment.center,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisAlignment: alignment,
      children: [
        AppLogo(
          size: logoSize,
          heroTag: heroTag,
          showShadow: showShadow,
          onTap: onTap,
        ),
        const SizedBox(height: 20),
        Text(
          appName,
          style: appNameStyle ??
              TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
        ),
        if (tagline != null) ...[
          const SizedBox(height: 8),
          Text(
            tagline!,
            style: taglineStyle ??
                TextStyle(
                  fontSize: 16,
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                  fontStyle: FontStyle.italic,
                ),
          ),
        ],
      ],
    );
  }
}

class AppIconLogo extends StatelessWidget {
  final double size;
  final Color? color;
  final Color? backgroundColor;
  final double borderRadius;
  final bool showBackground;

  const AppIconLogo({
    super.key,
    this.size = 40,
    this.color,
    this.backgroundColor,
    this.borderRadius = 8,
    this.showBackground = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final iconWidget = Icon(
      Icons.local_hospital,
      size: size * 0.6,
      color: color ?? Colors.white,
    );

    if (showBackground) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: backgroundColor ?? theme.primaryColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Center(child: iconWidget),
      );
    }

    return SizedBox(
      width: size,
      height: size,
      child: Center(child: iconWidget),
    );
  }
}