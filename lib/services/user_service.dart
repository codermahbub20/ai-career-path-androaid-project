import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user_model.dart';

class UserService {
  static const String baseUrl = 'http://localhost:5000/api';

  // Get logged-in user by filtering from /users endpoint
  Future<UserModel> getUserData(String token,
      {required String userEmail}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/users'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 20));

      print('Get Profile Status: ${response.statusCode}');
      print('Get Profile Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> decoded = json.decode(response.body);

        if (decoded['success'] != true || decoded['data'] == null) {
          throw Exception('Invalid response format');
        }

        final List<dynamic> usersList = decoded['data'];
        final userJson = usersList.cast<Map<String, dynamic>>().firstWhere(
              (user) => user['email'] == userEmail,
              orElse: () => throw Exception('Logged-in user not found'),
            );

        return UserModel.fromJson(userJson);
      } else {
        throw Exception('Failed to load profile (${response.statusCode})');
      }
    } catch (e) {
      print('UserService get error: $e');
      rethrow;
    }
  }

  // UPDATE USER PROFILE - PATCH /api/users/:userId
  Future<UserModel> updateUserProfile({
    required String token,
    required String userId,
    required Map<String, dynamic> updates,
  }) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/users/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(updates),
      );

      print('Update Profile Status: ${response.statusCode}');
      print('Update Profile Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> decoded = json.decode(response.body);

        // Your backend likely returns { success: true, data: { updatedUser } }
        final Map<String, dynamic> userJson =
            decoded['data'] ?? decoded['user'] ?? decoded;

        return UserModel.fromJson(userJson);
      } else {
        throw Exception(
            'Update failed: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Update error: $e');
      rethrow;
    }
  }
}
