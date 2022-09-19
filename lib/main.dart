import 'dart:io';

import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meetqa/common/const/ad_id.dart';
import 'package:meetqa/common/const/category_data.dart';
import 'package:meetqa/question/model/category_card_model.dart';
import 'package:meetqa/question/model/question_model.dart';

import 'package:meetqa/common/manager/auth_service.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter<QuestionModel>(QuestionModelAdapter());
  Hive.registerAdapter<QuestionTheme>(QuestionThemeAdapter());

  for (CategoryCardModel cateModel in cateLists) {
    // await Hive.openBox<QuestionModel>('Question_${cateModel.parseCateToKor()}');
    await Hive.openBox<QuestionModel>(
        'Question_${cateModel.category.toString()}');
    debugPrint("opened HiveBox: 'Question_${cateModel.category.toString()}'");
  }

  await Hive.openBox("DataVersion");

  await Hive.openBox('userData');

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  MobileAds.instance.initialize();

  bannerAdID = Platform.isIOS ? bannerAdTestIDonIOS : bannerAdTestIDonAndroid;
  rewardAdID = Platform.isIOS ? rewardAdTestIDonIOS : rewardAdTestIDonAndroid;

  runApp(MaterialApp(
    theme: ThemeData(fontFamily: 'JejuHallasan'),
    debugShowCheckedModeBanner: false, home: AuthService().handleAuthState(),
    // Matrix4Test()
    // LoginScreen()
    // AuthService().handleAuthState()
  ));
}
