import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends ChangeNotifier {
  // For web with CORS issues, you can use a proxy:
  // Install: npm install -g local-cors-proxy
  // Run: lcp --proxyUrl http://localhost:5000
  // Then use: http://localhost:8010/proxy
  static const String baseUrl = 'http://localhost:5000/api/auth';

  // Or for Android emulator use:
  // static const String baseUrl = 'http://10.0.2.2:5000/api/auth';

  bool _isAuthenticated = false;
  String? _token;
  Map<String, dynamic>? _userData;

  bool get isAuthenticated => _isAuthenticated;
  String? get token => _token;
  Map<String, dynamic>? get userData => _userData;

  AuthService() {
    _loadToken();
  }

  // Load token from SharedPreferences on app start
  Future<void> _loadToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _token = prefs.getString('auth_token');
      final userDataString = prefs.getString('user_data');

      if (_token != null && userDataString != null) {
        _userData = jsonDecode(userDataString);
        _isAuthenticated = true;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading token: $e');
    }
  }

  // Login method
  Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      debugPrint('Login Response Status: ${response.statusCode}');
      debugPrint('Login Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        // Handle your API response format: { "success": true, "data": { "token": "..." } }
        if (responseData['success'] == true && responseData['data'] != null) {
          final data = responseData['data'];

          _token = data['token'];
          _userData = data['user'] ??
              {
                'email': email,
                'id': data['userId'] ?? data['id'],
              };
          _isAuthenticated = true;

          // Save to SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', _token!);
          await prefs.setString('user_data', jsonEncode(_userData));

          notifyListeners();
          return true;
        }

        return false;
      } else {
        debugPrint('Login failed: ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint('Login error: $e');
      rethrow;
    }
  }

  // Signup method
  Future<bool> signup(String email, String password, String name) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/signup'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
          'name': name,
        }),
      );

      debugPrint('Signup Response Status: ${response.statusCode}');
      debugPrint('Signup Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);

        // Handle your API response format
        if (responseData['success'] == true && responseData['data'] != null) {
          final data = responseData['data'];

          _token = data['token'];
          _userData = data['user'] ??
              {
                'email': email,
                'name': name,
                'id': data['userId'] ?? data['id'],
              };
          _isAuthenticated = true;

          // Save to SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', _token!);
          await prefs.setString('user_data', jsonEncode(_userData));

          notifyListeners();
          return true;
        }

        return false;
      } else {
        debugPrint('Signup failed: ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint('Signup error: $e');
      rethrow;
    }
  }

  // Logout method
  Future<void> logout() async {
    try {
      _token = null;
      _userData = null;
      _isAuthenticated = false;

      // Clear from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      await prefs.remove('user_data');

      notifyListeners();

      debugPrint('Logout successful');
    } catch (e) {
      debugPrint('Logout error: $e');
      rethrow;
    }
  }

  // Check if user is authenticated
  Future<bool> checkAuth() async {
    await _loadToken();
    return _isAuthenticated;
  }

  Future<void> initialize() async {}
}
