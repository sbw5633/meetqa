import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:meetqa/common/const/user_id.dart';
import 'package:meetqa/screen/home_screen.dart';
import 'package:meetqa/common/manager/auth_service.dart';
import 'package:meetqa/common/component/flutter_toast.dart';
import 'package:meetqa/common/manager/sign_manager.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: size.height * 0.2,
            bottom: size.height * 0.5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Hello, \nmeetQA",
              style: TextStyle(fontSize: 30),
            ),
            InkWell(
              onTap: () async {
                await signIn();
              },
              child: const Text("Sign In"),
            ),
            InkWell(
              onTap: () async {
                currentUser = await AuthService().guestUser();
                if (currentUser == null) {
                  flutterToast("게스트로 로그인했습니다.");
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => HomeScreen()),
                      (route) => false);
                } else {
                  flutterToast("다시 시도해주세요.");
                }
              },
              child: const Text("Guest"),
            )
          ],
        ),
      ),
    );
  }
}
