import 'package:city_doctor/services/auth_service_new.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/auth_state.dart';
import '../models/user_model.dart';

// Provider for AuthService
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

// StateNotifier for Auth State Management
class AuthViewModel extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthViewModel(this._authService) : super(AuthInitial()) {
    _checkAuthStatus();
  }

  /// Check if user is already authenticated on app start
  Future<void> _checkAuthStatus() async {
    try {
      state = AuthLoading();
      
      final isAuth = await _authService.isAuthenticated();
      if (isAuth) {
        final user = await _authService.getCurrentUser();
        if (user != null) {
          state = AuthAuthenticated(user);
        } else {
          state = AuthUnauthenticated();
        }
      } else {
        state = AuthUnauthenticated();
      }
    } catch (e) {
      state = AuthUnauthenticated();
    }
  }

  /// Login user with email and password
  Future<void> login(String email, String password) async {
    print('🎯 AuthViewModel.login() called');
    print('📧 Email: $email');
    print('🔑 Password length: ${password.length}');
    
    if (email.trim().isEmpty || password.trim().isEmpty) {
      print('❌ Empty fields detected');
      state = AuthError('Please fill in all fields');
      return;
    }

    if (!_isValidEmail(email)) {
      print('❌ Invalid email format');
      state = AuthError('Please enter a valid email address');
      return;
    }

    try {
      print('⏳ Setting loading state...');
      state = AuthLoading();
      
      print('📞 Calling auth service...');
      final user = await _authService.login(email.trim(), password);
      print('✅ Auth service returned user: ${user.name}');
      
      print('🎉 Setting authenticated state...');
      state = AuthAuthenticated(user);
      print('✅ Authentication successful!');
      
    } catch (e) {
      print('❌ Error in AuthViewModel.login(): $e');
      state = AuthError(e.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
      state = AuthLoading();
      await _authService.logout();
      state = AuthUnauthenticated();
    } catch (e) {
      state = AuthError('Failed to logout: ${e.toString()}');
    }
  }

  /// Register new user
  Future<void> register(String email, String password, String name) async {
    if (email.trim().isEmpty || password.trim().isEmpty || name.trim().isEmpty) {
      state = AuthError('Please fill in all fields');
      return;
    }

    if (!_isValidEmail(email)) {
      state = AuthError('Please enter a valid email address');
      return;
    }

    if (password.length < 8) {
      state = AuthError('Password must be at least 8 characters long');
      return;
    }

    try {
      state = AuthLoading();
      
      final user = await _authService.register(email.trim(), password, name.trim());
      state = AuthAuthenticated(user);
      
    } catch (e) {
      state = AuthError(e.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Reset password
  Future<void> resetPassword(String email) async {
    if (email.trim().isEmpty) {
      state = AuthError('Please enter your email address');
      return;
    }

    if (!_isValidEmail(email)) {
      state = AuthError('Please enter a valid email address');
      return;
    }

    try {
      state = AuthLoading();
      await _authService.resetPassword(email.trim());
      state = AuthUnauthenticated();
      // You might want to show a success message here
    } catch (e) {
      state = AuthError(e.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Clear any error state
  void clearError() {
    if (state is AuthError) {
      state = AuthUnauthenticated();
    }
  }

  /// Validate email format
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}

// Provider for AuthViewModel
final authViewModelProvider = StateNotifierProvider<AuthViewModel, AuthState>((ref) {
  final authService = ref.read(authServiceProvider);
  return AuthViewModel(authService);
});

// Convenience providers for specific states
final isLoadingProvider = Provider<bool>((ref) {
  final authState = ref.watch(authViewModelProvider);
  return authState is AuthLoading;
});

final currentUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authViewModelProvider);
  return authState is AuthAuthenticated ? authState.user : null;
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authViewModelProvider);
  return authState is AuthAuthenticated;
});

final authErrorProvider = Provider<String?>((ref) {
  final authState = ref.watch(authViewModelProvider);
  return authState is AuthError ? authState.message : null;
});