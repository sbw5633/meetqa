import 'dart:io';

import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meetqa/common/const/ad_id.dart';
import 'package:meetqa/common/const/category_data.dart';
import 'package:meetqa/question/model/category_card_model.dart';
import 'package:meetqa/question/model/question_model.dart';

import 'package:meetqa/screen/splash_screen.dart';
import 'package:meetqa/user/model/user_model.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter<QuestionModel>(QuestionModelAdapter());
  Hive.registerAdapter<QuestionTheme>(QuestionThemeAdapter());
  Hive.registerAdapter<UserModel>(UserModelAdapter());

  for (CategoryCardModel cateModel in cateLists) {
    // await Hive.openBox<QuestionModel>('Question_${cateModel.parseCateToKor()}');
    await Hive.openBox<QuestionModel>('Question_${cateModel.parstCateToEng()}');
    debugPrint("opened HiveBox: 'Question_${cateModel.parstCateToEng()}'");
  }

  await Hive.openBox("DataVersion");

  await Hive.openBox('UserData');

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  MobileAds.instance.initialize();

  bannerAdID = Platform.isIOS ? bannerAdTestIDonIOS : bannerAdTestIDonAndroid;
  rewardAdID = Platform.isIOS ? rewardAdTestIDonIOS : rewardAdTestIDonAndroid;

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]) // 가로모드 비허용
      .then((_) => runApp(MaterialApp(
          theme: ThemeData(fontFamily: 'Pretendard'),
          debugShowCheckedModeBanner: false,
          home: SplashScreen()
          // AuthService().handleAuthState(),
          // Matrix4Test()
          // LoginScreen()
          // AuthService().handleAuthState()
          )));
}
