import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:meetqa/common/const/user_info.dart';
import 'package:meetqa/question/data/data_manager.dart';
import 'package:meetqa/screen/welcome_screen.dart';
import 'package:meetqa/common/manager/auth_service.dart';
import 'package:meetqa/common/component/flutter_toast.dart';
import 'package:meetqa/common/manager/sign_manager.dart';

import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  final bool endSplash;
  const SplashScreen({
    Key? key,
    required this.endSplash,
  }) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _userBox = Hive.box("userData");

  Future<void> signIn() async {
    try {
      await SignManager().signIn();

      if (userName != null) {
        flutterToast("환영합니다");
      }
    } catch (e) {
      debugPrint("LoginScreen Error: $e");
    }
  }

  Future<bool> isLoadingTime() async {
    if (!widget.endSplash) {
      await Future.wait([DataManager().getDataFlow(), isSplashTime()]);
    }
    return true;
  }

  //mainImg 보여주는 시간. time은 여기서 변경
  Future<void> isSplashTime() async {
    //...............//
    //bgImg 시간      //
    //...............//
    int time = 1000;

    await Future.delayed(Duration(milliseconds: time));
    return;
  }

  TextStyle ts = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<bool>(
          future: isLoadingTime(),
          builder: (context, snapshot) {
            print("snapshot? ${snapshot.data}");
            //스플래시스크린 n(m/s) 보여준 뒤 로그인 시작
            if (!widget.endSplash &&
                snapshot.connectionState == ConnectionState.done) {
              return AuthService().handleAuthState();
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 9,
                    child:
                        // Lottie.asset('assets/lottie/data.json'),
                        Image.asset(
                      'assets/images/main_bg.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                      flex: 4,
                      child: snapshot.connectionState == ConnectionState.none ||
                              snapshot.data == null
                          ? Container()
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () async {
                                    await signIn();
                                  },
                                  child: Text(
                                    "로그인 ➡️",
                                    style: ts,
                                  ),
                                ),
                                SizedBox(
                                  height: 32,
                                ),
                                InkWell(
                                  onTap: () async {
                                    currentUser =
                                        await AuthService().guestUser();
                                    if (currentUser == null) {
                                      flutterToast("게스트로 로그인했습니다.");
                                      Navigator.of(context).pushAndRemoveUntil(
                                          MaterialPageRoute(
                                              builder: (_) => WelcomeScreen()),
                                          (route) => false);
                                    } else {
                                      flutterToast("다시 시도해주세요.");
                                    }
                                  },
                                  child: Text(
                                    "게스트 ➡️",
                                    style: ts,
                                  ),
                                )
                              ],
                            )),
                ],
              );
            }
          }),
    );
  }
}
