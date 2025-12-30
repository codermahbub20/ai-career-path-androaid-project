import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../../constants/app_colors.dart';
import '../../services/auth_service.dart';
import '../../services/user_service.dart';
import '../../models/user_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel? _userData;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final String? token = authService.token;
      final String? email = authService.userData?['email'];

      if (token == null || email == null || email.isEmpty) {
        throw Exception('Please login again');
      }

      final userService = UserService();
      final userData = await userService.getUserData(token, userEmail: email);

      if (mounted) {
        setState(() {
          _userData = userData;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString().replaceAll('Exception: ', '');
          _isLoading = false;
        });
      }
    }
  }

  // PROFILE PICTURE UPLOAD
  Future<void> _pickAndUploadImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 1024,
      maxHeight: 1024,
    );

    if (pickedFile == null) return;

    final auth = Provider.of<AuthService>(context, listen: false);
    final token = auth.token;
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Authentication required')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      var request = http.MultipartRequest(
        'PATCH',
        Uri.parse('http://localhost:5000/api/users/${_userData!.id}'),
      );

      request.headers['Authorization'] = 'Bearer $token';

      request.files.add(await http.MultipartFile.fromPath(
        'profilePic', // Must match backend exactly
        pickedFile.path,
        filename: pickedFile.name,
      ));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print('Upload Status: ${response.statusCode}');
      print('Upload Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final userJson =
            jsonResponse['data'] ?? jsonResponse['user'] ?? jsonResponse;

        final updatedUser =
            UserModel.fromJson(userJson as Map<String, dynamic>);

        setState(() {
          _userData = updatedUser;
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile picture updated successfully!'),
            backgroundColor: AppColors.primaryGreen,
          ),
        );
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Upload failed: $e'), backgroundColor: Colors.red),
      );
    }
  }

  void _openEditProfile() {
    if (_userData == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => EditProfileModal(
        user: _userData!,
        onUpdated: (updatedUser) {
          setState(() => _userData = updatedUser);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile updated successfully!'),
              backgroundColor: AppColors.primaryGreen,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text("Profile"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await Provider.of<AuthService>(context, listen: false).logout();
              if (mounted) {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/login', (_) => false);
              }
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primaryGreen))
          : _error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline,
                            size: 80, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(_error!,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 16),
                            textAlign: TextAlign.center),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _loadUserData,
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryGreen),
                          child: const Text('Retry',
                              style: TextStyle(color: Colors.black)),
                        ),
                      ],
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadUserData,
                  color: AppColors.primaryGreen,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // Profile Picture with Upload
                        GestureDetector(
                          onTap: _pickAndUploadImage,
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              CircleAvatar(
                                radius: 70,
                                backgroundColor:
                                    AppColors.primaryGreen.withOpacity(0.2),
                                backgroundImage: _userData!.profilePic !=
                                            null &&
                                        _userData!.profilePic!.isNotEmpty
                                    ? NetworkImage(
                                        'http://localhost:5000${_userData!.profilePic!}')
                                    : null,
                                child: _userData!.profilePic == null ||
                                        _userData!.profilePic!.isEmpty
                                    ? Text(
                                        _userData!.fullName.isNotEmpty
                                            ? _userData!.fullName[0]
                                                .toUpperCase()
                                            : 'U',
                                        style: const TextStyle(
                                            fontSize: 60,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      )
                                    : null,
                              ),
                              CircleAvatar(
                                radius: 24,
                                backgroundColor: AppColors.primaryGreen,
                                child: const Icon(Icons.camera_alt,
                                    color: Colors.black, size: 28),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text("Tap to change photo",
                            style: TextStyle(color: Colors.grey, fontSize: 13)),
                        const SizedBox(height: 20),

                        Text(_userData!.fullName,
                            style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        const SizedBox(height: 8),
                        Text((_userData!.role ?? 'user').toUpperCase(),
                            style: const TextStyle(
                                color: AppColors.primaryGreen,
                                fontSize: 14,
                                letterSpacing: 1.5)),
                        const SizedBox(height: 30),

                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: _openEditProfile,
                            style: OutlinedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                side: const BorderSide(color: Colors.white54)),
                            child: const Text('EDIT PROFILE',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                          ),
                        ),
                        const SizedBox(height: 30),

                        _buildSectionHeader("PERSONAL INFORMATION"),
                        const SizedBox(height: 12),
                        _buildInfoTile(Icons.email, "Email", _userData!.email),
                        if ((_userData!.educationLevel ?? '').isNotEmpty)
                          _buildInfoTile(Icons.school, "Education",
                              _userData!.educationLevel ?? ''),
                        if ((_userData!.department ?? '').isNotEmpty)
                          _buildInfoTile(Icons.business, "Department",
                              _userData!.department ?? ''),
                        if ((_userData!.experienceLevel ?? '').isNotEmpty)
                          _buildInfoTile(Icons.work, "Experience Level",
                              _userData!.experienceLevel ?? ''),
                        if ((_userData!.preferredCareerTrack ?? '').isNotEmpty)
                          _buildInfoTile(Icons.trending_up, "Career Track",
                              _userData!.preferredCareerTrack ?? ''),

                        const SizedBox(height: 30),
                        _buildSectionHeader("SKILLS"),
                        const SizedBox(height: 12),
                        _userData!.skills == null || _userData!.skills!.isEmpty
                            ? const Text('No skills added yet',
                                style: TextStyle(color: Colors.grey))
                            : Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: _userData!.skills!
                                    .map((skill) => Chip(
                                          label: Text(skill,
                                              style: const TextStyle(
                                                  color: Colors.white)),
                                          backgroundColor: Colors.white10,
                                        ))
                                    .toList(),
                              ),
                        const SizedBox(height: 50),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Align(
        alignment: Alignment.centerLeft,
        child: Text(title,
            style: const TextStyle(
                color: Colors.grey, fontSize: 12, letterSpacing: 1.2)));
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryGreen, size: 26),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(color: Colors.grey, fontSize: 13)),
                const SizedBox(height: 4),
                Text(value,
                    style: const TextStyle(color: Colors.white, fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ===================== EDIT PROFILE MODAL (UNCHANGED) =====================
class EditProfileModal extends StatefulWidget {
  final UserModel user;
  final Function(UserModel) onUpdated;

  const EditProfileModal(
      {required this.user, required this.onUpdated, super.key});

  @override
  State<EditProfileModal> createState() => _EditProfileModalState();
}

class _EditProfileModalState extends State<EditProfileModal> {
  late TextEditingController _nameCtrl;
  late TextEditingController _eduCtrl;
  late TextEditingController _deptCtrl;
  late TextEditingController _expDescCtrl;
  late TextEditingController _skillInputCtrl;

  String? _expLevel;
  String? _careerTrack;
  List<String> _skills = [];

  final List<String> expLevels = [
    "Fresher",
    "Junior (0-2 years)",
    "Mid-Level (2-5 years)",
    "Senior (5+ years)"
  ];
  final List<String> careerTracks = [
    "Web Development",
    "Mobile Development",
    "Data Science & Analytics",
    "UI/UX Design",
    "Graphic Design",
    "Digital Marketing",
    "Content Creation",
    "Business Development",
    "Project Management",
    "HR & Recruitment",
    "Finance & Accounting",
    "Customer Support",
    "Sales",
    "Other",
  ];

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.user.fullName);
    _eduCtrl = TextEditingController(text: widget.user.educationLevel ?? '');
    _deptCtrl = TextEditingController(text: widget.user.department ?? '');
    _expDescCtrl =
        TextEditingController(text: widget.user.experienceDescription ?? '');
    _expLevel = widget.user.experienceLevel;
    _careerTrack = widget.user.preferredCareerTrack;
    _skills = List.from(widget.user.skills ?? []);
    _skillInputCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _eduCtrl.dispose();
    _deptCtrl.dispose();
    _expDescCtrl.dispose();
    _skillInputCtrl.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    final auth = Provider.of<AuthService>(context, listen: false);
    final token = auth.token;
    if (token == null) return;

    final updates = <String, dynamic>{};

    if (_nameCtrl.text.trim() != widget.user.fullName)
      updates['fullName'] = _nameCtrl.text.trim();
    if (_eduCtrl.text.trim() != (widget.user.educationLevel ?? ''))
      updates['educationLevel'] = _eduCtrl.text.trim();
    if (_deptCtrl.text.trim() != (widget.user.department ?? ''))
      updates['department'] = _deptCtrl.text.trim();
    if (_expLevel != widget.user.experienceLevel)
      updates['experienceLevel'] = _expLevel;
    if (_careerTrack != widget.user.preferredCareerTrack)
      updates['preferredCareerTrack'] = _careerTrack;
    if (_expDescCtrl.text.trim() != (widget.user.experienceDescription ?? ''))
      updates['experienceDescription'] = _expDescCtrl.text.trim();

    final originalSkills = widget.user.skills ?? [];
    if (!const DeepCollectionEquality().equals(_skills, originalSkills)) {
      updates['skills'] = _skills;
    }

    if (updates.isEmpty) {
      Navigator.pop(context);
      return;
    }

    try {
      final service = UserService();
      final updatedUser = await service.updateUserProfile(
        token: token,
        userId: widget.user.id,
        updates: updates,
      );

      widget.onUpdated(updatedUser);
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Update failed: $e'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.92,
      decoration: const BoxDecoration(
        color: Color(0xFF1E1E1E),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Edit Profile",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context)),
              ],
            ),
          ),
          const Divider(color: Colors.grey),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                      controller: _nameCtrl,
                      decoration: const InputDecoration(labelText: "Full Name"),
                      style: const TextStyle(color: Colors.white)),
                  const SizedBox(height: 16),
                  TextField(
                      controller: _eduCtrl,
                      decoration:
                          const InputDecoration(labelText: "Education Level"),
                      style: const TextStyle(color: Colors.white)),
                  const SizedBox(height: 16),
                  TextField(
                      controller: _deptCtrl,
                      decoration:
                          const InputDecoration(labelText: "Department"),
                      style: const TextStyle(color: Colors.white)),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _expLevel,
                    decoration:
                        const InputDecoration(labelText: "Experience Level"),
                    dropdownColor: Colors.grey[800],
                    style: const TextStyle(color: Colors.white),
                    items: expLevels
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (v) => setState(() => _expLevel = v),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _careerTrack,
                    decoration: const InputDecoration(
                        labelText: "Preferred Career Track"),
                    dropdownColor: Colors.grey[800],
                    style: const TextStyle(color: Colors.white),
                    items: careerTracks
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (v) => setState(() => _careerTrack = v),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                      controller: _expDescCtrl,
                      maxLines: 4,
                      decoration: const InputDecoration(
                          labelText: "Experience Description"),
                      style: const TextStyle(color: Colors.white)),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _skillInputCtrl,
                          decoration: const InputDecoration(
                              hintText: "Add a skill",
                              hintStyle: TextStyle(color: Colors.grey)),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle,
                            color: AppColors.primaryGreen, size: 40),
                        onPressed: () {
                          final skill = _skillInputCtrl.text.trim();
                          if (skill.isNotEmpty && !_skills.contains(skill)) {
                            setState(() {
                              _skills.add(skill);
                              _skillInputCtrl.clear();
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _skills
                        .map((skill) => Chip(
                              label: Text(skill),
                              backgroundColor:
                                  AppColors.primaryGreen.withOpacity(0.3),
                              onDeleted: () =>
                                  setState(() => _skills.remove(skill)),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saveChanges,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryGreen,
                          padding: const EdgeInsets.symmetric(vertical: 18)),
                      child: const Text("SAVE CHANGES",
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
    );
  }
}
