import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../../constants/app_colors.dart';

class SkillGapScreen extends StatelessWidget {
  const SkillGapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Text('Skill Gap Analysis'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMainAnalysisCard(),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(child: _buildTabButton("Missing Skills (3)", true)),
                const SizedBox(width: 16),
                Expanded(child: _buildTabButton("Acquired (12)", false)),
              ],
            ),
            const SizedBox(height: 24),
            const Text('Priority Gaps',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildGapCard(
              title: "Data Analytics",
              subtitle: "Essential for Senior Roles",
              current: "Beginner",
              target: "Advanced",
              progress: 0.3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainAnalysisCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Target Role',
                      style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 4),
                  const Text('Senior UX Designer',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                        color: AppColors.primaryGreen.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4)),
                    child: const Text('High Demand',
                        style: TextStyle(
                            color: AppColors.primaryGreen, fontSize: 12)),
                  )
                ],
              ),
              CircularPercentIndicator(
                radius: 40.0,
                lineWidth: 8.0,
                percent: 0.72,
                center: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("72%",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    Text("Match",
                        style: TextStyle(fontSize: 10, color: Colors.grey)),
                  ],
                ),
                progressColor: AppColors.primaryGreen,
                backgroundColor: Colors.black,
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(color: Colors.white10),
          const SizedBox(height: 16),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.auto_awesome, color: AppColors.primaryGreen, size: 20),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'AI Insight: You are 3 key skills away from being a top candidate. Closing these gaps could increase your salary potential by ~15%.',
                  style: TextStyle(color: Colors.grey, height: 1.4),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildTabButton(String text, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primaryGreen : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(30),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.black : Colors.grey,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildGapCard(
      {required String title,
      required String subtitle,
      required String current,
      required String target,
      required double progress}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                const Icon(Icons.pie_chart_outline, color: Colors.orange),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    Text(subtitle,
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                )
              ]),
              const Icon(Icons.bookmark_outline, color: Colors.grey),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Current: $current',
                  style: const TextStyle(fontSize: 12, color: Colors.grey)),
              Text('Target: $target',
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.primaryGreen)),
            ],
          ),
          const SizedBox(height: 8),
          LinearPercentIndicator(
            padding: EdgeInsets.zero,
            lineHeight: 6.0,
            percent: progress,
            backgroundColor: Colors.black,
            progressColor: AppColors.primaryGreen,
            barRadius: const Radius.circular(3),
          ),
          const SizedBox(height: 20),
          // Recommended Course Mini-Card
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: Colors.black, borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                Container(
                    width: 40,
                    height: 40,
                    color: Colors.white), // Img Placeholder
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Google Data Analytics',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('Coursera • 4.8 ★',
                          style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ),
                const Icon(Icons.play_circle_fill,
                    color: AppColors.primaryGreen, size: 30),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(children: [
            Expanded(
                child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: Colors.black),
              child: const Text('Start Learning'),
            )),
            const SizedBox(width: 12),
            Expanded(
                child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.grey)),
              child: const Text('Add to Plan'),
            )),
          ])
        ],
      ),
    );
  }
}
