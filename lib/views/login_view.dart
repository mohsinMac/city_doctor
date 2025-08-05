import 'package:city_doctor/utils/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/widgets.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../models/auth_state.dart';
import 'home_view.dart';
import 'forgot_password_view.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    print('🔐 LoginView initState called');
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Listen to auth state changes
    ref.listen<AuthState>(authViewModelProvider, (previous, next) {
      print('🔄 Auth state changed: ${previous.runtimeType} -> ${next.runtimeType}');
      
      if (next is AuthAuthenticated) {
        print('✅ Auth state: Authenticated - Navigating to home');
        // Navigate to home when authenticated
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeView()),
        );
      } else if (next is AuthError) {
        print('❌ Auth state: Error - ${next.message}');
        // Show error message
        AppSnackBar.showError(
          context,
          message: next.message,
        );
      } else if (next is AuthLoading) {
        print('⏳ Auth state: Loading');
      } else if (next is AuthUnauthenticated) {
        print('🚪 Auth state: Unauthenticated');
      }
    });

    final authState = ref.watch(authViewModelProvider);
    final isLoading = authState is AuthLoading;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                
                // Top section with logo and welcome
                Stack(
                  children: [
                    // Welcome section with hero logo
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Hero logo positioned at top right corner
                        Align(
                          alignment: Alignment.center,
                          child: Hero(
                            tag: 'app-logo', // Same tag as splash screen
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
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // Welcome text below logo
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Sign In',
                              style: theme.textTheme.displayMedium?.copyWith(
                                color: theme.colorScheme.onSurface,fontSize: 20
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Sign in to continue to City Doctor',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.colorScheme.onSurface.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                
                  SizedBox(height: 40.h),
                
                // Email field
                AppTextField(
                  controller: _emailController,
                  focusNode: _emailFocusNode,
                  label: 'Email',
                  hint: 'example@gmail.com',
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  enabled: !isLoading,
                  isRequired: true,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Email is required';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                  onSubmitted: (_) {
                    _passwordFocusNode.requestFocus();
                  },
                ),
                
                const SizedBox(height: 20),
                
                // Password field
                AppTextField(
                  controller: _passwordController,
                  focusNode: _passwordFocusNode,
                  label: 'Password',
                  hint: '********',
                  isPassword: true,
                  textInputAction: TextInputAction.done,
                  enabled: !isLoading,
                  isRequired: true,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Password is required';
                    }
                    return null;
                  },
                  onSubmitted: (_) {
                    _handleLogin();
                  },
                ),
                
                // const SizedBox(height: 12),
                
                // Forgot password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: isLoading ? null : _handleForgotPassword,
                    child: Text(
                      'Forgot Password?',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.primaryColor,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline, // Added underline
                        decorationColor: theme.primaryColor, // Underline color matches text
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Login button
                AppButton(
                  text: isLoading ? 'Signing In...' : 'Sign In',
                  onPressed: isLoading ? null : _handleLogin,
                  isLoading: isLoading,
                ),
                
                const SizedBox(height: 20),

              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleLogin() {
    print('🔘 Login button pressed');
    print('📧 Email from controller: ${_emailController.text}');
    print('🔑 Password from controller: ${_passwordController.text}');
    
    if (_formKey.currentState?.validate() ?? false) {
      print('✅ Form validation passed');
      print('📞 Calling auth viewmodel login...');
      ref.read(authViewModelProvider.notifier).login(
        _emailController.text,
        _passwordController.text,
      );
    } else {
      print('❌ Form validation failed');
    }
  }

  void _handleForgotPassword() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ForgotPasswordView(),
      ),
    );
  }

  void _handleSignUp() {
    AppSnackBar.showInfo(
      context,
      message: 'Sign up functionality coming soon!',
    );
  }
}

