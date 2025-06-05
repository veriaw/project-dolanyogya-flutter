import 'package:flutter/material.dart';
import 'package:project_tpm/models/user.dart';
import 'package:project_tpm/services/user_service.dart';
import 'package:project_tpm/shared/color_palette.dart';
import 'package:project_tpm/utils/user_manager.dart';

class EditProfilePage extends StatefulWidget {
  final User user;
  final void Function(User updatedUser) onProfileUpdated;

  const EditProfilePage({
    Key? key,
    required this.user,
    required this.onProfileUpdated,
  }) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _usernameController;
  String? _gender;
  DateTime? _dateOfBirth;
  final userService = UserService();
  final userManager = UserProfileManager();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.user.username);
    _gender = widget.user.gender;
    _dateOfBirth = widget.user.dateOfBirth;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    setState(() => _isSaving = true);
    // Ambil user lama dari Hive untuk memastikan password tetap valid
    final oldUser = await userService.getUserById(widget.user.id!);
    final updatedUser = User(
      id: widget.user.id,
      username: _usernameController.text,
      password: oldUser?.password ?? widget.user.password, // gunakan password lama yang terenkripsi
      gender: _gender,
      dateOfBirth: _dateOfBirth,
      publicKey: oldUser?.publicKey ?? widget.user.publicKey,
    );
    await userService.updateUser(widget.user.id!, updatedUser);
    // Update juga ke SharedPreferences
    await userManager.saveUserProfile(
      id: updatedUser.id!,
      username: updatedUser.username,
      birthdate: updatedUser.dateOfBirth,
      gender: updatedUser.gender,
    );
    widget.onProfileUpdated(updatedUser);
    setState(() => _isSaving = false);
    Navigator.of(context).pop(updatedUser); // <-- return updated user
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark ? Colors.black : const Color(0xFFF7F7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: Color(0xFF222222),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Color(0xFF222222)),
      ),
      body: Stack(
        children: [
          // ===== Background Decoration =====
          Positioned(
            top: -40,
            left: -60,
            child: Opacity(
              opacity: 0.18,
              child: Image.asset(
                'assets/3.png',
                width: 180,
                height: 180,
              ),
            ),
          ),
          Positioned(
            top: 120,
            right: -40,
            child: Opacity(
              opacity: 0.13,
              child: Image.asset(
                'assets/4.png',
                width: 120,
                height: 120,
              ),
            ),
          ),
          Positioned(
            bottom: 80,
            left: -30,
            child: Opacity(
              opacity: 0.12,
              child: Image.asset(
                'assets/5.png',
                width: 110,
                height: 110,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: -40,
            child: Opacity(
              opacity: 0.13,
              child: Image.asset(
                'assets/6.png',
                width: 120,
                height: 120,
              ),
            ),
          ),
          Positioned(
            top: 320,
            left: 40,
            child: Opacity(
              opacity: 0.10,
              child: Image.asset(
                'assets/7.png',
                width: 90,
                height: 90,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 60,
            child: Opacity(
              opacity: 0.10,
              child: Image.asset(
                'assets/8.png',
                width: 100,
                height: 100,
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 40,
            child: Opacity(
              opacity: 0.10,
              child: Image.asset(
                'assets/9.png',
                width: 90,
                height: 90,
              ),
            ),
          ),
          // ===== Main Content =====
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 18),
                  Container(
                    padding: EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            labelText: "Full Name",
                            prefixIcon: Icon(Icons.person_outline),
                            filled: true,
                            fillColor: Color(0xFFF7F7FA),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Icon(Icons.wc, color: Colors.grey[700]),
                            SizedBox(width: 8),
                            Text("Gender:", style: TextStyle(fontWeight: FontWeight.w600)),
                            SizedBox(width: 16),
                            Radio<String>(
                              value: "Male",
                              groupValue: _gender,
                              onChanged: (val) => setState(() => _gender = val),
                              activeColor: secondaryColor,
                            ),
                            Text("Male"),
                            Radio<String>(
                              value: "Female",
                              groupValue: _gender,
                              onChanged: (val) => setState(() => _gender = val),
                              activeColor: secondaryColor,
                            ),
                            Text("Female"),
                          ],
                        ),
                        SizedBox(height: 16),
                        GestureDetector(
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: _dateOfBirth ?? DateTime(2000),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                            );
                            if (picked != null) setState(() => _dateOfBirth = picked);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                            decoration: BoxDecoration(
                              color: Color(0xFFF7F7FA),
                              border: Border.all(color: secondaryColor, width: 2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _dateOfBirth == null
                                      ? "Select Date of Birth"
                                      : "${_dateOfBirth!.day}/${_dateOfBirth!.month}/${_dateOfBirth!.year}",
                                  style: TextStyle(fontSize: 16),
                                ),
                                Icon(Icons.calendar_today, color: secondaryColor),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isSaving ? null : _saveProfile,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: accentColor,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: _isSaving
                                ? SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                  )
                                : Text("Save", style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
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
