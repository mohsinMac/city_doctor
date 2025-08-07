import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/app_assets.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../models/auth_state.dart';
import '../services/auth_service_new.dart';
import 'login_screen.dart';
import 'home_view.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashViewState();
}

class _SplashViewState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    print('🎬 SplashView initState called');

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // Start animation
    _animationController.forward();

    // Check authentication status after splash duration
    Timer(const Duration(seconds: 3), () async {
      if (mounted) {
        print('⏰ Splash timer completed - checking auth status');
        await _checkAuthStatusAndNavigate();
      } else {
        print('⚠️ Widget disposed, skipping timer callback');
      }
    });
  }

  Future<void> _checkAuthStatusAndNavigate() async {
    // Check if widget is still mounted before using ref
    if (!mounted) {
      print('⚠️ Widget disposed, skipping auth check');
      return;
    }
    
    try {
      // Check authentication status directly from SharedPreferences
      final isAuthenticated = await ref.read(authServiceProvider).isAuthenticated();
      print('🔐 Direct auth check - Is authenticated: $isAuthenticated');
      
      if (isAuthenticated) {
        print('✅ User is authenticated - navigating to home');
        if (mounted) {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 800),
              pageBuilder: (_, __, ___) => const BaseScreen(),
            ),
          );
        }
      } else {
        print('🚪 User is not authenticated - navigating to login');
        if (mounted) {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              transitionDuration: const Duration(seconds: 1),
              pageBuilder: (_, __, ___) => const LoginScreen(),
            ),
          );
        }
      }
    } catch (e) {
      print('❌ Error checking auth status: $e');
      // On error, navigate to login
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(seconds: 1),
            pageBuilder: (_, __, ___) => const LoginScreen(),
          ),
        );
      }
    }
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
      backgroundColor: theme.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated logo with hero tag
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.scale(
                  scale: 0.5 + (_animationController.value * 0.5),
                  child: Hero(
                    tag: 'app-logo',
                    child: Container(
                      width: 120,
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
                );
              },
            ),

            const SizedBox(height: 30),

            // App name with fade-in animation
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Opacity(
                  opacity: _animationController.value,
                  child: Column(
                    children: [
                      Text(
                        'City Doctor',
                        style: theme.textTheme.displayLarge?.copyWith(
                          color: Colors.white,
                          fontSize: 36,
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
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.5,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
