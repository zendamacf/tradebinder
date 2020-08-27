// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'magiccard.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MagicCardAdapter extends TypeAdapter<MagicCard> {
  @override
  final int typeId = 1;

  @override
  MagicCard read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MagicCard(
      id: fields[0] as int,
      collectornumber: fields[1] as String,
      name: fields[2] as String,
      rarity: fields[3] as String,
      type: fields[4] as String,
      power: fields[5] as String,
      toughness: fields[6] as String,
      oracletext: fields[7] as String,
      flavortext: fields[8] as String,
      url: fields[9] as String,
      imageurl: fields[10] as String,
      setname: fields[11] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MagicCard obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.collectornumber)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.rarity)
      ..writeByte(4)
      ..write(obj.type)
      ..writeByte(5)
      ..write(obj.power)
      ..writeByte(6)
      ..write(obj.toughness)
      ..writeByte(7)
      ..write(obj.oracletext)
      ..writeByte(8)
      ..write(obj.flavortext)
      ..writeByte(9)
      ..write(obj.url)
      ..writeByte(10)
      ..write(obj.imageurl)
      ..writeByte(11)
      ..write(obj.setname);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MagicCardAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
