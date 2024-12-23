// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskAdapter extends TypeAdapter<Task> {
  @override
  final int typeId = 1;

  @override
  Task read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Task(
      id: fields[0] as int,
      title: fields[1] as String,
      date: fields[2] as String,
      priority: fields[3] as String,
      timeToComplete: fields[4] as String,
      taskOwnerId: fields[5] as String,
      taskOwnerEmail: fields[6] as String?,
      completedTime: fields[7] as String,
      isCompleted: fields[8] as bool,
      isVisible: fields[9] as bool,
      idFirestore: fields[10] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Task obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.priority)
      ..writeByte(4)
      ..write(obj.timeToComplete)
      ..writeByte(5)
      ..write(obj.taskOwnerId)
      ..writeByte(6)
      ..write(obj.taskOwnerEmail)
      ..writeByte(7)
      ..write(obj.completedTime)
      ..writeByte(8)
      ..write(obj.isCompleted)
      ..writeByte(9)
      ..write(obj.isVisible)
      ..writeByte(10)
      ..write(obj.idFirestore);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
