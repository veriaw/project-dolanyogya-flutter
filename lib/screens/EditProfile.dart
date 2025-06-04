import 'package:flutter/material.dart';
import 'package:project_tpm/models/user.dart';
import 'package:project_tpm/services/user_service.dart';
import 'package:project_tpm/shared/color_palette.dart';

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
    final updatedUser = User(
      id: widget.user.id,
      username: _usernameController.text,
      password: widget.user.password,
      gender: _gender,
      dateOfBirth: _dateOfBirth,
      publicKey: widget.user.publicKey,
    );
    await userService.updateUser(widget.user.id!, updatedUser);
    widget.onProfileUpdated(updatedUser);
    setState(() => _isSaving = false);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: "Full Name",
                prefixIcon: Icon(Icons.person_outline),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Text("Gender:"),
                SizedBox(width: 16),
                Radio<String>(
                  value: "Male",
                  groupValue: _gender,
                  onChanged: (val) => setState(() => _gender = val),
                ),
                Text("Male"),
                Radio<String>(
                  value: "Female",
                  groupValue: _gender,
                  onChanged: (val) => setState(() => _gender = val),
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
                  color: Colors.grey[100],
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
                    Icon(Icons.calendar_today),
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
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text("Save", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
