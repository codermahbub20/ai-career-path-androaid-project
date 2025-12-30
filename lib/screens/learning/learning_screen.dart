// screens/learning/learning_screen.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants/app_colors.dart';

class LearningScreen extends StatelessWidget {
  const LearningScreen({super.key});

  // Sample real courses (you can later fetch from API)
  final List<Map<String, dynamic>> recommendedCourses = const [
    {
      "title": "The Complete 2025 Web Development Bootcamp",
      "platform": "Udemy",
      "price": "\$12.99",
      "duration": "62 hours",
      "rating": 4.7,
      "students": "1.2M",
      "imageColor": Colors.blue,
      "tags": ["HTML", "CSS", "JavaScript", "React", "Node.js"],
      "description":
          "Become a Full-Stack Web Developer with just ONE course. HTML, CSS, JavaScript, Node, React, PostgreSQL, Web3 and DApps.",
      "url":
          "https://www.udemy.com/course/the-complete-web-development-bootcamp/"
    },
    {
      "title": "Python for Everybody Specialization",
      "platform": "Coursera",
      "price": "FREE to audit",
      "duration": "8 months",
      "rating": 4.8,
      "students": "1.5M",
      "imageColor": Colors.yellow,
      "tags": ["Python", "Data Analysis", "Web Scraping"],
      "description":
          "Learn to Program and Analyze Data with Python. Develop programs to gather, clean, analyze, and visualize data.",
      "url": "https://www.coursera.org/specializations/python"
    },
    {
      "title": "Flutter & Dart - The Complete Guide [2025 Edition]",
      "platform": "Udemy",
      "price": "\$14.99",
      "duration": "47 hours",
      "rating": 4.6,
      "students": "380K",
      "imageColor": Colors.cyan,
      "tags": ["Flutter", "Dart", "Mobile App", "iOS", "Android"],
      "description":
          "A Complete Guide to the Flutter SDK & Flutter Framework for building native iOS and Android apps.",
      "url": "https://www.udemy.com/course/flutter-dart-the-complete-guide/"
    },
    {
      "title": "Machine Learning by Andrew Ng",
      "platform": "Coursera",
      "price": "FREE to audit",
      "duration": "11 weeks",
      "rating": 4.9,
      "students": "4.8M",
      "imageColor": Colors.orange,
      "tags": ["Machine Learning", "Python", "Math"],
      "description":
          "The most famous ML course in the world. Learn ML from the pioneer himself.",
      "url": "https://www.coursera.org/learn/machine-learning"
    },
  ];

  void _showCourseDetails(BuildContext context, Map<String, dynamic> course) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Color(0xFF1E1E1E),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: Colors.grey, borderRadius: BorderRadius.circular(2)),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Course Image Placeholder
                    Container(
                      height: 180,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: course['imageColor'],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.school,
                          size: 80, color: Colors.white54),
                    ),
                    const SizedBox(height: 20),

                    Text(course['title'],
                        style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    const SizedBox(height: 8),
                    Text(course['platform'],
                        style: const TextStyle(
                            color: AppColors.primaryGreen,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 20),
                        const SizedBox(width: 4),
                        Text(
                            '${course['rating']} (${course['students']} students)',
                            style: const TextStyle(color: Colors.grey)),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                              color: AppColors.primaryGreen,
                              borderRadius: BorderRadius.circular(20)),
                          child: Text(course['price'],
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    const Text('About this course',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    const SizedBox(height: 8),
                    Text(course['description'],
                        style:
                            const TextStyle(color: Colors.grey, height: 1.6)),

                    const SizedBox(height: 20),
                    const Text('Skills you\'ll gain',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: (course['tags'] as List<String>)
                          .map((tag) => Chip(
                                label: Text(tag,
                                    style: const TextStyle(fontSize: 12)),
                                backgroundColor: Colors.white10,
                              ))
                          .toList(),
                    ),

                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          final url = Uri.parse(course['url']);
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url,
                                mode: LaunchMode.externalApplication);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryGreen,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                        ),
                        child: const Text('OPEN COURSE',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text("Learning Hub",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, color: Colors.white)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search skills, courses, platforms...",
                  hintStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  suffixIcon: const Icon(Icons.tune, color: Colors.grey),
                  filled: true,
                  fillColor: AppColors.cardBackground,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none),
                ),
              ),
            ),

            // Categories
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildCategoryChip("All", true),
                  _buildCategoryChip("Free", false),
                  _buildCategoryChip("Paid", false),
                  _buildCategoryChip("Video", false),
                  _buildCategoryChip("Beginner", false),
                ],
              ),
            ),

            const SizedBox(height: 24),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Recommended for You",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  Text("See All",
                      style: TextStyle(color: AppColors.primaryGreen)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Recommended Courses
            ...recommendedCourses
                .map((course) => Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: GestureDetector(
                        onTap: () => _showCourseDetails(context, course),
                        child: _buildLargeCourseCard(
                          title: course['title'],
                          platform: course['platform'],
                          price: course['price'],
                          duration: course['duration'],
                          rating: course['rating'],
                          imageColor: course['imageColor'],
                          tags: course['tags'],
                        ),
                      ),
                    ))
                .toList(),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      child: Chip(
        label: Text(label),
        backgroundColor:
            isSelected ? AppColors.primaryGreen : AppColors.cardBackground,
        labelStyle: TextStyle(color: isSelected ? Colors.black : Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: BorderSide.none,
      ),
    );
  }

  Widget _buildLargeCourseCard({
    required String title,
    required String platform,
    required String price,
    required String duration,
    required double rating,
    required Color imageColor,
    required List<String> tags,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 140,
            decoration: BoxDecoration(
              color: imageColor.withOpacity(0.8),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Stack(
              children: [
                const Center(
                    child: Icon(Icons.play_circle_outline,
                        size: 60, color: Colors.white54)),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(8)),
                    child: Text(price,
                        style: const TextStyle(
                            color: AppColors.primaryGreen,
                            fontWeight: FontWeight.bold,
                            fontSize: 11)),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(platform,
                    style: const TextStyle(
                        color: AppColors.primaryGreen, fontSize: 12)),
                const SizedBox(height: 4),
                Text(title,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text('$rating',
                        style: const TextStyle(color: Colors.amber)),
                    const SizedBox(width: 12),
                    const Icon(Icons.access_time, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(duration, style: const TextStyle(color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: tags
                      .take(3)
                      .map((tag) => Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                                color: Colors.white10,
                                borderRadius: BorderRadius.circular(12)),
                            child: Text(tag,
                                style: const TextStyle(
                                    fontSize: 11, color: Colors.white70)),
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
