import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class ApiService {
  static const String baseUrl = 'https://backend.citydoctor.ae/v1';
  
  // Headers for API requests
  static Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  /// Sign in API call
  Future<Map<String, dynamic>> signIn({
    required String email,
    required String password,
    String portal = 'staff', // Static portal value
  }) async {
    try {
      final url = Uri.parse('$baseUrl/signin/');
      
      final body = json.encode({
        'email': email,
        'password': password,
        'portal': portal,
      });

      print('🔐 API Call - SignIn');
      print('📧 Email: $email');
      print('🔑 Portal: $portal');
      print('🌐 URL: $url');
      print('📦 Request Body: $body');

      final response = await http.post(
        url,
        headers: _headers,
        body: body,
      );

      print('📡 Response Status: ${response.statusCode}');
      print('📄 Response Body: ${response.body}');
      print('📋 Response Headers: ${response.headers}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('✅ Login successful');
        print('🎯 Response Data: $data');
        return data;
      } else if (response.statusCode == 401) {
        print('❌ Unauthorized - Invalid credentials');
        throw Exception('Invalid email or password');
      } else if (response.statusCode == 400) {
        final errorData = json.decode(response.body);
        String errorMessage = 'Invalid request';
        
        // Try to extract error message from different possible formats
        if (errorData['error'] != null) {
          if (errorData['error'] is List) {
            errorMessage = (errorData['error'] as List).first.toString();
          } else {
            errorMessage = errorData['error'].toString();
          }
        } else if (errorData['message'] != null) {
          errorMessage = errorData['message'].toString();
        } else if (errorData['detail'] != null) {
          errorMessage = errorData['detail'].toString();
        }
        
        print('❌ Bad Request: $errorMessage');
        throw Exception(errorMessage);
      } else {
        print('❌ Server Error: ${response.statusCode}');
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Exception in signIn: $e');
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Network error: ${e.toString()}');
    }
  }

  /// Get user profile
  Future<User> getUserProfile(String token) async {
    try {
      final url = Uri.parse('$baseUrl/profile/');
      
      final headers = Map<String, String>.from(_headers);
      headers['Authorization'] = 'Bearer $token';

      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return User.fromJson(data);
      } else {
        throw Exception('Failed to get user profile');
      }
    } catch (e) {
      throw Exception('Failed to get user profile: ${e.toString()}');
    }
  }

  /// Refresh token
  Future<String> refreshToken(String refreshToken) async {
    try {
      final url = Uri.parse('$baseUrl/refresh/');
      
      final body = json.encode({
        'refresh': refreshToken,
      });

      final response = await http.post(
        url,
        headers: _headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['access'] ?? '';
      } else {
        throw Exception('Failed to refresh token');
      }
    } catch (e) {
      throw Exception('Failed to refresh token: ${e.toString()}');
    }
  }
} 