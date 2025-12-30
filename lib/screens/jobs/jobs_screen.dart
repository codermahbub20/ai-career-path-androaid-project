// screens/jobs/jobs_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../constants/app_colors.dart';
import '../../services/auth_service.dart';
import '../../models/user_model.dart';
import '../../models/job_model.dart';
import 'job_detail_screen.dart';

class JobsScreen extends StatefulWidget {
  const JobsScreen({super.key});

  @override
  State<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen> {
  List<JobModel> jobs = [];
  List<String> userSkills = []; // User's skills from profile
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    loadUserAndJobs();
  }

  Future<void> loadUserAndJobs() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final auth = Provider.of<AuthService>(context, listen: false);
      final token = auth.token;
      final userEmail = auth.userData?['email'];

      if (token == null || userEmail == null) {
        throw Exception('Please login again');
      }

      // Step 1: Fetch user data to get skills
      final userResponse = await http.get(
        Uri.parse('http://localhost:5000/api/users'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (userResponse.statusCode != 200)
        throw Exception('Failed to load user');

      final userJson = json.decode(userResponse.body);
      final List<dynamic> usersList = userJson['data'] ?? [];

      final currentUserJson = usersList.firstWhere(
        (u) => u['email'] == userEmail,
        orElse: () => throw Exception('User not found'),
      );

      final userSkillsList = List<String>.from(currentUserJson['skills'] ?? []);
      userSkills =
          userSkillsList.map((s) => s.toString().trim().toLowerCase()).toList();

      // Step 2: Fetch jobs
      final jobsResponse = await http.get(
        Uri.parse('http://localhost:5000/api/jobs'),
        headers: token != null ? {'Authorization': 'Bearer $token'} : {},
      );

      if (jobsResponse.statusCode != 200)
        throw Exception('Failed to load jobs');

      final jobsJson = json.decode(jobsResponse.body);
      final List<dynamic> jobsList = jobsJson['data'] ?? [];

      setState(() {
        jobs = jobsList.map((j) => JobModel.fromJson(j)).toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = 'Failed to load data. Please try again.';
        isLoading = false;
      });
      print('Error: $e');
    }
  }

  // Accurate skill matching percentage
  int calculateMatchPercentage(List<String> requiredSkills) {
    if (requiredSkills.isEmpty) return 50;
    if (userSkills.isEmpty) return 30;

    int matched = 0;
    for (var skill in requiredSkills) {
      if (userSkills.contains(skill.trim().toLowerCase())) {
        matched++;
      }
    }

    return ((matched / requiredSkills.length) * 100).round();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('Jobs',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        actions: [
          IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () {}),
          IconButton(
              icon:
                  const Icon(Icons.notifications_outlined, color: Colors.white),
              onPressed: () {}),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primaryGreen))
          : error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline,
                          size: 80, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(error!,
                          style: const TextStyle(color: Colors.white),
                          textAlign: TextAlign.center),
                      const SizedBox(height: 20),
                      ElevatedButton(
                          onPressed: loadUserAndJobs,
                          child: const Text('Retry')),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: loadUserAndJobs,
                  color: AppColors.primaryGreen,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // AI Insight
                        Container(
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
                                  Icon(Icons.auto_awesome,
                                      color: AppColors.primaryGreen, size: 16),
                                  SizedBox(width: 8),
                                  Text('AI INSIGHT',
                                      style: TextStyle(
                                          color: AppColors.primaryGreen,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                  '${jobs.length} jobs found • ${userSkills.length} skills matched'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Filters
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _buildFilterChip('All Jobs', true),
                              _buildFilterChip('Remote', false),
                              _buildFilterChip('Internship', false),
                              _buildFilterChip('Full-time', false),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Jobs List
                        jobs.isEmpty
                            ? const Center(
                                child: Text('No jobs available',
                                    style: TextStyle(color: Colors.grey)))
                            : Column(
                                children: jobs.map((job) {
                                  final match = calculateMatchPercentage(
                                      job.requiredSkills);
                                  final isHighMatch = match >= 70;

                                  return _buildJobCard(
                                    context,
                                    job: job,
                                    match: match,
                                    isHighMatch: isHighMatch,
                                  );
                                }).toList(),
                              ),
                        const SizedBox(height: 50),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (v) {},
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
    required JobModel job,
    required int match,
    required bool isHighMatch,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                JobDetailScreen(job: job, matchPercentage: match),
          ),
        );
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
                CircleAvatar(
                  radius: 24,
                  backgroundColor: isHighMatch
                      ? Colors.green.shade900
                      : Colors.grey.shade800,
                  child: Text(job.company[0],
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(job.title,
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      Text('${job.company} • ${job.location}',
                          style: const TextStyle(color: Colors.grey)),
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
                        color: isHighMatch
                            ? AppColors.primaryGreen
                            : Colors.orange),
                  ),
                  child: Text(
                    '$match% Match',
                    style: TextStyle(
                      color:
                          isHighMatch ? AppColors.primaryGreen : Colors.orange,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: [
                Chip(
                    label: Text(job.jobType),
                    backgroundColor: Colors.white10,
                    labelStyle: const TextStyle(fontSize: 11)),
                Chip(
                    label: Text(job.experienceLevel),
                    backgroundColor: Colors.white10,
                    labelStyle: const TextStyle(fontSize: 11)),
                if (job.location.toLowerCase() == 'remote')
                  const Chip(
                      label: Text('Remote'),
                      backgroundColor: Colors.white10,
                      labelStyle: TextStyle(fontSize: 11)),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: job.requiredSkills
                  .take(4)
                  .map((skill) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white24),
                            borderRadius: BorderRadius.circular(20)),
                        child: Text(skill,
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey)),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: isHighMatch
                  ? ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryGreen,
                          foregroundColor: Colors.black),
                      child: const Text('Quick Apply →'),
                    )
                  : OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.white24)),
                      child: const Text('View Details'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
