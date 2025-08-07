import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class ApiService {
  static const String baseUrl = 'https://backend.citydoctor.ae/v1';
  
  // Basic headers for all API calls
  static Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Login API
  Future<Map<String, dynamic>> signIn({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/signin/');
    
    final body = json.encode({
      'email': email,
      'password': password,
      'portal': 'staff',
    });

    final response = await http.post(url, headers: _headers, body: body);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 401) {
      throw Exception('Invalid email or password');
    } else {
      throw Exception('Login failed');
    }
  }

  // Get user profile API
  Future<User> getUserProfile(String token) async {
    final url = Uri.parse('$baseUrl/user/me/');
    
    final headers = Map<String, String>.from(_headers);
    headers['Authorization'] = 'Bearer $token';
    
    final response = await http.get(url, headers: headers);
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return User.fromJson(data);
    } else {
      throw Exception('Failed to get profile');
    }
  }

  // Change password API
  Future<void> changePassword(String token, String currentPassword, String newPassword, String confirmPassword) async {
    final url = Uri.parse('$baseUrl/c/change/password/');
    
    print('🌐 Making change password request to: $url');
    print('📧 Request body: {"current_password": "***", "password": "***", "confirm_password": "***"}');
    
    final headers = Map<String, String>.from(_headers);
    headers['Authorization'] = 'Bearer $token';
    
    final body = json.encode({
      'current_password': currentPassword,
      'password': newPassword,
      'confirm_password': confirmPassword,
    });

    final response = await http.post(url, headers: headers, body: body);
    
    print('📡 Response status: ${response.statusCode}');
    print('📡 Response body: ${response.body}');
    
    if (response.statusCode == 200) {
      print('✅ Password change successful');
      return;
    } else if (response.statusCode == 400) {
      print('❌ Bad request error: Invalid current password');
      throw Exception('Invalid current password');
    } else {
      print('❌ Server error: ${response.statusCode}');
      throw Exception('Failed to change password');
    }
  }

  // Forgot password API
  Future<void> forgotPassword(String email) async {
    final url = Uri.parse('$baseUrl/c/user/request/reset/');
    
    print('🌐 Making forgot password request to: $url');
    print('📧 Request body: {"email": "$email"}');
    
    final body = json.encode({
      'email': email,
    });

    final response = await http.post(url, headers: _headers, body: body);
    
    print('📡 Response status: ${response.statusCode}');
    print('📡 Response body: ${response.body}');
    
    if (response.statusCode == 200) {
      print('✅ Forgot password request successful');
      return;
    } else if (response.statusCode == 400) {
      final responseData = json.decode(response.body);
      print('❌ Bad request error: $responseData');
      if (responseData['detail'] != null) {
        throw Exception(responseData['detail']);
      } else {
        throw Exception('Failed to send OTP');
      }
    } else {
      print('❌ Server error: ${response.statusCode}');
      throw Exception('Failed to send OTP');
    }
  }

  // Verify OTP API
  Future<void> verifyOTP(String email, String otp) async {
    final url = Uri.parse('$baseUrl/c/user/verify/otp/');
    
    print('🌐 Making OTP verification request to: $url');
    print('📧 Request body: {"email": "$email", "otp": "$otp"}');
    
    final body = json.encode({
      'email': email,
      'otp': otp,
    });

    final response = await http.post(url, headers: _headers, body: body);
    
    print('📡 Response status: ${response.statusCode}');
    print('📡 Response body: ${response.body}');
    
    if (response.statusCode == 200) {
      print('✅ OTP verification successful');
      return;
    } else if (response.statusCode == 400) {
      final responseData = json.decode(response.body);
      print('❌ Bad request error: $responseData');
      if (responseData['detail'] != null) {
        throw Exception(responseData['detail']);
      } else {
        throw Exception('Invalid OTP');
      }
    } else {
      print('❌ Server error: ${response.statusCode}');
      throw Exception('Failed to verify OTP');
    }
  }

  // Reset password API
  Future<void> resetPassword(String email, String otp, String newPassword, String confirmPassword) async {
    final url = Uri.parse('$baseUrl/c/user/reset/password/');
    
    print('🌐 Making password reset request to: $url');
    print('📧 Request body: {"email": "$email", "otp": "$otp", "password": "***", "confirm_password": "***"}');
    
    final body = json.encode({
      'email': email,
      'otp': otp,
      'password': newPassword,
      'confirm_password': confirmPassword,
    });

    final response = await http.post(url, headers: _headers, body: body);
    
    print('📡 Response status: ${response.statusCode}');
    print('📡 Response body: ${response.body}');
    
    if (response.statusCode == 200) {
      print('✅ Password reset successful');
      return;
    } else if (response.statusCode == 400) {
      final responseData = json.decode(response.body);
      print('❌ Bad request error: $responseData');
      if (responseData['detail'] != null) {
        throw Exception(responseData['detail']);
      } else {
        throw Exception('Failed to reset password');
      }
    } else {
      print('❌ Server error: ${response.statusCode}');
      throw Exception('Failed to reset password');
    }
  }
} 