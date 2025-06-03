import 'dart:io';
import 'package:flutter/material.dart';
import 'package:project_tpm/utils/handle_profile_image.dart';

class UserProfileScreen extends StatefulWidget {
  final int id;
  final String username;
  final String? gender;
  final DateTime? dateOfBirth;
  final VoidCallback onLogout;

  const UserProfileScreen({
    Key? key,
    required this.id,
    required this.username,
    required this.gender,
    required this.dateOfBirth,
    required this.onLogout,
  }) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    final image = await ProfileImageHelper.loadProfileImage(widget.id);
    if (mounted) {
      setState(() {
        _profileImage = image;
      });
    }
  }

  Future<void> _changeProfileImage() async {
    final image = await ProfileImageHelper.pickAndSaveProfileImage(widget.id);
    if (image != null && mounted) {
      setState(() {
        _profileImage = image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileImageWidget = _profileImage != null
        ? CircleAvatar(
            radius: 48,
            backgroundImage: FileImage(_profileImage!),
          )
        : CircleAvatar(
            radius: 48,
            child: Icon(Icons.person, size: 56),
          );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => UserSettingsScreen(
            //       username: widget.username,
            //       gender: widget.gender,
            //       dateOfBirth: widget.dateOfBirth,
            //     ),
            //   ),
            // );
          },
        ),
        title: Text('Profil Pengguna'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            tooltip: "Logout",
            onPressed: widget.onLogout,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(height: 16),
            GestureDetector(
              onTap: _changeProfileImage,
              child: profileImageWidget,
            ),
            SizedBox(height: 16),
            Text(
              widget.username,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              widget.gender ?? "-",
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            SizedBox(height: 4),
            Text(
              widget.dateOfBirth != null
                  ? "${widget.dateOfBirth!.day}/${widget.dateOfBirth!.month}/${widget.dateOfBirth!.year}"
                  : "-",
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            SizedBox(height: 24),
            Divider(),
            SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Bantuan",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            SizedBox(height: 8),
            ElevatedButton.icon(
              icon: Icon(Icons.help_outline),
              label: Text('Bantuan'),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: Icon(Icons.support_agent),
                          title: Text('Pusat Bantuan'),
                          onTap: () {},
                        ),
                        ListTile(
                          leading: Icon(Icons.phone),
                          title: Text('Hubungi Kami'),
                          onTap: () {},
                        ),
                        ListTile(
                          leading: Icon(Icons.privacy_tip),
                          title: Text('Ketentuan & Kebijakan Privasi'),
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
