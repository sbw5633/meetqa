import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meetqa/common/view/splash_screen.dart';
import 'package:meetqa/common/const/user_id.dart';
import 'package:meetqa/screen/home_screen.dart';
import 'package:meetqa/screen/login_screen.dart';
import 'package:meetqa/common/component/flutter_toast.dart';

class AuthService {
  handleAuthState() {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SplashScreen();
          }
          if (snapshot.hasData) {
            print("home date: ${snapshot.data}");
            print("go home");
            currentUser = snapshot.data;
            return HomeScreen();
          } else {
            //로그인스크린에서 체크유저 및 가입, db등록까지 완료해야됨
            print("login date: ${snapshot.data}");
            print("go login");
            return const LoginScreen();
          }
        }));
  }

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser =
          await GoogleSignIn(scopes: <String>["email"]).signIn();

      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      User? _user = FirebaseAuth.instance.currentUser;

      if (_user != null) {
        FirebaseAuth.instance.setPersistence(Persistence.LOCAL);

        return _user;
      } else {
        flutterToast('로그인에 실패했습니다.');
        return null;
      }
    } catch (e) {
      debugPrint("error!! $e");
    }
    return null;
  }

  Future<User?> signOut() async {
    await FirebaseAuth.instance.signOut();
    return await guestUser();
  }

  Future<User?> guestUser() async {
    // await FirebaseAuth.instance.signInAnonymously();
    // final _user = FirebaseAuth.instance.currentUser;
    // if (_user!.isAnonymous) {
    //   return _user;
    // } else {
    //   flutterToast('다시 시도해주세요.');
    //   return null;
    // }
    return null;
  }

  // convertAnonymous() async {
  //   final GoogleSignInAccount? googleUser =
  //       await GoogleSignIn(scopes: <String>["email"]).signIn();

  //   final GoogleSignInAuthentication googleAuth =
  //       await googleUser!.authentication;

  //   final credential =
  //       GoogleAuthProvider.credential(idToken: googleAuth.idToken);

  //   FirebaseAuth.instance.currentUser!
  //       .linkWithCredential(credential)
  //       .then((result) {
  //     print("convert Success!");
  //   }).catchError((onError) {
  //     if (onError.code == 'credential-already-in-use') {
  //       flutterToast("이미 가입된 계정입니다.");
  //       print("이미 존재하는 계정입니다.");
  //     }
  //     print("convert error: ${onError.code}");
  //   });
  // }
}
