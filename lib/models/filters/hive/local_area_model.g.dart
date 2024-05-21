// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_area_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LocalAreaModelAdapter extends TypeAdapter<LocalAreaModel> {
  @override
  final int typeId = 0;

  @override
  LocalAreaModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocalAreaModel(
      code: fields[0] as int,
      hasNext: fields[1] as bool,
      label: fields[2] as String,
      parentLabel: fields[3] as String,
      link: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, LocalAreaModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.code)
      ..writeByte(1)
      ..write(obj.hasNext)
      ..writeByte(2)
      ..write(obj.label)
      ..writeByte(3)
      ..write(obj.parentLabel)
      ..writeByte(4)
      ..write(obj.link);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalAreaModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
