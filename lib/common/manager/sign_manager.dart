import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meetqa/common/component/flutter_toast.dart';
import 'package:meetqa/common/const/user_id.dart';
import 'package:meetqa/user/model/user_model.dart';
import 'package:meetqa/common/manager/auth_service.dart';

class SignManager {
  static AuthService serv = AuthService();

  static Future<void> signIn() async {
    debugPrint("signIn 들어옴1");
    try {
      currentUser = await serv.signInWithGoogle();
      debugPrint("signIn 들어옴2 currentUser: $currentUser");

      nowUser = await checkUserAtDB();
      debugPrint("signIn 들어옴3");

      nowUser ??= await signUp();
      debugPrint("signIn 들어옴4");

      userName = nowUser!.userName;
      debugPrint("signIn 들어옴5");
    } catch (e) {
      debugPrint("signIn Error! $e");

      flutterToast("로그인에 실패했습니다.");
    }
  }

  static Future<void> signOut() async {
    currentUser = await serv.signOut();
    nowUser = null;
    userName = "guest";
  }

  static Future<void> guest() async {
    currentUser = await serv.guestUser();
    nowUser = null;
    userName = "guest";
  }

  static Future<UserModel?> signUp() async {
    final _newUser = UserModel(
      uid: currentUser!.uid,
      userID: currentUser!.email,
      userName: currentUser!.displayName!,
      passTicket: 3,
      point: 0,
      phoneNumber: currentUser!.phoneNumber,
      photoURL: currentUser!.photoURL,
    );

    await FirebaseFirestore.instance
        .collection("User")
        .doc(_newUser.uid)
        .set(_newUser.toMap());

    return _newUser;
  }

  static Future<UserModel?> checkUserAtDB() async {
    debugPrint("checkUserAtDB 들어옴1");
    final userDB = await FirebaseFirestore.instance.collection('User').get();
    debugPrint("checkUserAtDB 들어옴2");

    //기존 DB에 있을 경우 받아오고, 없으면 신규 가입
    if (userDB.docs.where((db) {
      debugPrint("checkUserAtDB 들어옴3: ${currentUser!.email}");
      return db["userID"] == currentUser!.email;
    }).isNotEmpty) {
      nowUser = UserModel.fromDB(userDB.docs
          .where((db) => db['userID'] == currentUser!.email)
          .single
          .data());
      debugPrint("is User id: ${nowUser!.userID};");
      return nowUser!;
    } else {
      debugPrint("썌유쪄");
      return null;
    }
  }

  //로그인 하면 nowUser 셋팅
  Future<void> setNowUser() async {
    final _user =
        await FirebaseFirestore.instance.doc("User/${currentUser!.uid}").get();

    nowUser = UserModel.fromDB(
      _user.data()!,
    );
  }
}
