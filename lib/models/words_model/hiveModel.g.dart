// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hiveModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveVocabluaryModelAdapter extends TypeAdapter<HiveVocabluaryModel> {
  @override
  final int typeId = 23;

  @override
  HiveVocabluaryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveVocabluaryModel(
      eng: fields[0] as String,
      uz: fields[1] as String,
      name: fields[2] as String,
      date: fields[3] as String,
      unitIndex: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, HiveVocabluaryModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.eng)
      ..writeByte(1)
      ..write(obj.uz)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.unitIndex);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveVocabluaryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
