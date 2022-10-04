// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_question.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserQuestionAdapter extends TypeAdapter<UserQuestion> {
  @override
  final int typeId = 3;

  @override
  UserQuestion read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserQuestion(
      idx: fields[0] as int,
      asking: fields[1] as String,
      answer: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserQuestion obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.idx)
      ..writeByte(1)
      ..write(obj.asking)
      ..writeByte(2)
      ..write(obj.answer);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserQuestionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserQuestion _$UserQuestionFromJson(Map<String, dynamic> json) => UserQuestion(
      idx: json['idx'] as int,
      asking: json['asking'] as String,
      answer: json['answer'] as String?,
    );

Map<String, dynamic> _$UserQuestionToJson(UserQuestion instance) =>
    <String, dynamic>{
      'idx': instance.idx,
      'asking': instance.asking,
      'answer': instance.answer,
    };
