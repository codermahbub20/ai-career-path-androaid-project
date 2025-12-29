import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.settings), onPressed: () {})
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Image
            Stack(
              children: [
                const CircleAvatar(radius: 50, backgroundColor: Colors.grey),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    backgroundColor: AppColors.primaryGreen.withOpacity(0.8),
                    radius: 16,
                    child: const Icon(Icons.camera_alt,
                        size: 16, color: Colors.black),
                  ),
                )
              ],
            ),
            const SizedBox(height: 16),
            const Text("Alex Johnson",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const Text("Aspiring Data Analyst",
                style: TextStyle(color: AppColors.primaryGreen)),

            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                    child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.grey)),
                        child: const Text("EDIT PROFILE"))),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  AppColors.primaryGreen.withOpacity(0.8),
                  Colors.green.shade900
                ]),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Center(
                  child: Text("ANALYZE CV",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold))),
            ),

            const SizedBox(height: 30),
            _buildSectionHeader("PERSONAL INFORMATION"),
            _buildInfoTile(Icons.email, "alex.johnson@example.com"),
            _buildInfoTile(Icons.phone, "+1 (555) 012-3456"),
            _buildInfoTile(Icons.location_on, "San Francisco, CA"),

            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("SKILLS",
                    style: TextStyle(color: Colors.grey, fontSize: 12)),
                Text("Manage",
                    style:
                        TextStyle(color: AppColors.primaryGreen, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildSkillTag("Python"),
                _buildSkillTag("Data Visualization"),
                _buildSkillTag("Flutter"),
                _buildAddSkillTag(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Text(title,
              style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ));
  }

  Widget _buildInfoTile(IconData icon, String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryGreen, size: 20),
          const SizedBox(width: 16),
          Text(text),
          const Spacer(),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildSkillTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white24)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(text),
          const SizedBox(width: 8),
          const Icon(Icons.close, size: 14, color: Colors.grey)
        ],
      ),
    );
  }

  Widget _buildAddSkillTag() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          // FIXED: Changed dashed to solid because standard Flutter doesn't support dashed borders easily
          border: Border.all(
              color: AppColors.primaryGreen, style: BorderStyle.solid)),
      child: const Text("+ Add Skill",
          style: TextStyle(color: AppColors.primaryGreen)),
    );
  }
}
