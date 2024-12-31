// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'node.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NodeAdapter extends TypeAdapter<Node> {
  @override
  final int typeId = 0;

  @override
  Node read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Node(
      fields[0] as int,
      fields[1] as int,
      fields[2] as int,
      fields[3] as int,
      fields[4] as String,
      fields[5] as String,
      fields[6] as String,
      fields[7] as String,
      fields[8] as int,
      fields[9] as int,
      fields[10] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Node obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.iD)
      ..writeByte(1)
      ..write(obj.optionA)
      ..writeByte(2)
      ..write(obj.optionB)
      ..writeByte(3)
      ..write(obj.optionC)
      ..writeByte(4)
      ..write(obj.displayText)
      ..writeByte(5)
      ..write(obj.answerA)
      ..writeByte(6)
      ..write(obj.answerB)
      ..writeByte(7)
      ..write(obj.answerC)
      ..writeByte(8)
      ..write(obj.costOfOptionA)
      ..writeByte(9)
      ..write(obj.costOfOptionB)
      ..writeByte(10)
      ..write(obj.costOfOptionC);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NodeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
