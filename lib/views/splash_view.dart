import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/app_assets.dart';
import 'login_view.dart';

class SplashView extends ConsumerStatefulWidget {
  const SplashView({super.key});

  @override
  ConsumerState<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends ConsumerState<SplashView>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  // late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    print('🎬 SplashView initState called');

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // _animation =
    //     CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
    // _animationController.forward();

    Timer(const Duration(seconds: 4), () {
      print('⏰ Splash timer completed - navigating to login');
      // 10 seconds duration
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: Duration(seconds: 2), // ⏱ Control duration
          pageBuilder: (_, __, ___) => const LoginView(),
        ),
      );
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.primaryColor, // Use primary color as background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Position logo on left side for horizontal movement
            Hero(
              tag: 'app-logo', // Same tag as login screen
              child: Container(
                width: 120,   // Same size as splash
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: theme.shadowColor.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    AppAssets.logo,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: BoxDecoration(
                          color: theme.primaryColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.local_hospital,
                          size: 30,
                          color: theme.colorScheme.onPrimary,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // App name and tagline
            Text(
              'City Doctor',
              style: theme.textTheme.displayLarge?.copyWith(
                color: Colors.white,
                fontSize: 36, // Bigger title
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Your Health, Our Priority',
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.white.withOpacity(0.9),
                fontSize: 18, // Better subtitle size
                fontWeight: FontWeight.w400,
                letterSpacing: 0.5,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
