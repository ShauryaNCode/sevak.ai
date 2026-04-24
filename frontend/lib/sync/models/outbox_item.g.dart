// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'outbox_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OutboxItemAdapter extends TypeAdapter<OutboxItem> {
  @override
  final int typeId = 0;

  @override
  OutboxItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OutboxItem(
      id: fields[0] as String,
      documentId: fields[1] as String,
      documentType: fields[2] as String,
      operationType: fields[3] as String,
      payload: fields[4] as String,
      zoneId: fields[5] as String,
      createdAt: fields[6] as DateTime,
      retryCount: fields[7] as int,
      lastAttemptAt: fields[8] as DateTime?,
      errorMessage: fields[9] as String?,
      isDeadLetter: fields[10] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, OutboxItem obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.documentId)
      ..writeByte(2)
      ..write(obj.documentType)
      ..writeByte(3)
      ..write(obj.operationType)
      ..writeByte(4)
      ..write(obj.payload)
      ..writeByte(5)
      ..write(obj.zoneId)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.retryCount)
      ..writeByte(8)
      ..write(obj.lastAttemptAt)
      ..writeByte(9)
      ..write(obj.errorMessage)
      ..writeByte(10)
      ..write(obj.isDeadLetter);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OutboxItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
