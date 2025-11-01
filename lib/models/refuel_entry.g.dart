// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'refuel_entry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RefuelEntryAdapter extends TypeAdapter<RefuelEntry> {
  @override
  final int typeId = 0;

  @override
  RefuelEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RefuelEntry(
      id: fields[0] as String,
      odometer: fields[1] as double,
      fuelLitres: fields[2] as double,
      date: fields[3] as DateTime,
      notes: fields[4] as String,
      mileage: fields[5] as double?,
      distanceTraveled: fields[6] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, RefuelEntry obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.odometer)
      ..writeByte(2)
      ..write(obj.fuelLitres)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.notes)
      ..writeByte(5)
      ..write(obj.mileage)
      ..writeByte(6)
      ..write(obj.distanceTraveled);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RefuelEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
