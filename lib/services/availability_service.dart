import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AvailabilityService {
  static const String baseUrl = 'https://backend.citydoctor.ae/v1';
  static const String _tokenKey = 'auth_token';
  
  // Basic headers for all API calls
  static Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Get current availability status
  Future<bool> getAvailability() async {
    // Use local storage since get availability endpoint is not available
    print('📱 Getting availability from local storage');
    return await _getLocalAvailability();
  }

  // Toggle availability
  Future<void> toggleAvailability() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    
    if (token == null) {
      throw Exception('No token available');
    }

    final url = Uri.parse('$baseUrl/c/user/toggle/availability/');
    
    print('🌐 Toggling availability at: $url');
    
    final headers = Map<String, String>.from(_headers);
    headers['Authorization'] = 'Bearer $token';
    
    final response = await http.get(url, headers: headers);
    
    print('📡 Toggle availability response status: ${response.statusCode}');
    print('📡 Toggle availability response body: ${response.body}');
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('✅ Availability updated: ${data['detail']}');
      
      // Store the new availability state locally
      final currentState = await _getLocalAvailability();
      await _setLocalAvailability(!currentState);
    } else if (response.statusCode == 401) {
      print('❌ Unauthorized: User not authenticated');
      throw Exception('User not authenticated');
    } else {
      print('❌ Server error: ${response.statusCode}');
      throw Exception('Failed to toggle availability');
    }
  }

  // Helper methods for local storage
  Future<bool> _getLocalAvailability() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('staff_availability_status') ?? false;
  }

  Future<void> _setLocalAvailability(bool isAvailable) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('staff_availability_status', isAvailable);
    print('💾 Local availability updated: $isAvailable');
  }
}
