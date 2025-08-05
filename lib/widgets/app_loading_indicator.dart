import 'package:flutter/material.dart';
import 'app_card.dart';

class AppLoadingIndicator extends StatelessWidget {
  final double size;
  final Color? color;
  final double strokeWidth;
  final String? message;
  final bool showMessage;

  const AppLoadingIndicator({
    super.key,
    this.size = 24,
    this.color,
    this.strokeWidth = 2,
    this.message,
    this.showMessage = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (showMessage && message != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              strokeWidth: strokeWidth,
              valueColor: AlwaysStoppedAnimation<Color>(
                color ?? theme.primaryColor,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            message!,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      );
    }

    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? theme.primaryColor,
        ),
      ),
    );
  }
}

class AppFullScreenLoading extends StatelessWidget {
  final String? message;
  final Color? backgroundColor;
  final bool isDismissible;

  const AppFullScreenLoading({
    super.key,
    this.message,
    this.backgroundColor,
    this.isDismissible = false,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: isDismissible,
      child: Container(
        color: backgroundColor ?? Colors.black.withOpacity(0.5),
        child: Center(
          child: AppCard(
            padding: const EdgeInsets.all(24),
            child: AppLoadingIndicator(
              size: 32,
              showMessage: message != null,
              message: message ?? 'Loading...',
            ),
          ),
        ),
      ),
    );
  }
}

class AppLinearLoadingIndicator extends StatelessWidget {
  final double? value;
  final Color? backgroundColor;
  final Color? valueColor;
  final double height;
  final double borderRadius;

  const AppLinearLoadingIndicator({
    super.key,
    this.value,
    this.backgroundColor,
    this.valueColor,
    this.height = 4,
    this.borderRadius = 2,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: LinearProgressIndicator(
          value: value,
          backgroundColor: backgroundColor ?? 
              theme.colorScheme.onSurface.withOpacity(0.1),
          valueColor: AlwaysStoppedAnimation<Color>(
            valueColor ?? theme.primaryColor,
          ),
        ),
      ),
    );
  }
}

class AppRefreshIndicator extends StatelessWidget {
  final Widget child;
  final Future<void> Function() onRefresh;
  final Color? color;
  final Color? backgroundColor;

  const AppRefreshIndicator({
    super.key,
    required this.child,
    required this.onRefresh,
    this.color,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return RefreshIndicator(
      onRefresh: onRefresh,
      color: color ?? theme.primaryColor,
      backgroundColor: backgroundColor ?? theme.cardColor,
      child: child,
    );
  }
}