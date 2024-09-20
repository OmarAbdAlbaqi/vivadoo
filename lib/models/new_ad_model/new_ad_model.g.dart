// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'new_ad_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NewAdModelAdapter extends TypeAdapter<NewAdModel> {
  @override
  final int typeId = 2;

  @override
  NewAdModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NewAdModel(
      photos: (fields[0] as List?)?.cast<String>(),
      location: fields[1] as String?,
      category: fields[2] as String?,
      title: fields[3] as String?,
      price: fields[4] as String?,
      currency: fields[5] as String?,
      description: fields[6] as String?,
      name: fields[7] as String?,
      email: fields[8] as String?,
      phone: fields[9] as String?,
      emailActive: fields[10] as String?,
      phoneActive: fields[11] as String?,
      metaFields: fields[12] as String?,
      pseudo: fields[13] as String?,
      categoryLink: fields[14] as String?,
      locationLink: fields[15] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, NewAdModel obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.photos)
      ..writeByte(1)
      ..write(obj.location)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.title)
      ..writeByte(4)
      ..write(obj.price)
      ..writeByte(5)
      ..write(obj.currency)
      ..writeByte(6)
      ..write(obj.description)
      ..writeByte(7)
      ..write(obj.name)
      ..writeByte(8)
      ..write(obj.email)
      ..writeByte(9)
      ..write(obj.phone)
      ..writeByte(10)
      ..write(obj.emailActive)
      ..writeByte(11)
      ..write(obj.phoneActive)
      ..writeByte(12)
      ..write(obj.metaFields)
      ..writeByte(13)
      ..write(obj.pseudo)
      ..writeByte(14)
      ..write(obj.categoryLink)
      ..writeByte(15)
      ..write(obj.locationLink);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NewAdModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
