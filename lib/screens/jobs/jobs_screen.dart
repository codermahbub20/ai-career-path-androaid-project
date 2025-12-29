import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import 'job_detail_screen.dart';

class JobsScreen extends StatelessWidget {
  const JobsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Jobs', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.notifications), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildAiInsightCard(),
            const SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('All Jobs', true),
                  _buildFilterChip('Remote', false),
                  _buildFilterChip('Internship', false),
                  _buildFilterChip('Part-time', false),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildJobCard(
              context,
              title: 'Junior UX Designer',
              company: 'Google • Mountain View, CA',
              match: 94,
              tags: ['Full-time', 'Entry Level', 'On-site'],
              skills: ['Figma', 'Prototyping', 'User Research', '+2'],
              color: Colors.grey.shade800,
              isQuickApply: true,
            ),
            _buildJobCard(
              context,
              title: 'Flutter Developer',
              company: 'Spotify • Remote',
              match: 78,
              tags: ['Contract', 'Mid Level', 'Remote'],
              skills: ['Dart', 'Flutter', 'Mobile'],
              color: Colors.green.shade900,
              isQuickApply: false,
            ),
            _buildJobCard(
              context,
              title: 'Product Design Intern',
              company: 'Airbnb • San Francisco',
              match: 88,
              tags: ['Internship', 'Summer 2024'],
              skills: ['Design Systems', 'UI/UX'],
              color: Colors.red.shade900,
              isQuickApply: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAiInsightCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.auto_awesome, color: AppColors.primaryGreen, size: 16),
              SizedBox(width: 8),
              Text('AI INSIGHT',
                  style: TextStyle(
                      color: AppColors.primaryGreen,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          const Text('3 new high-match jobs added today based on your skills.'),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.grey),
                foregroundColor: Colors.white,
              ),
              child: const Text('DISMISS'),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (bool value) {},
        backgroundColor: AppColors.cardBackground,
        selectedColor: AppColors.primaryGreen,
        labelStyle: TextStyle(color: isSelected ? Colors.black : Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        showCheckmark: false,
      ),
    );
  }

  Widget _buildJobCard(
    BuildContext context, {
    required String title,
    required String company,
    required int match,
    required List<String> tags,
    required List<String> skills,
    required Color color,
    required bool isQuickApply,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const JobDetailScreen()));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(backgroundColor: color, radius: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      Text(company, style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: match > 80
                            ? AppColors.primaryGreen
                            : Colors.orange),
                  ),
                  child: Text('$match% Match',
                      style: TextStyle(
                          color: match > 80
                              ? AppColors.primaryGreen
                              : Colors.orange,
                          fontSize: 12,
                          fontWeight: FontWeight.bold)),
                )
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: tags
                  .map((t) => Chip(
                        label: Text(t, style: const TextStyle(fontSize: 10)),
                        backgroundColor: Colors.white10,
                        padding: EdgeInsets.zero,
                        labelPadding: const EdgeInsets.symmetric(horizontal: 8),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: skills
                  .map((s) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: Text(s,
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey)),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 16),
            if (isQuickApply)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text('Quick Apply'),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, size: 16),
                    ],
                  ),
                ),
              )
            else
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white24),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                  ),
                  child: const Text('View Details'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
