import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../constants/app_colors.dart';

class JobDetailScreen extends StatelessWidget {
  const JobDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Junior UX Designer'),
        actions: [
          IconButton(icon: const Icon(Icons.share), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header
            const CircleAvatar(
                radius: 40,
                backgroundColor: Colors.white,
                child: Text("TecFlow", style: TextStyle(color: Colors.black))),
            const SizedBox(height: 16),
            const Text('Junior UX Designer',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('TechFlow Solutions • San Francisco',
                style: TextStyle(color: Colors.grey)),

            const SizedBox(height: 24),
            // Stats Grid
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatBox(Icons.attach_money, 'Salary', '\$60k - \$80k'),
                _buildStatBox(Icons.work, 'Type', 'Full-time'),
                _buildStatBox(Icons.access_time, 'Experience', '1-3 Years'),
              ],
            ),

            const SizedBox(height: 24),
            // AI Analysis Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Row(children: [
                            Icon(Icons.auto_awesome,
                                color: AppColors.primaryGreen, size: 16),
                            SizedBox(width: 8),
                            Text('AI ANALYSIS',
                                style: TextStyle(
                                    color: AppColors.primaryGreen,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold)),
                          ]),
                          SizedBox(height: 8),
                          Text('Strong Match!',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      CircularPercentIndicator(
                        radius: 25.0,
                        lineWidth: 5.0,
                        percent: 0.85,
                        center: const Text("85%",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12)),
                        progressColor: AppColors.primaryGreen,
                        backgroundColor: Colors.grey.withOpacity(0.2),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                      'You have 5 out of 7 required skills for this position. Your portfolio matches the visual style TechFlow is looking for.',
                      style: TextStyle(color: Colors.grey, height: 1.5)),
                  const SizedBox(height: 16),
                  const Text('MATCHED SKILLS',
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 8),
                  Wrap(spacing: 8, children: [
                    _buildSkillChip('Figma', true),
                    _buildSkillChip('UI Design', true),
                    _buildSkillChip('Prototyping', true),
                  ]),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text('MISSING SKILLS',
                          style: TextStyle(fontSize: 12, color: Colors.grey)),
                      Text('Why these matter?',
                          style: TextStyle(
                              fontSize: 12, color: AppColors.primaryGreen)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(spacing: 8, children: [
                    _buildSkillChip('HTML/CSS', false),
                    _buildSkillChip('Agile', false),
                  ]),
                ],
              ),
            ),

            const SizedBox(height: 24),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.bookmark_border, color: Colors.white),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    child: const Text('Apply on LinkedIn',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                )
              ],
            ),

            const SizedBox(height: 24),
            const Align(
                alignment: Alignment.centerLeft,
                child: Text("Location",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            const SizedBox(height: 16),
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.circular(20),
                image: const DecorationImage(
                    image: NetworkImage('https://placeholder.com/map'),
                    fit: BoxFit.cover), // Placeholder for map
              ),
              child: const Center(child: Icon(Icons.map, size: 50)),
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
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primaryGreen),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 4),
          Text(value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildSkillChip(String label, bool isMatched) {
    return Chip(
      label: Text(label),
      backgroundColor: isMatched
          ? AppColors.primaryGreen.withOpacity(0.1)
          : Colors.red.withOpacity(0.1),
      labelStyle:
          TextStyle(color: isMatched ? AppColors.primaryGreen : Colors.red),
      avatar: Icon(isMatched ? Icons.check : Icons.close,
          size: 16, color: isMatched ? AppColors.primaryGreen : Colors.red),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }
}
