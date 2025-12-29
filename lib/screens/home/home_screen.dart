import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../../constants/app_colors.dart';
import '../../widgets/custom_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const CircleAvatar(
              // Replace with actual user image asset
              backgroundColor: Colors.grey,
              child: Icon(Icons.person),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Good Morning,',
                    style: TextStyle(fontSize: 14, color: AppColors.textGrey)),
                Text('Sarah Jenkins',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildCareerRoadmapCard(),
            const SizedBox(height: 24),
            _buildStatsRow(),
            const SizedBox(height: 24),
            _buildSectionHeader('Recommended Jobs', onSeeAll: () {}),
            const SizedBox(height: 16),
            _buildRecommendedJobsList(),
            const SizedBox(height: 24),
            _buildSectionHeader('Recommended Learning', onSeeAll: () {}),
            const SizedBox(height: 16),
            _buildRecommendedLearningList(),
          ],
        ),
      ),
    );
  }

  Widget _buildCareerRoadmapCard() {
    return Container(
      padding: const EdgeInsets.all(20),
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
              const Text('Career Roadmap',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Icon(Icons.auto_awesome, color: AppColors.primaryGreen),
            ],
          ),
          const SizedBox(height: 8),
          const Text('AI-driven path to your dream job',
              style: TextStyle(color: AppColors.textGrey)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Current Progress',
                  style: TextStyle(color: AppColors.textGrey)),
              Text('65% Ready',
                  style: TextStyle(color: AppColors.primaryGreen)),
            ],
          ),
          const SizedBox(height: 10),
          LinearPercentIndicator(
            padding: EdgeInsets.zero,
            lineHeight: 8.0,
            percent: 0.65,
            backgroundColor: AppColors.background,
            progressColor: AppColors.primaryGreen,
            barRadius: const Radius.circular(4),
          ),
          const SizedBox(height: 20),
          CustomButton(
            text: 'Generate Roadmap',
            onPressed: () {},
            // Add an icon to the button if needed
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildStatCard('12', 'SKILLS', Icons.stars),
        _buildStatCard('24', 'MATCHES', Icons.work),
        _buildStatCard('5', 'RESOURCES', Icons.menu_book),
      ],
    );
  }

  Widget _buildStatCard(String count, String label, IconData icon) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primaryGreen),
          const SizedBox(height: 8),
          Text(count,
              style:
                  const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(label,
              style: const TextStyle(fontSize: 12, color: AppColors.textGrey)),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, {required VoidCallback onSeeAll}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        TextButton(
          onPressed: onSeeAll,
          child: const Text('View All',
              style: TextStyle(color: AppColors.primaryGreen)),
        ),
      ],
    );
  }

  Widget _buildRecommendedJobsList() {
    // This would ideally be a ListView.builder with dynamic data
    return SizedBox(
      height: 180,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: const [
          // Placeholder job cards
          SizedBox(
              width: 160, child: Placeholder(color: AppColors.cardBackground)),
          SizedBox(width: 16),
          SizedBox(
              width: 160, child: Placeholder(color: AppColors.cardBackground)),
        ],
      ),
    );
  }

  Widget _buildRecommendedLearningList() {
    // This would ideally be a ListView.builder with dynamic data
    return Column(
      children: [
        // Placeholder learning cards
        Container(
            height: 80,
            color: AppColors.cardBackground,
            margin: const EdgeInsets.only(bottom: 12)),
        Container(height: 80, color: AppColors.cardBackground),
      ],
    );
  }
}
