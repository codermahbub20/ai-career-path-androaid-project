import 'package:ai_carrer_path/widgets/progress_indicator_dots.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool showProgress;
  final int? currentStep;
  final int? totalSteps;

  const CustomAppBar({
    Key? key,
    this.title,
    this.showProgress = false,
    this.currentStep,
    this.totalSteps,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            if (title != null) ...[
              const SizedBox(width: 8),
              Text(
                title!,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
            if (showProgress && currentStep != null && totalSteps != null) ...[
              const Spacer(),
              ProgressIndicatorDots(
                currentStep: currentStep!,
                totalSteps: totalSteps!,
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}
