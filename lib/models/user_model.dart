class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String? educationLevel;
  final String? department;
  final String? experienceLevel;
  final String? preferredCareerTrack;
  final String? profilePic;
  final List<String>? skills;
  final String? role;
  final bool isBlocked;
  final String? careerInterests;
  final String? cvText;
  final String? experienceDescription;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    this.educationLevel,
    this.department,
    this.experienceLevel,
    this.preferredCareerTrack,
    this.profilePic,
    this.skills,
    this.role,
    this.isBlocked = false,
    this.careerInterests,
    this.cvText,
    this.experienceDescription,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: _safeString(json['_id']) ?? _safeString(json['id']) ?? 'unknown',
      fullName: _safeString(json['fullName']) ??
          _safeString(json['name']) ??
          'Unknown User',
      email: _safeString(json['email']) ?? '',
      educationLevel: _safeString(json['educationLevel']),
      department: _safeString(json['department']),
      experienceLevel: _safeString(json['experienceLevel']),
      preferredCareerTrack: _safeString(json['preferredCareerTrack']),
      profilePic: _safeString(json['profilePic']),
      skills: _parseSkills(json['skills']),
      role: _safeString(json['role']) ?? 'user',
      isBlocked: json['isBlocked'] is bool ? json['isBlocked'] : false,
      careerInterests: _safeString(json['careerInterests']),
      cvText: _safeString(json['cvText']),
      experienceDescription: _safeString(json['experienceDescription']),
      createdAt: _parseDate(json['createdAt']),
      updatedAt: _parseDate(json['updatedAt']),
    );
  }

  static String? _safeString(dynamic value) {
    if (value == null) return null;
    final str = value.toString().trim();
    return str.isEmpty ? null : str;
  }

  static List<String>? _parseSkills(dynamic skillsData) {
    if (skillsData == null) return null;

    if (skillsData is List) {
      return skillsData
          .map((e) => e?.toString().trim())
          .where((s) => s != null && s.isNotEmpty)
          .cast<String>()
          .toList();
    }

    if (skillsData is String) {
      final trimmed = skillsData.trim();
      if (trimmed.isEmpty) return null;
      return [trimmed];
    }

    return null;
  }

  static DateTime? _parseDate(dynamic dateData) {
    if (dateData == null) return null;
    if (dateData is String) return DateTime.tryParse(dateData);
    if (dateData is Map && dateData.containsKey('\$date')) {
      return DateTime.tryParse(dateData['\$date'].toString());
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'fullName': fullName,
      'email': email,
      'educationLevel': educationLevel,
      'department': department,
      'experienceLevel': experienceLevel,
      'preferredCareerTrack': preferredCareerTrack,
      'profilePic': profilePic,
      'skills': skills,
      'role': role,
      'isBlocked': isBlocked,
    };
  }
}
