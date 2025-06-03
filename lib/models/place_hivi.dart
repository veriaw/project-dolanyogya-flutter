import 'package:hive/hive.dart';

part 'place_hivi.g.dart';

@HiveType(typeId: 1)
class HiviModel extends HiveObject {
  @HiveField(0)
  final int userId;

  @HiveField(1)
  final int id;

  @HiveField(2)
  final String placeName;

  @HiveField(3)
  final String description;

  @HiveField(4)
  final String category;

  @HiveField(5)
  final String city;

  @HiveField(6)
  final int price;

  @HiveField(7)
  final double ratingAvg;

  @HiveField(8)
  final double latitude;

  @HiveField(9)
  final double longitude;

  @HiveField(10)
  final String pictureUrl;

  HiviModel({
    required this.userId,
    required this.id,
    required this.placeName,
    required this.description,
    required this.category,
    required this.city,
    required this.price,
    required this.ratingAvg,
    required this.latitude,
    required this.longitude,
    required this.pictureUrl,
  });
}