import 'package:hive_flutter/hive_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_question.g.dart';

@JsonSerializable()
@HiveType(typeId: 1)
class UserQuestion {
  @HiveField(0)
  final int idx;
  @HiveField(1)
  final String asking;
  @HiveField(2)
  final String? answer;

  UserQuestion({required this.idx, required this.asking, this.answer});

  factory UserQuestion.fromJson(Map<String, dynamic> json) =>
      _$UserQuestionFromJson(json);

  Map<String, dynamic> toJson() => _$UserQuestionToJson(this);
}
