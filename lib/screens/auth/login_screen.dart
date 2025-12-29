import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../widgets/custom_button.dart';
import '../../services/auth_service.dart';
import '../main_navigation_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    setState(() => _isLoading = true);
    final authService = Provider.of<AuthService>(context, listen: false);
    final success = await authService.login(
        _emailController.text, _passwordController.text);
    setState(() => _isLoading = false);

    if (success) {
      if (mounted)
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => const MainNavigationScreen()));
    } else {
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Login failed. Try "password123"'),
            backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background, // Forces dark background
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Center(
                  child: Icon(Icons.rocket_launch,
                      color: AppColors.primaryGreen, size: 60)),
              const SizedBox(height: 20),
              const Center(
                  child: Text("Welcome Back",
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white))),
              const SizedBox(height: 8),
              const Center(
                  child: Text(
                      "Log in to continue your journey towards your dream career.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey))),
              const SizedBox(height: 40),
              _buildLabel("Email Address"),
              const SizedBox(height: 8),
              _buildTextField(
                  controller: _emailController,
                  hint: "you@example.com",
                  icon: Icons.email_outlined),
              const SizedBox(height: 20),
              _buildLabel("Password"),
              const SizedBox(height: 8),
              _buildTextField(
                  controller: _passwordController,
                  hint: "........",
                  icon: Icons.lock_outline,
                  isPassword: true),
              Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                      onPressed: () {},
                      child: const Text("Forgot Password?",
                          style: TextStyle(color: AppColors.primaryGreen)))),
              const SizedBox(height: 20),
              _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                          color: AppColors.primaryGreen))
                  : CustomButton(text: "Login →", onPressed: _handleLogin),
              const SizedBox(height: 30),
              Row(children: const [
                Expanded(child: Divider(color: Colors.grey)),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text("Or continue with",
                        style: TextStyle(color: Colors.grey))),
                Expanded(child: Divider(color: Colors.grey))
              ]),
              const SizedBox(height: 20),
              Row(children: [
                Expanded(
                    child: _buildSocialButton("Google", Icons.g_mobiledata)),
                const SizedBox(width: 16),
                Expanded(child: _buildSocialButton("Apple", Icons.apple))
              ]),
              const SizedBox(height: 40),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Text("Don't have an account? ",
                    style: TextStyle(color: Colors.grey)),
                GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignupScreen())),
                    child: const Text("Sign Up",
                        style: TextStyle(
                            color: AppColors.primaryGreen,
                            fontWeight: FontWeight.bold)))
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(text, style: const TextStyle(fontSize: 14, color: Colors.grey));
  }

  Widget _buildTextField(
      {required TextEditingController controller,
      required String hint,
      required IconData icon,
      bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,

      // *** THIS FIXES THE INVISIBLE TEXT ***
      style: const TextStyle(color: Colors.white),
      cursorColor: AppColors.primaryGreen,
      // *************************************

      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        prefixIcon: Icon(icon, color: Colors.grey),
        suffixIcon: isPassword
            ? const Icon(Icons.visibility_off, color: Colors.grey)
            : null,
        filled: true,
        fillColor: AppColors.cardBackground,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
      ),
    );
  }

  Widget _buildSocialButton(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade800),
          borderRadius: BorderRadius.circular(30),
          color: AppColors.cardBackground),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(icon, size: 20, color: Colors.white),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(color: Colors.white))
      ]),
    );
  }
}
