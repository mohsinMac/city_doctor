import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import 'api_service.dart';

class AuthService {
  final ApiService _apiService = ApiService();
  
  // Keys for SharedPreferences
  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userKey = 'user_data';

  /// Login with email and password
  Future<User> login(String email, String password) async {
    print('🚀 AuthService.login() called');
    print('📧 Email: $email');
    print('🔑 Password length: ${password.length}');
    
    try {
      print('📞 Calling API service...');
      // Call the real API
      final response = await _apiService.signIn(
        email: email,
        password: password,
        portal: 'staff', // Static portal value as requested
      );

      print('📥 API Response received');
      print('🔍 Response keys: ${response.keys.toList()}');

      // Extract tokens from response
      final accessToken = response['access'] as String?;
      final refreshToken = response['refresh'] as String?;

      print('🎫 Access Token: ${accessToken != null ? 'Present' : 'Missing'}');
      print('🔄 Refresh Token: ${refreshToken != null ? 'Present' : 'Missing'}');

      if (accessToken == null) {
        print('❌ Missing access token in response');
        throw Exception('Invalid response from server');
      }

      print('👤 Creating user object from email...');
      // Create user object from email since API doesn't provide user data
      final user = User(
        id: '10', // From the JWT token, user_id is 10
        email: email,
        name: _generateNameFromEmail(email),
        profileImage: null,
        createdAt: DateTime.now(),
      );

      print('💾 Storing tokens and user data...');
      // Store tokens and user data
      await _storeTokens(accessToken, refreshToken);
      await _storeUser(user);

      print('✅ Login completed successfully');
      print('👤 User: ${user.name} (${user.email})');
      return user;
    } catch (e) {
      print('❌ Error in AuthService.login(): $e');
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  /// Logout user
  Future<void> logout() async {
    try {
      // Clear stored tokens and user data
      await _clearStoredData();
    } catch (e) {
      // Even if clearing fails, we should still logout
      print('Error during logout: $e');
    }
  }

  /// Check if user is authenticated (e.g., has valid token)
  Future<bool> isAuthenticated() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_tokenKey);
      return token != null && token.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Get current user from storage/token
  Future<User?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_userKey);
      
      if (userJson != null) {
        final userData = json.decode(userJson) as Map<String, dynamic>;
        return User.fromJson(userData);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Register new user
  Future<User> register(String email, String password, String name) async {
    // For now, registration is not implemented in the API
    throw Exception('Registration is not available');
  }

  /// Reset password
  Future<void> resetPassword(String email) async {
    // For now, password reset is not implemented in the API
    throw Exception('Password reset is not available');
  }

  // Helper methods for token and user storage
  Future<void> _storeTokens(String accessToken, String? refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, accessToken);
    if (refreshToken != null) {
      await prefs.setString(_refreshTokenKey, refreshToken);
    }
  }

  Future<void> _storeUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, json.encode(user.toJson()));
  }

  Future<void> _clearStoredData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_refreshTokenKey);
    await prefs.remove(_userKey);
  }

  String _generateNameFromEmail(String email) {
    final username = email.split('@').first;
    return username.split('.').map((part) => 
      part.isNotEmpty ? part[0].toUpperCase() + part.substring(1) : ''
    ).join(' ');
  }
} 