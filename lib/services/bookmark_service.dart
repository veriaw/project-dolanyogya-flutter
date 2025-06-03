import 'package:hive/hive.dart';
import 'package:project_tpm/models/place_hivi.dart'; // Pastikan path ini sesuai

class BookmarkService {
  static const String _boxName = 'bookmarkBox';

  // Membuka box Hive untuk menyimpan bookmark
  static Future<Box<HiviModel>> openBox() async {
    return await Hive.openBox<HiviModel>(_boxName);
  }

  // Menambahkan tempat ke bookmark
  static Future<void> addBookmark(HiviModel place) async {
    final box = await openBox();
    await box.put(place.id, place); // Gunakan place.id sebagai key unik
  }

  // Menghapus bookmark berdasarkan id
  static Future<void> removeBookmark(int id) async {
    final box = await openBox();
    await box.delete(id);
  }

  // Mengecek apakah tempat sudah dibookmark
  static Future<bool> isBookmarked(int id) async {
    final box = await openBox();
    return box.containsKey(id);
  }

  // Mengambil semua bookmark
  static Future<List<HiviModel>> getAllBookmarks() async {
    final box = await openBox();
    return box.values.toList();
  }

  // Mengambil bookmark milik user tertentu (berdasarkan userId)
  static Future<List<HiviModel>> getBookmarksByUser(int userId) async {
    final box = await openBox();
    return box.values
        .where((place) => place.userId == userId)
        .toList();
  }
}