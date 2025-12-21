import 'dart:ui';

import 'package:ai_carrer_path/utils/app_theme.dart';
import 'package:ai_carrer_path/widgets/custom_button.dart';
import 'package:ai_carrer_path/widgets/custom_text_field.dart';
import 'package:ai_carrer_path/widgets/education_dropdown.dart';
import 'package:ai_carrer_path/widgets/progress_indicator_dots.dart';
import 'package:ai_carrer_path/widgets/selection_chip.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _departmentController = TextEditingController();

  String _selectedEducation = "Bachelor's";
  String _selectedExperience = 'Fresher';
  final List<String> _selectedTracks = ['Web Dev'];
  bool _obscurePassword = true;

  final List<String> _educationLevels = [
    "Bachelor's",
    "Master's",
    "PhD",
    "Diploma",
  ];

  final List<String> _experienceLevels = ['Fresher', 'Junior', 'Mid-Level'];

  final List<String> _tracks = [
    'Web Dev',
    'Data Science',
    'UI/UX',
    'Cybersec',
    'Marketing',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _departmentController.dispose();
    super.dispose();
  }

  void _handleSignUp() {
    // TODO: Implement signup logic with backend
    print('Name: ${_nameController.text}');
    print('Email: ${_emailController.text}');
    print('Password: ${_passwordController.text}');
    print('Education: $_selectedEducation');
    print('Department: ${_departmentController.text}');
    print('Experience: $_selectedExperience');
    print('Tracks: $_selectedTracks');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header with back button and progress
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  ProgressIndicatorDots(currentStep: 2, totalSteps: 3),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    const Text(
                      'Create Account',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Join the AI-driven network tailored to boost\nyour career path.',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.textGrey,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Full Name
                    CustomTextField(
                      label: 'Full Name',
                      hint: 'John Doe',
                      controller: _nameController,
                      prefixIcon: Icons.person_outline,
                    ),

                    const SizedBox(height: 20),

                    // Email
                    CustomTextField(
                      label: 'Email Address',
                      hint: 'name@example.com',
                      controller: _emailController,
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                    ),

                    const SizedBox(height: 20),

                    // Password
                    CustomTextField(
                      label: 'Password',
                      hint: '••••••••',
                      controller: _passwordController,
                      prefixIcon: Icons.lock_outline,
                      obscureText: _obscurePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: AppTheme.textMidGrey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),

                    const SizedBox(height: 24),

                    const Divider(color: AppTheme.borderGreen),

                    const SizedBox(height: 24),

                    // Education and Department Row
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Education',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              EducationDropdown(
                                value: _selectedEducation,
                                items: _educationLevels,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedEducation = value!;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Department',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                controller: _departmentController,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: 'e.g. CS',
                                  hintStyle: const TextStyle(
                                    color: AppTheme.textDarkGrey,
                                  ),
                                  filled: true,
                                  fillColor: AppTheme.cardGreen,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide.none,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Experience Level
                    const Text(
                      'Experience Level',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Wrap(
                      spacing: 12,
                      children: _experienceLevels.map((level) {
                        return SelectionChip(
                          label: level,
                          isSelected: _selectedExperience == level,
                          onTap: () {
                            setState(() {
                              _selectedExperience = level;
                            });
                          },
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 24),

                    // Interested Tracks
                    const Text(
                      'Interested Tracks',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: _tracks.map((track) {
                        return SelectionChip(
                          label: track,
                          isSelected: _selectedTracks.contains(track),
                          onTap: () {
                            setState(() {
                              if (_selectedTracks.contains(track)) {
                                _selectedTracks.remove(track);
                              } else {
                                _selectedTracks.add(track);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 40),

                    // Sign Up Button
                    CustomButton(
                      text: 'Sign Up',
                      showArrow: true,
                      onPressed: _handleSignUp,
                    ),

                    const SizedBox(height: 24),

                    // Login Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account?  ',
                          style: TextStyle(
                            color: AppTheme.textMidGrey,
                            fontSize: 14,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(context, '/login'),
                          child: const Text(
                            'Log In',
                            style: TextStyle(
                              color: AppTheme.primaryGreen,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
