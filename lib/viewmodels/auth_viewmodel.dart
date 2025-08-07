import 'package:city_doctor/services/auth_service_new.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/auth_state.dart';
import '../models/user_model.dart';

// Auth service provider
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

// Auth view model
class AuthViewModel extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthViewModel(this._authService) : super(AuthInitial()) {
    _checkAuthStatus();
  }

  // Check if user is logged in on app start
  Future<void> _checkAuthStatus() async {
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
  }

  // Login user
  Future<void> login(String email, String password) async {
    if (email.trim().isEmpty || password.trim().isEmpty) {
      state = AuthError('Please fill in all fields');
      return;
    }

    try {
      state = AuthLoading();
      
      final user = await _authService.login(email.trim(), password);
      state = AuthAuthenticated(user);
      
    } catch (e) {
      state = AuthError(e.toString());
    }
  }

  // Logout user
  Future<void> logout() async {
    try {
      state = AuthLoading();
      await _authService.logout();
      state = AuthUnauthenticated();
    } catch (e) {
      state = AuthError('Failed to logout');
    }
  }

  // Clear error
  void clearError() {
    if (state is AuthError) {
      state = AuthUnauthenticated();
    }
  }

  // Get user profile
  Future<void> fetchUserProfile() async {
    try {
      // Only fetch if we don't have user data or if current state is not authenticated
      if (state is! AuthAuthenticated) {
        state = AuthLoading();
        
        final user = await _authService.fetchUserProfile();
        state = AuthAuthenticated(user);
      }
    } catch (e) {
      // Keep current state if profile fetch fails
      print('❌ Error fetching user profile: $e');
    }
  }

  // Change password
  Future<void> changePassword(String currentPassword, String newPassword, String confirmPassword) async {
    if (currentPassword.trim().isEmpty || newPassword.trim().isEmpty || confirmPassword.trim().isEmpty) {
      state = AuthError('Please fill in all fields');
      return;
    }

    if (newPassword.length < 8) {
      state = AuthError('New password must be at least 8 characters');
      return;
    }

    if (newPassword != confirmPassword) {
      state = AuthError('New passwords do not match');
      return;
    }

    try {
      state = AuthLoading();
      
      await _authService.changePassword(currentPassword, newPassword, confirmPassword);
      
      // Keep current state after successful password change
      if (state is AuthLoading) {
        final currentUser = await _authService.getCurrentUser();
        if (currentUser != null) {
          state = AuthAuthenticated(currentUser);
        }
      }
      
    } catch (e) {
      state = AuthError(e.toString());
    }
  }

  // Forgot password
  Future<void> forgotPassword(String email) async {
    if (email.trim().isEmpty) {
      state = AuthError('Email is required');
      return;
    }

    try {
      state = AuthLoading();
      await _authService.forgotPassword(email);
      // Keep current state after successful OTP send
      if (state is AuthLoading) {
        final currentUser = await _authService.getCurrentUser();
        if (currentUser != null) {
          state = AuthAuthenticated(currentUser);
        } else {
          state = AuthUnauthenticated();
        }
      }
    } catch (e) {
      state = AuthError(e.toString());
    }
  }

  // Verify OTP
  Future<void> verifyOTP(String email, String otp) async {
    if (email.trim().isEmpty || otp.trim().isEmpty) {
      state = AuthError('Email and OTP are required');
      return;
    }

    try {
      state = AuthLoading();
      await _authService.verifyOTP(email, otp);
      // Keep current state after successful OTP verification
      if (state is AuthLoading) {
        final currentUser = await _authService.getCurrentUser();
        if (currentUser != null) {
          state = AuthAuthenticated(currentUser);
        } else {
          state = AuthUnauthenticated();
        }
      }
    } catch (e) {
      state = AuthError(e.toString());
    }
  }

  // Reset password
  Future<void> resetPassword(String email, String otp, String newPassword, String confirmPassword) async {
    if (email.trim().isEmpty || otp.trim().isEmpty || newPassword.trim().isEmpty || confirmPassword.trim().isEmpty) {
      state = AuthError('All fields are required');
      return;
    }

    if (newPassword.length < 8) {
      state = AuthError('Password must be at least 8 characters');
      return;
    }

    if (newPassword != confirmPassword) {
      state = AuthError('Passwords do not match');
      return;
    }

    try {
      state = AuthLoading();
      await _authService.resetPassword(email, otp, newPassword, confirmPassword);
      // Navigate to login after successful password reset
      state = AuthUnauthenticated();
    } catch (e) {
      state = AuthError(e.toString());
    }
  }
}

// Providers
final authViewModelProvider = StateNotifierProvider<AuthViewModel, AuthState>((ref) {
  final authService = ref.read(authServiceProvider);
  return AuthViewModel(authService);
});

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



