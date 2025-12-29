import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class RoadmapScreen extends StatelessWidget {
  const RoadmapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("AI Career Roadmap"), actions: [
        const Icon(Icons.smart_toy, color: AppColors.primaryGreen),
        const SizedBox(width: 16)
      ]),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Build Your Path",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const Text("Define your goals to generate a plan.",
                style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),

            const Text("Target Role", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),
            _buildInputContainer(Icons.work, "Junior Product Designer"),

            const SizedBox(height: 20),
            const Text("Current Skills", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),
            _buildInputContainer(
                Icons.build, "Figma, Basic UX Research, Wireframing"),

            const SizedBox(height: 20),
            const Text("Timeline Goal", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                    child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                      color: AppColors.primaryGreen,
                      borderRadius: BorderRadius.circular(30)),
                  child: const Center(
                      child: Text("3 Months",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold))),
                )),
                const SizedBox(width: 16),
                Expanded(
                    child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(30)),
                  child: const Center(
                      child: Text("6 Months",
                          style: TextStyle(color: Colors.grey))),
                )),
              ],
            ),

            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primaryGreen),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.refresh, color: AppColors.primaryGreen),
                  SizedBox(width: 8),
                  Text("Regenerate Roadmap",
                      style: TextStyle(
                          color: AppColors.primaryGreen,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),

            const SizedBox(height: 30),
            Row(children: [
              Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                      color: AppColors.primaryGreen, shape: BoxShape.circle)),
              const SizedBox(width: 8),
              const Text("Your Personalized Plan",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ]),
            const SizedBox(height: 16),

            // Download Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Colors.green.shade900.withOpacity(0.4),
                    Colors.black
                  ]),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: AppColors.primaryGreen.withOpacity(0.3))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("WEEKS 1-4",
                      style: TextStyle(
                          color: AppColors.primaryGreen,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text("Foundations & Theory",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        foregroundColor: Colors.black,
                        minimumSize: const Size(double.infinity, 50)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.download),
                        SizedBox(width: 8),
                        Text("Download PDF")
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInputContainer(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16)),
      child: Row(children: [
        Icon(icon, color: Colors.grey),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 16))),
      ]),
    );
  }
}
