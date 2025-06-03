import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ProfileImageHelper {
  static final ImagePicker _picker = ImagePicker();

  // Path ke file lokal berdasarkan user ID
  static Future<String> _getImagePath(int userId) async {
    final dir = await getApplicationDocumentsDirectory();
    return '${dir.path}/profile_$userId.png';
  }

  /// Ambil foto dari galeri, simpan lokal, lalu kembalikan file-nya
  static Future<File?> pickAndSaveProfileImage(int userId) async {
    try {
      final picked = await _picker.pickImage(source: ImageSource.gallery);
      if (picked != null) {
        final savePath = await _getImagePath(userId);
        return await File(picked.path).copy(savePath);
      }
    } catch (e) {
      print("Error picking image: $e");
    }
    return null;
  }

  /// Load foto profil lokal jika sudah pernah disimpan
  static Future<File?> loadProfileImage(int userId) async {
    final path = await _getImagePath(userId);
    final file = File(path);
    return await file.exists() ? file : null;
  }
}