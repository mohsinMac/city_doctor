import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/widgets.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../models/auth_state.dart';
import 'otp_verification_screen.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _emailFocusNode = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Listen to auth state changes
    ref.listen<AuthState>(authViewModelProvider, (previous, next) {
      print('🔄 Auth state changed in ForgotPasswordScreen: ${previous?.runtimeType} -> ${next.runtimeType}');
      
      if (next is AuthError) {
        print('❌ Auth error in ForgotPasswordScreen: ${next.message}');
        AppSnackBar.showError(
          context,
          message: next.message,
        );
      } else if (next is AuthLoading) {
        print('⏳ Auth loading in ForgotPasswordScreen');
      } else if (next is AuthUnauthenticated) {
        print('🚪 Auth unauthenticated in ForgotPasswordScreen');
      }
    });

    final authState = ref.watch(authViewModelProvider);
    final isLoading = authState is AuthLoading;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Forgot Password',
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                
                // Icon and description
                Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.lock_reset,
                        size: 40,
                        color: theme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Reset Password',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Enter your email address and we\'ll send you a 4-digit OTP to reset your password.',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                
                const SizedBox(height: 40),
                
                // Email field
                AppTextField(
                  controller: _emailController,
                  focusNode: _emailFocusNode,
                  label: 'Email',
                  hint: 'Enter your email address',
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
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
                    _handleSendOTP();
                  },
                ),
                
                const SizedBox(height: 32),
                
                // Send OTP button
                AppButton(
                  text: isLoading ? 'Sending OTP...' : 'Send OTP',
                  onPressed: isLoading ? null : () async {
                    await _handleSendOTP();
                  },
                  isLoading: isLoading,
                ),
                
                const SizedBox(height: 20),
                
                // Back to login
                TextButton(
                  onPressed: isLoading ? null : () => Navigator.of(context).pop(),
                  child: Text(
                    'Back to Sign In',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleSendOTP() async {
    print('🔄 Starting OTP send process...');
    
    if (_formKey.currentState?.validate() ?? false) {
      final email = _emailController.text.trim();
      print('📧 Email to send OTP: $email');
      
      try {
        // Call the forgot password API
        await ref.read(authViewModelProvider.notifier).forgotPassword(email);
        print('✅ OTP sent successfully to: $email');
        
        // Navigate to OTP screen on success
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => OtpVerificationScreen(email: email),
          ),
        );
        print('🚀 Navigated to OTP verification screen');
      } catch (e) {
        print('❌ Error sending OTP: $e');
        // Error will be handled by the auth state listener
      }
    } else {
      print('❌ Form validation failed');
    }
  }
}