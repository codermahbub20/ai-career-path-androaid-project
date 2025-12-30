// models/job_model.dart
class JobModel {
  final String id;
  final String title;
  final String company;
  final String location;
  final List<String> requiredSkills;
  final String experienceLevel;
  final String jobType;
  final String description;
  final String applyLink;
  final String careerTrack;
  final DateTime postedAt;
  int matchPercentage = 0;

  JobModel({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.requiredSkills,
    required this.experienceLevel,
    required this.jobType,
    required this.description,
    required this.applyLink,
    required this.careerTrack,
    required this.postedAt,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? 'Untitled Job',
      company: json['company'] ?? 'Unknown Company',
      location: json['location'] ?? 'Location not specified',
      requiredSkills: List<String>.from(json['requiredSkills'] ?? []),
      experienceLevel: json['experienceLevel'] ?? 'Not specified',
      jobType: json['jobType'] ?? 'Full-time',
      description: json['description'] ?? '',
      applyLink: json['applyLink'] ?? '',
      careerTrack: json['careerTrack'] ?? 'Other',
      postedAt: DateTime.tryParse(json['postedAt'] ?? '') ?? DateTime.now(),
    );
  }
}
