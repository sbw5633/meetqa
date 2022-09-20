import 'package:flutter/material.dart';

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
  final Color backgroundColor;

  CategoryCardModel({
    required this.category,
    required this.imgPath,
    required this.backgroundColor,
  });

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

  String parstCateToString() {
    askCate cate = category;
    switch (cate) {
      case askCate.FirstMeet:
        return "첫 만남";
      case askCate.KnowPeople:
        return "아는 사이";
      case askCate.StartCouple:
        return "시작하는 연인";
      case askCate.LongtimeCouple:
        return "오래된 연인";
      case askCate.Married:
        return "부부";
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
