import 'package:flutter/material.dart';
import 'package:meetqa/common/const/path.dart';

enum askCate {
  FirstMeet,
  KnowPeople,
  StartCouple,
  LongtimeCouple,
  Married,
}

class CategoryCardModel {
  final askCate category;
  final String imgPath;

  CategoryCardModel({
    required this.category,
    required this.imgPath,
  });

  factory CategoryCardModel.fromAskCate({required askCate cate}) {
    return CategoryCardModel(category: cate, imgPath: getImgPath(cate));
  }

  static String getImgPath(askCate cate) {
    switch (cate) {
      case askCate.FirstMeet:
        return '$MENU_ICON_PATH/FirstMeet.png';
      case askCate.KnowPeople:
        return '$MENU_ICON_PATH/KnowPeople.png';
      case askCate.StartCouple:
        return '$MENU_ICON_PATH/StartCouple.png';
      case askCate.LongtimeCouple:
        return '$MENU_ICON_PATH/LongtimeCouple.png';
      case askCate.Married:
        return '$MENU_ICON_PATH/Married.png';
    }
  }

  askCate parseCateToEnum(String cate) {
    switch (cate) {
      case "첫 만남":
        return askCate.FirstMeet;
      case "아는 사이":
        return askCate.KnowPeople;
      case "시작하는 연인":
        return askCate.StartCouple;
      case "오래된 연인":
        return askCate.LongtimeCouple;
      case "부부":
        return askCate.Married;
      default:
        return askCate.FirstMeet;
    }
  }

  static String parstCateToString(String cate) {
    switch (cate) {
      case 'FirstMeet':
        return "첫 만남";
      case 'KnowPeople':
        return "아는 사이";
      case 'StartCouple':
        return "시작하는 연인";
      case 'LongtimeCouple':
        return "오래된 연인";
      case 'Married':
        return "부부";
      default:
        return "";
    }
  }

  String parstCateToEng() {
    askCate cate = category;
    switch (cate) {
      case askCate.FirstMeet:
        return "FirstMeet";
      case askCate.KnowPeople:
        return "KnowPeople";
      case askCate.StartCouple:
        return "StartCouple";
      case askCate.LongtimeCouple:
        return "LongtimeCouple";
      case askCate.Married:
        return "Married";
    }
  }
}
