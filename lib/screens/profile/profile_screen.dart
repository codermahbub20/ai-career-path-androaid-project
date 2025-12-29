import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

      if (token == null || email == null) {
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

  void _openEditProfile() {
    if (_userData == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => EditProfileModal(
        user: _userData!,
        onUpdated: (updatedUser) {
          setState(() {
            _userData = updatedUser;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully!')),
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
              Navigator.pushNamedAndRemoveUntil(
                  context, '/login', (_) => false);
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primaryGreen))
          : _error != null
              ? Center(
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
                          onPressed: _loadUserData, child: const Text('Retry')),
                    ],
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
                        // Avatar
                        CircleAvatar(
                          radius: 60,
                          backgroundColor:
                              AppColors.primaryGreen.withOpacity(0.2),
                          backgroundImage: _userData!.profilePic != null
                              ? NetworkImage(
                                  'http://localhost:5000${_userData!.profilePic!}')
                              : null,
                          child: _userData!.profilePic == null
                              ? Text(
                                  _userData!.fullName[0].toUpperCase(),
                                  style: const TextStyle(
                                      fontSize: 48,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                )
                              : null,
                        ),
                        const SizedBox(height: 16),
                        Text(_userData!.fullName,
                            style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        const SizedBox(height: 4),
                        Text((_userData!.role ?? 'user').toUpperCase(),
                            style: const TextStyle(
                                color: AppColors.primaryGreen, fontSize: 14)),
                        const SizedBox(height: 30),

                        // Edit Profile Button
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: _openEditProfile,
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              side: const BorderSide(color: Colors.white54),
                            ),
                            child: const Text("EDIT PROFILE",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(height: 30),

                        _buildSectionHeader("PERSONAL INFORMATION"),
                        _buildInfoTile(Icons.email, "Email", _userData!.email),
                        if ((_userData!.educationLevel ?? '').isNotEmpty)
                          _buildInfoTile(Icons.school, "Education",
                              _userData!.educationLevel ?? ''),
                        if (_userData!.department!.isNotEmpty)
                          _buildInfoTile(Icons.business, "Department",
                              _userData!.department),
                        if (_userData!.experienceLevel!.isNotEmpty)
                          _buildInfoTile(Icons.work, "Experience Level",
                              _userData!.experienceLevel),
                        if (_userData!.preferredCareerTrack!.isNotEmpty)
                          _buildInfoTile(Icons.trending_up, "Career Track",
                              _userData!.preferredCareerTrack),

                        const SizedBox(height: 24),
                        _buildSectionHeader("SKILLS"),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            ...(_userData!.skills ?? []).map((skill) => Chip(
                                  label: Text(skill),
                                  backgroundColor: Colors.white10,
                                  labelStyle:
                                      const TextStyle(color: Colors.white),
                                )),
                            if (_userData!.skills == null ||
                                _userData!.skills!.isEmpty)
                              const Chip(
                                  label: Text("No skills added"),
                                  backgroundColor: Colors.grey),
                          ],
                        ),
                        const SizedBox(height: 40),
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
              color: Colors.grey, fontSize: 12, letterSpacing: 1.2)),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryGreen, size: 24),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(color: Colors.grey[400], fontSize: 12)),
              const SizedBox(height: 4),
              Text(value,
                  style: const TextStyle(color: Colors.white, fontSize: 16)),
            ],
          ),
        ],
      ),
    );
  }
}

// ===================== EDIT PROFILE MODAL =====================

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
    _eduCtrl = TextEditingController(text: widget.user.educationLevel);
    _deptCtrl = TextEditingController(text: widget.user.department);
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
    if (_eduCtrl.text.trim() != widget.user.educationLevel)
      updates['educationLevel'] = _eduCtrl.text.trim();
    if (_deptCtrl.text.trim() != widget.user.department)
      updates['department'] = _deptCtrl.text.trim();
    if (_expLevel != widget.user.experienceLevel)
      updates['experienceLevel'] = _expLevel;
    if (_careerTrack != widget.user.preferredCareerTrack)
      updates['preferredCareerTrack'] = _careerTrack;
    if (_expDescCtrl.text.trim() != (widget.user.experienceDescription ?? ''))
      updates['experienceDescription'] = _expDescCtrl.text.trim();
    if (_skills != widget.user.skills) updates['skills'] = _skills;

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
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to update: $e')));
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
          // Header
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

          // Form
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
                    decoration: const InputDecoration(
                        labelText: "Experience Level",
                        filled: true,
                        fillColor: Colors.grey),
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
                        labelText: "Preferred Career Track",
                        filled: true,
                        fillColor: Colors.grey),
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
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 24),

                  // Skills Input
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _skillInputCtrl,
                          decoration: const InputDecoration(
                              hintText: "Type a skill",
                              hintStyle: TextStyle(color: Colors.grey)),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle,
                            color: AppColors.primaryGreen),
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
                              onDeleted: () =>
                                  setState(() => _skills.remove(skill)),
                              backgroundColor:
                                  AppColors.primaryGreen.withOpacity(0.3),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 40),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saveChanges,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text("SAVE CHANGES",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
