import 'package:ai_carrer_path/utils/app_theme.dart';
import 'package:flutter/material.dart';

class ProgressIndicatorDots extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const ProgressIndicatorDots({
    Key? key,
    required this.currentStep,
    required this.totalSteps,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        totalSteps,
        (index) => Container(
          margin: const EdgeInsets.only(left: 8),
          height: 4,
          width: currentStep == index + 1 ? 40 : 20,
          decoration: BoxDecoration(
            color: currentStep == index + 1
                ? AppTheme.primaryGreen
                : AppTheme.borderGreen,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }
}
