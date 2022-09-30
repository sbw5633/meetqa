import 'package:hive_flutter/hive_flutter.dart';

part 'question_model.g.dart';

@HiveType(typeId: 2)
enum QuestionTheme {
  //사랑
  @HiveField(0)
  LOVE,
  //우정
  @HiveField(1)
  FRIENDSHIP,
  //결혼
  @HiveField(2)
  WEDDING,
  //가족
  @HiveField(3)
  FAMILY,
  //일상
  @HiveField(4)
  DAILY_LIFE,
  //기타
  @HiveField(5)
  ETC,
}

@HiveType(typeId: 1)
class QuestionModel {
  @HiveField(0)
  final int index;
  @HiveField(1)
  final QuestionTheme theme;
  @HiveField(2)
  final int deep;
  @HiveField(3)
  final String asking;
  @HiveField(4)
  final List tag;

  QuestionModel({
    required this.index,
    required this.theme,
    required this.deep,
    required this.asking,
    required this.tag,
  });

  QuestionModel.fromJSON({required Map<String, dynamic> json})
      : index = json['index'],
        theme = parseQuestionTheme(json['theme']),
        deep = json['deep'] ?? 1,
        asking = json['asking'],
        tag = json['tag'] ?? '';

  static QuestionTheme parseQuestionTheme(String theme) {
    String cate = 'ETC';

    switch (theme) {
      case '사랑':
        cate = 'LOVE';
        break;
      case '우정':
        cate = 'FRIENDSHIP';
        break;
      case '결혼':
        cate = 'WEDDING';
        break;
      case '가족':
        cate = 'FAMILY';
        break;
      case '일상':
        cate = 'DAILY_LIFE';
        break;
      case '기타':
        cate = 'ETC';
        break;
      default:
        cate = 'ETC';
    }

    return QuestionTheme.values.firstWhere((element) => element.name == cate);
  }

  // static QuestionTag parseQuestionTag(String tag) {
  //   return QuestionTag.values.firstWhere((element) => element.name == tag);
  // }
}
