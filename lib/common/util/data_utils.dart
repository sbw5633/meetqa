import 'package:flutter/material.dart';
import 'package:meetqa/question/model/question_model.dart';

class DataUtils {
  static String getStringFromThemeCode(QuestionTheme theme) {
    switch (theme) {
      case QuestionTheme.LOVE:
        return '사랑';
      case QuestionTheme.DAILY_LIFE:
        return '일상';
      case QuestionTheme.FAMILY:
        return '가족';
      case QuestionTheme.FRIENDSHIP:
        return '친구';
      case QuestionTheme.WEDDING:
        return '결혼';
      case QuestionTheme.ETC:
        return '기타';

      default:
        return 'ALL';
    }
  }

  static Image getBgImage(
      {required QuestionTheme theme,
      required double width,
      required double height}) {
    String _imgName;
    _imgName = theme.name.toLowerCase();

    return Image.asset(
      // 'assets/images/bgimg/daily_life.jpg',
      'assets/images/bgimg/$_imgName.jpg',
      fit: BoxFit.cover,
      width: width,
      height: height,
      color: Colors.grey,
      colorBlendMode: BlendMode.saturation,
    );
  }

  // static String getStringFromTagCode(QuestionTag tag) {
  //   switch (tag) {
  //     case QuestionTag.ADULT:
  //       return '19';
  //     case QuestionTag.AWKWARD:
  //       return '어색한사이';
  //     case QuestionTag.FIRST_MEET:
  //       return '첫 만남';
  //     case QuestionTag.HOBBY:
  //       return '취미';
  //     case QuestionTag.LANGUAGE:
  //       return '언어';
  //     case QuestionTag.STUDY:
  //       return '공부';
  //     case QuestionTag.WHAT_IS_THIS:
  //       return '이런것까지?';
  //     default:
  //       return '';
  //   }
  // }

  static Widget changeDeepToIcon(int deep) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
            deep,
            (index) => const Icon(
                  Icons.star_rate_rounded,
                  size: 20,
                  color: Color(0xFFFFE082),
                  shadows: [
                    BoxShadow(
                      color: Colors.white38,
                      spreadRadius: 2,
                      blurRadius: 10,
                    )
                  ],
                )));
  }
}
