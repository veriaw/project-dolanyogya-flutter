import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 0)
class User extends HiveObject {
  @HiveField(0)
  String username;

  @HiveField(1)
  String password;

  @HiveField(2)
  String? gender;

  @HiveField(3)
  DateTime? dateOfBirth;

  @HiveField(4)
  String? publicKey;

  @HiveField(5)
  String? email;

  @HiveField(6)
  String? phone;

  User({
    required this.username,
    required this.password,
    this.gender,
    this.dateOfBirth,
    this.publicKey,
    this.email,
    this.phone,
  });
}