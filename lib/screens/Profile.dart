import 'package:flutter/material.dart';
import 'dart:math';

class UserProfileScreen extends StatelessWidget {
  final String username;
  final String? gender;
  final DateTime? dateOfBirth;
  final VoidCallback onLogout;

  UserProfileScreen({
    required this.username,
    required this.gender,
    required this.dateOfBirth,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserSettingsScreen(
                  username: username,
                  gender: gender,
                  dateOfBirth: dateOfBirth,
                ),
              ),
            );
          },
        ),
        title: Text('Profil Pengguna'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            tooltip: "Logout",
            onPressed: onLogout,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(height: 16),
            CircleAvatar(
              radius: 48,
              child: Icon(Icons.person, size: 56),
            ),
            SizedBox(height: 16),
            Text(
              username,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              gender ?? "-",
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
            SizedBox(height: 4),
            Text(
              dateOfBirth != null
                  ? "${dateOfBirth!.day}/${dateOfBirth!.month}/${dateOfBirth!.year}"
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
                          onTap: () {
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.phone),
                          title: Text('Hubungi Kami'),
                          onTap: () {
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.privacy_tip),
                          title: Text('Ketentuan & Kebijakan Privasi'),
                          onTap: () {
                          },
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

class UserSettingsScreen extends StatefulWidget {
  final String username;
  final String? gender;
  final DateTime? dateOfBirth;

  UserSettingsScreen({
    required this.username,
    required this.gender,
    required this.dateOfBirth,
  });

  @override
  _UserSettingsScreenState createState() => _UserSettingsScreenState();
}

class _UserSettingsScreenState extends State<UserSettingsScreen> {
  late String username;
  String? gender;
  DateTime? dateOfBirth;
  String newPhone = "";
  bool isEditing = false;
  bool showPasswordChange = false;
  String verificationCode = "";
  String inputCode = "";
  String newPassword = "";
  bool isVerified = false;

  @override
  void initState() {
    super.initState();
    username = widget.username;
    gender = widget.gender;
    dateOfBirth = widget.dateOfBirth;
  }

  String generateCode() {
    var rng = Random();
    return (100000 + rng.nextInt(900000)).toString();
  }

  void sendVerificationCode() {
    setState(() {
      verificationCode = generateCode();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kode verifikasi dikirim ke WhatsApp: $verificationCode')),
      );
    });
  }

  void verifyCode() {
    if (inputCode == verificationCode) {
      setState(() {
        isVerified = true;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Verifikasi berhasil!')),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kode verifikasi salah!')),
      );
    }
  }

  void saveProfile() {
    setState(() {
      username = username;
      gender = gender;
      dateOfBirth = dateOfBirth;
      isEditing = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Profil berhasil diperbarui!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pengaturan Profil'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: [
            isEditing
                ? Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(labelText: 'Nama Pengguna'),
                        controller: TextEditingController(text: username),
                        onChanged: (val) => username = val,
                      ),
                      TextField(
                        decoration: InputDecoration(labelText: 'Jenis Kelamin'),
                        controller: TextEditingController(text: gender),
                        onChanged: (val) => gender = val,
                      ),
                      SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: saveProfile,
                        child: Text('Simpan'),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            isEditing = false;
                          });
                        },
                        child: Text('Batal'),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Nama Pengguna: $username', style: TextStyle(fontSize: 18)),
                      Text('Jenis Kelamin: ${gender ?? "-"}', style: TextStyle(fontSize: 16)),
                      Text('Tanggal Lahir: ${dateOfBirth != null ? "${dateOfBirth!.day}/${dateOfBirth!.month}/${dateOfBirth!.year}" : "-"}', style: TextStyle(fontSize: 16)),
                      SizedBox(height: 8),
                      ElevatedButton.icon(
                        icon: Icon(Icons.edit),
                        label: Text('Edit Profil'),
                        onPressed: () {
                          setState(() {
                            isEditing = true;
                          });
                        },
                      ),
                    ],
                  ),
            SizedBox(height: 24),
            ListTile(
              leading: Icon(Icons.lock),
              title: Text('Ubah Password'),
              onTap: () {
                setState(() {
                  showPasswordChange = true;
                  isVerified = false;
                  inputCode = "";
                  newPassword = "";
                  newPhone = "";
                });
              },
            ),
            if (showPasswordChange)
              Card(
                margin: EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    children: [
                      if (newPhone.isEmpty)
                        Column(
                          children: [
                            Text('Tambahkan nomor HP untuk verifikasi WhatsApp'),
                            TextField(
                              decoration: InputDecoration(labelText: 'Nomor HP'),
                              onChanged: (val) => newPhone = val,
                              keyboardType: TextInputType.phone,
                            ),
                            SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: newPhone.length >= 10 ? sendVerificationCode : null,
                              child: Text('Kirim Kode Verifikasi'),
                            ),
                          ],
                        )
                      else if (!isVerified)
                        Column(
                          children: [
                            Text('Kode verifikasi akan dikirim ke WhatsApp: ${newPhone}'),
                            ElevatedButton(
                              onPressed: sendVerificationCode,
                              child: Text('Kirim Kode Verifikasi'),
                            ),
                            TextField(
                              decoration: InputDecoration(labelText: 'Masukkan Kode Verifikasi'),
                              onChanged: (val) => inputCode = val,
                              keyboardType: TextInputType.number,
                            ),
                            ElevatedButton(
                              onPressed: inputCode.length == 6 ? verifyCode : null,
                              child: Text('Verifikasi'),
                            ),
                          ],
                        )
                      else
                        Column(
                          children: [
                            TextField(
                              decoration: InputDecoration(labelText: 'Password Baru'),
                              obscureText: true,
                              onChanged: (val) => newPassword = val,
                            ),
                            SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: newPassword.length >= 6
                                  ? () {
                                      setState(() {
                                        showPasswordChange = false;
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Password berhasil diubah!')),
                                        );
                                      });
                                    }
                                  : null,
                              child: Text('Simpan Password'),
                            ),
                          ],
                        ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            showPasswordChange = false;
                          });
                        },
                        child: Text('Batal'),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}