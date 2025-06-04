import 'dart:io';
import 'package:flutter/material.dart';
import 'package:project_tpm/shared/color_palette.dart';
import 'package:project_tpm/utils/handle_profile_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:project_tpm/main.dart';
import 'package:project_tpm/screens/Login.dart';

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
    // Ambil foto dari kamera, bukan galeri
    final image = await ProfileImageHelper.pickAndSaveProfileImageFromCamera(widget.id);
    if (image != null && mounted) {
      setState(() {
        _profileImage = image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileImageWidget = Stack(
      alignment: Alignment.bottomRight,
      children: [
        CircleAvatar(
          radius: 48,
          backgroundImage:
              _profileImage != null ? FileImage(_profileImage!) : null,
          child: _profileImage == null ? Icon(Icons.person, size: 56) : null,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: _changeProfileImage,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade300, width: 1),
              ),
              padding: EdgeInsets.all(4),
              child: Icon(Icons.add_a_photo, size: 20, color: Colors.blue),
            ),
          ),
        ),
      ],
    );

    return Stack(
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
        Scaffold(
          backgroundColor: Theme.of(context).brightness == Brightness.dark ? Colors.black : const Color(0xFFF7F7FA),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text(
              'My Profile',
              style: TextStyle(
                color: Color(0xFF222222),
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: Icon(Icons.settings, color: Colors.blueAccent),
                tooltip: "Edit Profile",
                onPressed: () {
                  // TODO: Navigasi ke halaman edit profile atau tampilkan dialog edit data diri
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Fitur edit profile coming soon!')),
                  );
                },
              ),
            ],
            iconTheme: IconThemeData(color: Color(0xFF222222)),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Center(child: profileImageWidget),
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
                      children: [
                        _ProfileTextField(
                          label: "Full Name",
                          value: widget.username,
                          icon: Icons.person_outline,
                        ),
                        SizedBox(height: 12),
                        _ProfileTextField(
                          label: "Gender",
                          value: widget.gender ?? "-",
                          icon: Icons.wc,
                        ),
                        SizedBox(height: 12),
                        _ProfileTextField(
                          label: "Date of Birth",
                          value: widget.dateOfBirth != null
                              ? "${widget.dateOfBirth!.day}/${widget.dateOfBirth!.month}/${widget.dateOfBirth!.year}"
                              : "-",
                          icon: Icons.cake_outlined,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Help and Support",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: Color(0xFF222222),
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          "How we can help you?",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: Color(0xFF222222),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Aplikasi DolanYogya berfungsi sebagai portal informasi pariwisata yang menyediakan berbagai informasi mengenai destinasi wisata favorit, ragam budaya, acara, serta berbagai ekonomi kreatif yang ada di Yogyakarta. Selain itu, aplikasi ini juga memungkinkan pengguna untuk memesan tiket destinasi wisata secara online.",
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 16),
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFEFFAF3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.all(12),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: secondaryColor,
                                child: Icon(Icons.chat, color: Colors.white),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Still Need Help?",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF222222),
                                      ),
                                    ),
                                    Text(
                                      "Contact our experts",
                                      style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: secondaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                ),
                                onPressed: () async {
                                  final url = Uri.parse(
                                      'https://wa.me/6282248466613?text=Halo%20Admin%20DolanYogya');
                                  // ignore: deprecated_member_use
                                  if (await canLaunchUrl(url)) {
                                    await launchUrl(url, mode: LaunchMode.externalApplication);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Tidak dapat membuka WhatsApp')),
                                    );
                                  }
                                },
                                child: Text(
                                  "Message Us",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.red,
                      side: BorderSide(color: Colors.red),
                      minimumSize: Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    icon: Icon(Icons.delete_outline),
                    label: Text("Close Account"),
                    onPressed: () async {
                      // Hapus data user dari Hive dan session
                      final prefs = await SharedPreferences.getInstance();
                      final userId = widget.id;
                      // Hapus user dari Hive
                      try {
                        var box = await Hive.openBox('users');
                        await box.delete(userId);
                      } catch (e) {
                        // ignore error
                      }
                      // Hapus session login dan data profil
                      await prefs.setBool('is_logged_in', false);
                      await prefs.remove('user_id');
                      await prefs.remove('user_username');
                      await prefs.remove('user_birthdate');
                      await prefs.remove('user_gender');
                      // Navigasi ke login page
                      if (mounted) {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => LoginPage()),
                          (route) => false,
                        );
                      }
                    },
                  ),
                  SizedBox(height: 16),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      minimumSize: Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    icon: Icon(Icons.logout),
                    label: Text("Log Out"),
                    onPressed: () async {
                      // Hapus session login
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setBool('is_logged_in', false);
                      widget.onLogout();
                    },
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Widget untuk field profil
class _ProfileTextField extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _ProfileTextField({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      enabled: false,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Color(0xFFF7F7FA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        hintText: value,
        hintStyle: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
      controller: TextEditingController(text: value),
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
