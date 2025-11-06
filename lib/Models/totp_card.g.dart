// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'totp_card.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TotpCardAdapter extends TypeAdapter<TotpCard> {
  @override
  final int typeId = 0;

  @override
  TotpCard read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TotpCard(
      id: fields[0] as String,
      issuer: fields[1] as String,
      accountName: fields[2] as String,
      secret: fields[3] as String,
      digits: fields[4] as int,
      period: fields[5] as int,
      algorithm: fields[6] as String,
      createdAt: fields[7] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, TotpCard obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.issuer)
      ..writeByte(2)
      ..write(obj.accountName)
      ..writeByte(3)
      ..write(obj.secret)
      ..writeByte(4)
      ..write(obj.digits)
      ..writeByte(5)
      ..write(obj.period)
      ..writeByte(6)
      ..write(obj.algorithm)
      ..writeByte(7)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TotpCardAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
