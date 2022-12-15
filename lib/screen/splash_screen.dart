import 'package:firebase_auth/firebase_auth.dart';
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
  const SplashScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _userBox = Hive.box("userData");

  bool loadingSign = false;

  Future<bool> signIn() async {
    try {
      await SignManager().signIn();

      if (nowUser != null) {
        flutterToast("환영합니다");
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint("LoginScreen Error: $e");
      return false;
    }
  }

  Future<bool> isLoadingTime() async {
    // if (!widget.endSplash) {
    await Future.wait(
        [DataManager().getDataFlow(), checkUserDataAtHive(), isSplashTime()]);
    // }

    return true;
  }

  Future<void> checkUserDataAtHive() async {
    final box = Hive.box('UserData');

    if (box.get("nowUser") != null) {
      nowUser = box.get('nowUser');
    }

    print("bx? ${box.get('nowUser')}");
  }

  //mainImg 보여주는 시간. time은 여기서 변경
  Future<void> isSplashTime() async {
    //...............//
    //bgImg 시간      //
    //...............//
    int time = 3000;

    await Future.delayed(Duration(milliseconds: time));
    return;
  }

  TextStyle ts = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder<bool>(
            future: isLoadingTime(),
            builder: (context, snapshot) {
              print("snapshot? ${snapshot.data}");

              //스플래시스크린 n(m/s) 보여준 뒤 로그인 시작
              // if (!widget.endSplash &&
              //     snapshot.connectionState == ConnectionState.done) {
              //   print("Auth User: ${FirebaseAuth.instance.currentUser}");
              //   return AuthService().handleAuthState();
              // } else {
              if (snapshot.data == true && nowUser != null) {
                moveWelcomeScreen();
                return Container();
              } else {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32.0),
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 9,
                          child:
                              // Lottie.asset('assets/lottie/75943-sample.json'),
                              // Lottie.asset('assets/lottie/test_lottie.json'),
                              Stack(
                            children: [
                              Image.asset(
                                'assets/images/main_bg.jpg',
                                fit: BoxFit.cover,
                              ),
                              Positioned(
                                left: 0,
                                right: 0,
                                top: -80,
                                child: Image.asset(
                                    'assets/images/logo/splash_logo.png'),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                            flex: 4,
                            child: loadingSign
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                        CircularProgressIndicator(),
                                        Container()
                                      ])
                                : snapshot.connectionState ==
                                            ConnectionState.none ||
                                        snapshot.data == null
                                    ? Container()
                                    : Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          InkWell(
                                            onTap: () async {
                                              setState(() {
                                                loadingSign = true;
                                              });
                                              final bool resp = await signIn();
                                              setState(() {
                                                loadingSign = resp;
                                              });
                                              print("nU = $nowUser");
                                              if (nowUser != null) {
                                                moveWelcomeScreen();
                                              }
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
                                              nowUser = await AuthService()
                                                  .guestUser();
                                              if (nowUser == null) {
                                                flutterToast("게스트로 로그인했습니다.");
                                                moveWelcomeScreen();
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
                    ),
                  ),
                );
              }
            }
            // }
            ),
      ),
    );
  }

  void moveWelcomeScreen() {
    runApp(const MaterialApp(
      home: WelcomeScreen(),
    ));

    //   Navigator.of(context).pushAndRemoveUntil(
    //       MaterialPageRoute(builder: (_) => WelcomeScreen()), (route) => false);
  }
}
