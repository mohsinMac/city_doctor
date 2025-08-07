import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import 'api_service.dart';

class AuthService {
  final ApiService _apiService = ApiService();
  
  // Keys for storing data
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';

  // Login user
  Future<User> login(String email, String password) async {
    // Call API to login
    final response = await _apiService.signIn(
      email: email,
      password: password,
    );

    // Get tokens from response
    final accessToken = response['access'] as String;
    final refreshToken = response['refresh'] as String;

    // Store tokens
    await _storeTokens(accessToken, refreshToken);
    
    // Create user object
    final user = User(
      id: 10,
      email: email,
      firstName: email.split('@').first,
      lastName: '',
    );
    
    // Store user data
    await _storeUser(user);
    
    print('✅ Login successful - User stored: ${user.email}');
    
    return user;
  }

  // Logout user
  Future<void> logout() async {
    print('🚪 Logging out user');
    await _clearStoredData();
    print('✅ Logout completed - data cleared');
  }

  // Check if user is logged in
  Future<bool> isAuthenticated() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    final userJson = prefs.getString(_userKey);
    
    final hasToken = token != null && token.isNotEmpty;
    final hasUser = userJson != null && userJson.isNotEmpty;
    
    print('🔐 Auth check - Token: $hasToken, User: $hasUser');
    
    // Check if both token and user data exist
    return hasToken && hasUser;
  }

  // Get current user from storage
  Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    
    print('👤 Getting current user - User JSON: ${userJson != null ? "exists" : "null"}');
    
    if (userJson != null) {
      try {
        final userData = json.decode(userJson) as Map<String, dynamic>;
        final user = User.fromJson(userData);
        print('👤 Current user: ${user.email}');
        return user;
      } catch (e) {
        print('❌ Error parsing user data: $e');
        return null;
      }
    }
    return null;
  }

  // Get user profile from API
  Future<User> fetchUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    
    if (token == null) {
      throw Exception('No token available');
    }

    // Get profile from API
    final user = await _apiService.getUserProfile(token);
    
    // Store user data
    await _storeUser(user);
    
    return user;
  }

  // Change password
  Future<void> changePassword(String currentPassword, String newPassword, String confirmPassword) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    
    if (token == null) {
      throw Exception('No token available');
    }

    // Call API to change password
    await _apiService.changePassword(token, currentPassword, newPassword, confirmPassword);
  }

  // Forgot password
  Future<void> forgotPassword(String email) async {
    print('📧 Calling forgot password API for: $email');
    
    try {
      // Call API to send OTP
      await _apiService.forgotPassword(email);
      print('✅ Forgot password API call successful');
    } catch (e) {
      print('❌ Forgot password API call failed: $e');
      rethrow;
    }
  }

  // Verify OTP
  Future<void> verifyOTP(String email, String otp) async {
    // Call API to verify OTP
    await _apiService.verifyOTP(email, otp);
  }

  // Reset password
  Future<void> resetPassword(String email, String otp, String newPassword, String confirmPassword) async {
    // Call API to reset password
    await _apiService.resetPassword(email, otp, newPassword, confirmPassword);
  }

  // Helper methods
  Future<void> _storeTokens(String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, accessToken);
    print('🔑 Token stored successfully');
  }

  Future<void> _storeUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = json.encode(user.toJson());
    await prefs.setString(_userKey, userJson);
    print('💾 User data stored: ${user.email}');
  }

  Future<void> _clearStoredData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
    print('🗑️ Stored data cleared');
  }
} 