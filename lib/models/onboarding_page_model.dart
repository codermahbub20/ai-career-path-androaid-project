import 'package:flutter/material.dart';

class OnboardingPageModel {
  final String title;
  final String? titleHighlight;
  final String description;
  final IconData icon;

  OnboardingPageModel({
    required this.title,
    this.titleHighlight,
    required this.description,
    required this.icon,
  });
}
