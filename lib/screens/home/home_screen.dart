// screens/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../constants/app_colors.dart';
import '../../services/auth_service.dart';
import '../../models/user_model.dart';
import '../../models/job_model.dart';
import '../../widgets/custom_button.dart';
import '../jobs/job_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserModel? user;
  List<JobModel> jobs = [];
  List<JobModel> recommendedJobs = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
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

      // Fetch User Data
      final userResponse = await http.get(
        Uri.parse('http://localhost:5000/api/users'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (userResponse.statusCode != 200)
        throw Exception('Failed to load user profile');

      final userJson = json.decode(userResponse.body);
      final List<dynamic> usersList = userJson['data'];
      final currentUserJson = usersList
          .firstWhere((u) => u['email'] == userEmail, orElse: () => null);
      if (currentUserJson == null) throw Exception('User not found');

      final currentUser = UserModel.fromJson(currentUserJson);

      // Normalize user skills for matching
      final List<String> userSkills = (currentUser.skills ?? [])
          .map((s) => s.toString().trim().toLowerCase())
          .toList();

      // Fetch Jobs
      final jobsResponse =
          await http.get(Uri.parse('http://localhost:5000/api/jobs'));
      if (jobsResponse.statusCode != 200)
        throw Exception('Failed to load jobs');

      final jobsJson = json.decode(jobsResponse.body);
      final List<dynamic> jobsList = jobsJson['data'] ?? [];

      final List<JobModel> allJobs =
          jobsList.map((j) => JobModel.fromJson(j)).toList();

      // Calculate match percentage for each job
      for (var job in allJobs) {
        int matched = 0;
        for (var reqSkill in job.requiredSkills) {
          if (userSkills.contains(reqSkill.trim().toLowerCase())) {
            matched++;
          }
        }
        job.matchPercentage = job.requiredSkills.isEmpty
            ? 50
            : ((matched / job.requiredSkills.length) * 100).round();
      }

      // Sort by match % descending and take top 3
      allJobs.sort((a, b) => b.matchPercentage.compareTo(a.matchPercentage));
      final topJobs = allJobs.take(3).toList();

      setState(() {
        user = currentUser;
        jobs = allJobs;
        recommendedJobs = topJobs;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = 'Failed to load data. Check your connection.';
        isLoading = false;
      });
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final int skillCount = user?.skills?.length ?? 0;
    final double readinessPercent = recommendedJobs.isEmpty
        ? 0.0
        : recommendedJobs
                .map((j) => j.matchPercentage)
                .reduce((a, b) => a + b) /
            recommendedJobs.length /
            100;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: user?.profilePic != null &&
                      user!.profilePic!.isNotEmpty
                  ? NetworkImage('http://localhost:5000${user!.profilePic!}')
                  : null,
              child: user?.profilePic == null || user!.profilePic!.isEmpty
                  ? const Icon(Icons.person, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Good Morning,',
                    style: TextStyle(fontSize: 14, color: AppColors.textGrey)),
                Text(
                  user?.fullName ?? 'User',
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {},
          ),
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
                        onPressed: loadData,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryGreen),
                        child: const Text('Retry',
                            style: TextStyle(color: Colors.black)),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: loadData,
                  color: AppColors.primaryGreen,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // Career Roadmap Card
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
                              const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Career Roadmap',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white)),
                                  Icon(Icons.auto_awesome,
                                      color: AppColors.primaryGreen),
                                ],
                              ),
                              const SizedBox(height: 8),
                              const Text('AI-driven path to your dream job',
                                  style: TextStyle(color: AppColors.textGrey)),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Current Progress',
                                      style:
                                          TextStyle(color: AppColors.textGrey)),
                                  Text(
                                      '${(readinessPercent * 100).round()}% Ready',
                                      style: const TextStyle(
                                          color: AppColors.primaryGreen,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                              const SizedBox(height: 10),
                              LinearPercentIndicator(
                                padding: EdgeInsets.zero,
                                lineHeight: 10,
                                percent: readinessPercent,
                                backgroundColor: Colors.grey.withOpacity(0.3),
                                progressColor: AppColors.primaryGreen,
                                barRadius: const Radius.circular(5),
                              ),
                              const SizedBox(height: 20),
                              CustomButton(
                                text: 'Generate Roadmap',
                                onPressed: () {},
                                showArrow: true,
                                isPrimary: true,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Stats
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildStatCard(
                                '$skillCount', 'SKILLS', Icons.stars),
                            _buildStatCard('${recommendedJobs.length}',
                                'MATCHES', Icons.work),
                            _buildStatCard(
                                '${jobs.length}', 'JOBS', Icons.menu_book),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Recommended Jobs
                        _buildSectionHeader('Recommended Jobs',
                            onSeeAll: () {}),
                        const SizedBox(height: 16),
                        recommendedJobs.isEmpty
                            ? const Text('No job recommendations yet',
                                style: TextStyle(color: Colors.grey))
                            : SizedBox(
                                height: 220,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: recommendedJobs.length,
                                  itemBuilder: (context, index) {
                                    final job = recommendedJobs[index];
                                    final isHighMatch =
                                        job.matchPercentage >= 70;
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => JobDetailScreen(
                                                job: job,
                                                matchPercentage:
                                                    job.matchPercentage),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        width: 180,
                                        margin:
                                            const EdgeInsets.only(right: 16),
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: AppColors.cardBackground,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CircleAvatar(
                                              radius: 20,
                                              backgroundColor: isHighMatch
                                                  ? Colors.green.shade900
                                                  : Colors.grey.shade800,
                                              child: Text(job.company[0],
                                                  style: const TextStyle(
                                                      color: Colors.white)),
                                            ),
                                            const SizedBox(height: 12),
                                            Text(
                                              job.title,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                                '${job.company} • ${job.location}',
                                                style: const TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 12)),
                                            const SizedBox(height: 12),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 4),
                                              decoration: BoxDecoration(
                                                color: AppColors.background,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                border: Border.all(
                                                    color: isHighMatch
                                                        ? AppColors.primaryGreen
                                                        : Colors.orange),
                                              ),
                                              child: Text(
                                                  '${job.matchPercentage}% Match',
                                                  style: TextStyle(
                                                      color: isHighMatch
                                                          ? AppColors
                                                              .primaryGreen
                                                          : Colors.orange,
                                                      fontSize: 11)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),

                        const SizedBox(height: 24),
                        _buildSectionHeader('Recommended Learning',
                            onSeeAll: () {}),
                        const SizedBox(height: 16),
                        Container(
                          height: 100,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              color: AppColors.cardBackground,
                              borderRadius: BorderRadius.circular(16)),
                          child: const Center(
                              child: Text('Learning resources coming soon...',
                                  style: TextStyle(color: Colors.grey))),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildStatCard(String count, String label, IconData icon) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primaryGreen, size: 28),
          const SizedBox(height: 8),
          Text(count,
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
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
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        TextButton(
            onPressed: onSeeAll,
            child: const Text('View All',
                style: TextStyle(color: AppColors.primaryGreen))),
      ],
    );
  }
}
