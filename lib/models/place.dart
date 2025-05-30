class PlaceModel {
  final int id;
  final String placeName;
  final String description;
  final String category;
  final String city;
  final int price;
  final double ratingAvg;
  final double latitude;
  final double longitude;
  final String pictureUrl;

  PlaceModel({
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

  factory PlaceModel.fromJson(Map<String, dynamic> json) {
    return PlaceModel(
      id: json['id'],
      placeName: json['place_Name'],
      description: json['description'],
      category: json['category'],
      city: json['city'],
      price: json['price'],
      ratingAvg: (json['rating_avg'] is int)
          ? (json['rating_avg'] as int).toDouble()
          : json['rating_avg'],
      latitude: double.parse(json['latitude'].toString()),
      longitude: double.parse(json['longitude'].toString()),
      pictureUrl: json['pictureUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'place_Name': placeName,
      'description': description,
      'category': category,
      'city': city,
      'price': price,
      'rating_avg': ratingAvg,
      'latitude': latitude,
      'longitude': longitude,
      'pictureUrl': pictureUrl,
    };
  }
}