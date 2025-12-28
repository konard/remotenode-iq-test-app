// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test_result.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TestResultAdapter extends TypeAdapter<TestResult> {
  @override
  final int typeId = 0;

  @override
  TestResult read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TestResult(
      id: fields[0] as String,
      completedAt: fields[1] as DateTime,
      totalTimeSeconds: fields[2] as int,
      totalQuestions: fields[3] as int,
      correctAnswers: fields[4] as int,
      categoryCorrect: (fields[5] as Map).cast<String, int>(),
      categoryTotal: (fields[6] as Map).cast<String, int>(),
      iqScore: fields[7] as int,
      percentile: fields[8] as int,
      answersJson: (fields[9] as List)
          .map((dynamic e) => (e as Map).cast<String, dynamic>())
          .toList(),
    );
  }

  @override
  void write(BinaryWriter writer, TestResult obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.completedAt)
      ..writeByte(2)
      ..write(obj.totalTimeSeconds)
      ..writeByte(3)
      ..write(obj.totalQuestions)
      ..writeByte(4)
      ..write(obj.correctAnswers)
      ..writeByte(5)
      ..write(obj.categoryCorrect)
      ..writeByte(6)
      ..write(obj.categoryTotal)
      ..writeByte(7)
      ..write(obj.iqScore)
      ..writeByte(8)
      ..write(obj.percentile)
      ..writeByte(9)
      ..write(obj.answersJson);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TestResultAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
