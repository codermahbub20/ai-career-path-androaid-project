// screens/jobs/job_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../constants/app_colors.dart';
import '../../models/job_model.dart';

class JobDetailScreen extends StatelessWidget {
  final JobModel job;
  final int matchPercentage;

  const JobDetailScreen(
      {super.key, required this.job, required this.matchPercentage});

  @override
  Widget build(BuildContext context) {
    final bool isHighMatch = matchPercentage >= 70;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context)),
        title: Text(job.title),
        actions: [IconButton(icon: const Icon(Icons.share), onPressed: () {})],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
                radius: 40,
                backgroundColor: Colors.white,
                child: Text(job.company[0],
                    style: const TextStyle(fontSize: 24, color: Colors.black))),
            const SizedBox(height: 16),
            Text(job.title,
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            const SizedBox(height: 8),
            Text('${job.company} • ${job.location}',
                style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatBox(Icons.work, 'Type', job.jobType),
                _buildStatBox(Icons.school, 'Level', job.experienceLevel),
                _buildStatBox(Icons.location_on, 'Location',
                    job.location == 'Remote' ? 'Remote' : 'On-site'),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: const [
                            Icon(Icons.auto_awesome,
                                color: AppColors.primaryGreen, size: 16),
                            SizedBox(width: 8),
                            Text('AI ANALYSIS',
                                style: TextStyle(
                                    color: AppColors.primaryGreen,
                                    fontWeight: FontWeight.bold))
                          ]),
                          const SizedBox(height: 8),
                          Text(isHighMatch ? 'Strong Match!' : 'Good Fit',
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ],
                      ),
                      CircularPercentIndicator(
                        radius: 35,
                        lineWidth: 8,
                        percent: matchPercentage / 100,
                        center: Text("$matchPercentage%",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        progressColor: isHighMatch
                            ? AppColors.primaryGreen
                            : Colors.orange,
                        backgroundColor: Colors.grey.withOpacity(0.3),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(job.description,
                      style: const TextStyle(color: Colors.grey, height: 1.6)),
                  const SizedBox(height: 20),
                  const Text('REQUIRED SKILLS',
                      style: TextStyle(color: Colors.grey, fontSize: 12)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: job.requiredSkills
                        .map((skill) => Chip(
                              label: Text(skill),
                              backgroundColor: Colors.white10,
                              labelStyle: const TextStyle(color: Colors.white),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: AppColors.cardBackground,
                        borderRadius: BorderRadius.circular(12)),
                    child:
                        const Icon(Icons.bookmark_border, color: Colors.white)),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // You can launch URL here
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 18)),
                    child: const Text('Apply Now',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildStatBox(IconData icon, String label, String value) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primaryGreen),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 4),
          Text(value,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
