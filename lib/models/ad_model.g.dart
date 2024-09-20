// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ad_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AdModelAdapter extends TypeAdapter<AdModel> {
  @override
  final int typeId = 3;

  @override
  AdModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AdModel(
      id: fields[0] as int,
      long_link: fields[1] as String,
      title: fields[2] as String,
      thumb: fields[3] as String,
      category: fields[4] as String,
      location: fields[5] as String,
      date: fields[6] as String,
      price: fields[7] as String,
      photos: fields[8] as int,
      contactByMail: fields[9] as bool,
      hasChat: fields[10] as bool,
      contactByPhone: fields[11] as bool,
      contactPhone: fields[12] as String,
      isMobile: fields[13] as bool,
      isJob: fields[14] as bool,
      userIsPro: fields[15] as int,
      externalLink: fields[17] as String,
      userPro: (fields[16] as Map).cast<String, dynamic>(),
      typeAd: fields[18] as String,
      adFeatured: fields[19] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, AdModel obj) {
    writer
      ..writeByte(20)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.long_link)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.thumb)
      ..writeByte(4)
      ..write(obj.category)
      ..writeByte(5)
      ..write(obj.location)
      ..writeByte(6)
      ..write(obj.date)
      ..writeByte(7)
      ..write(obj.price)
      ..writeByte(8)
      ..write(obj.photos)
      ..writeByte(9)
      ..write(obj.contactByMail)
      ..writeByte(10)
      ..write(obj.hasChat)
      ..writeByte(11)
      ..write(obj.contactByPhone)
      ..writeByte(12)
      ..write(obj.contactPhone)
      ..writeByte(13)
      ..write(obj.isMobile)
      ..writeByte(14)
      ..write(obj.isJob)
      ..writeByte(15)
      ..write(obj.userIsPro)
      ..writeByte(16)
      ..write(obj.userPro)
      ..writeByte(17)
      ..write(obj.externalLink)
      ..writeByte(18)
      ..write(obj.typeAd)
      ..writeByte(19)
      ..write(obj.adFeatured);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AdModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
