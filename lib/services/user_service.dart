import 'package:basic_utils/basic_utils.dart';
import 'package:hive/hive.dart';
import 'package:project_tpm/utils/rsa_helper.dart';
import '../models/user.dart';

class UserService {
  final Box<User> userBox = Hive.box<User>('users');

  Future<bool> addUser(User user) async {
    if (userBox.containsKey(user.username)) return false;

    final publicKey = await RSAHelper.getPublicKey();
    if (publicKey == null) return false;

    final encryptedPassword = await RSAHelper.encrypt(user.password, publicKey);

    final newUser = User(
      username: user.username,
      password: encryptedPassword,
      gender: user.gender,
      dateOfBirth: user.dateOfBirth,
      publicKey: CryptoUtils.encodeRSAPublicKeyToPem(publicKey),
    );

    await userBox.put(user.username, newUser);
    return true;
  }

  Future<bool> login(String username, String passwordInput) async {
    final user = userBox.get(username);
    if (user == null) return false;

    final privateKey = await RSAHelper.getPrivateKey();
    if (privateKey == null) return false;

    final decryptedPassword = await RSAHelper.decrypt(user.password, privateKey);

    return decryptedPassword == passwordInput;
  }

  // UPDATE
  Future<bool> updateUser(int index, User updatedUser) async {
    try {
      await userBox.putAt(index, updatedUser);
      return true;
    } catch (e) {
      print("Error updating user: $e");
      return false;
    }
  }

  // DELETE
  Future<bool> deleteUser(int index) async {
    try {
      await userBox.deleteAt(index);
      return true;
    } catch (e) {
      print("Error deleting user: $e");
      return false;
    }
  }

  Future<User?> getUser(String username) async {
    return userBox.get(username);
  }
}