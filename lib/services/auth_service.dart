import 'package:flutter/material.dart';

// A simple class to represent a user
class AppUser {
  final String id;
  final String email;
  final String name;

  AppUser({required this.id, required this.email, required this.name});
}

// This class manages the authentication state for the entire app
class AuthService with ChangeNotifier {
  AppUser? _user; // The currently logged-in user, null if logged out

  AppUser? get user => _user;
  bool get isLoggedIn => _user != null;

  // Simulate a login process
  Future<bool> login(String email, String password) async {
    try {
      // In a real app, you would call Firebase Auth or your API here.
      // We'll simulate a network delay.
      await Future.delayed(const Duration(seconds: 2));

      // Fake validation
      if (email.isNotEmpty && password == "password123") {
        _user = AppUser(id: '1', email: email, name: 'John Doe');
        notifyListeners(); // Tell the app that the login state has changed
        return true; // Login successful
      } else {
        return false; // Login failed
      }
    } catch (e) {
      return false;
    }
  }

  // Simulate a logout process
  void logout() {
    _user = null;
    notifyListeners(); // Tell the app that the login state has changed
  }
}
