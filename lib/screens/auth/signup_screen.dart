import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../widgets/custom_button.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  String selectedExperience = "Fresher";
  final List<String> experienceLevels = ["Fresher", "Junior", "Mid-Level"];

  final List<String> interests = [
    "Web Dev",
    "Data Science",
    "UI/UX",
    "Cybersec",
    "Marketing"
  ];
  final Set<String> selectedInterests = {"Web Dev"};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                    color: Colors.grey, shape: BoxShape.circle)),
            const SizedBox(width: 8),
            Container(
                width: 24,
                height: 8,
                decoration: BoxDecoration(
                    color: AppColors.primaryGreen,
                    borderRadius: BorderRadius.circular(4))),
            const SizedBox(width: 8),
            Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                    color: Colors.grey, shape: BoxShape.circle)),
          ],
        ),
        centerTitle: true,
        actions: const [SizedBox(width: 48)], // Center the dots
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Create Account",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text(
                "Join the AI-driven network tailored to boost your career path.",
                style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 30),
            _buildLabel("Full Name"),
            _buildTextField(hint: "John Doe", icon: Icons.person_outline),
            const SizedBox(height: 16),
            _buildLabel("Email Address"),
            _buildTextField(
                hint: "name@example.com", icon: Icons.email_outlined),
            const SizedBox(height: 16),
            _buildLabel("Password"),
            _buildTextField(
                hint: "........", icon: Icons.lock_outline, isPassword: true),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel("Education"),
                      _buildDropdown("Bachelor's"),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel("Department"),
                      _buildTextField(hint: "e.g. CS", icon: null),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildLabel("Experience Level"),
            const SizedBox(height: 8),
            Wrap(
              spacing: 10,
              children: experienceLevels.map((level) {
                final isSelected = selectedExperience == level;
                return ChoiceChip(
                  label: Text(level),
                  selected: isSelected,
                  selectedColor: AppColors.primaryGreen,
                  backgroundColor: AppColors.cardBackground,
                  labelStyle: TextStyle(
                      color: isSelected ? Colors.black : Colors.white),
                  onSelected: (bool selected) {
                    setState(() {
                      selectedExperience = level;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            _buildLabel("Interested Tracks"),
            const SizedBox(height: 8),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: interests.map((interest) {
                final isSelected = selectedInterests.contains(interest);
                return FilterChip(
                  label: Text(interest),
                  selected: isSelected,
                  selectedColor: AppColors.primaryGreen.withOpacity(0.2),
                  backgroundColor: AppColors.cardBackground,
                  checkmarkColor: AppColors.primaryGreen,
                  side: BorderSide(
                      color: isSelected
                          ? AppColors.primaryGreen
                          : Colors.transparent),
                  labelStyle: const TextStyle(color: Colors.white),
                  onSelected: (bool selected) {
                    setState(() {
                      if (selected) {
                        selectedInterests.add(interest);
                      } else {
                        selectedInterests.remove(interest);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 40),
            CustomButton(text: "Sign Up →", onPressed: () {}),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account? ",
                    style: TextStyle(color: Colors.grey)),
                GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen())),
                  child: const Text("Log In",
                      style: TextStyle(
                          color: AppColors.primaryGreen,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child:
          Text(text, style: const TextStyle(fontSize: 14, color: Colors.grey)),
    );
  }

  Widget _buildTextField(
      {required String hint, IconData? icon, bool isPassword = false}) {
    return TextField(
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        prefixIcon: icon != null ? Icon(icon, color: Colors.grey) : null,
        suffixIcon: isPassword
            ? const Icon(Icons.visibility_off, color: Colors.grey)
            : null,
        filled: true,
        fillColor: AppColors.cardBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      ),
    );
  }

  Widget _buildDropdown(String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(30),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          dropdownColor: AppColors.cardBackground,
          items:
              <String>['Bachelor\'s', 'Master\'s', 'PhD'].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (_) {},
        ),
      ),
    );
  }
}
