// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_hivi.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiviModelAdapter extends TypeAdapter<HiviModel> {
  @override
  final int typeId = 1;

  @override
  HiviModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiviModel(
      userId: fields[0] as int,
      id: fields[1] as int,
      placeName: fields[2] as String,
      description: fields[3] as String,
      category: fields[4] as String,
      city: fields[5] as String,
      price: fields[6] as int,
      ratingAvg: fields[7] as double,
      latitude: fields[8] as double,
      longitude: fields[9] as double,
      pictureUrl: fields[10] as String,
    );
  }

  @override
  void write(BinaryWriter writer, HiviModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.placeName)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.category)
      ..writeByte(5)
      ..write(obj.city)
      ..writeByte(6)
      ..write(obj.price)
      ..writeByte(7)
      ..write(obj.ratingAvg)
      ..writeByte(8)
      ..write(obj.latitude)
      ..writeByte(9)
      ..write(obj.longitude)
      ..writeByte(10)
      ..write(obj.pictureUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiviModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
