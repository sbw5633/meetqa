// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QuestionModelAdapter extends TypeAdapter<QuestionModel> {
  @override
  final int typeId = 1;

  @override
  QuestionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QuestionModel(
      index: fields[0] as int,
      theme: fields[1] as QuestionTheme,
      deep: fields[2] as int,
      asking: fields[3] as String,
      tag: (fields[4] as List).cast<dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, QuestionModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.index)
      ..writeByte(1)
      ..write(obj.theme)
      ..writeByte(2)
      ..write(obj.deep)
      ..writeByte(3)
      ..write(obj.asking)
      ..writeByte(4)
      ..write(obj.tag);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuestionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class QuestionThemeAdapter extends TypeAdapter<QuestionTheme> {
  @override
  final int typeId = 2;

  @override
  QuestionTheme read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return QuestionTheme.LOVE;
      case 1:
        return QuestionTheme.FRIENDSHIP;
      case 2:
        return QuestionTheme.WEDDING;
      case 3:
        return QuestionTheme.FAMILY;
      case 4:
        return QuestionTheme.DAILY_LIFE;
      case 5:
        return QuestionTheme.ETC;
      default:
        return QuestionTheme.LOVE;
    }
  }

  @override
  void write(BinaryWriter writer, QuestionTheme obj) {
    switch (obj) {
      case QuestionTheme.LOVE:
        writer.writeByte(0);
        break;
      case QuestionTheme.FRIENDSHIP:
        writer.writeByte(1);
        break;
      case QuestionTheme.WEDDING:
        writer.writeByte(2);
        break;
      case QuestionTheme.FAMILY:
        writer.writeByte(3);
        break;
      case QuestionTheme.DAILY_LIFE:
        writer.writeByte(4);
        break;
      case QuestionTheme.ETC:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuestionThemeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
