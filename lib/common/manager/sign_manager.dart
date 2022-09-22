import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meetqa/common/component/flutter_toast.dart';
import 'package:meetqa/common/const/user_id.dart';
import 'package:meetqa/user/model/user_model.dart';
import 'package:meetqa/common/manager/auth_service.dart';

class SignManager {
  static AuthService serv = AuthService();

  Future<void> signIn() async {
    try {
      currentUser = await serv.signInWithGoogle();

      if (currentUser == null) {
        return;
      }

      await checkUserAtDB();

      if (currentUser == null) {
        nowUser = await signUp();
      } else {
        SignManager().setNowUser();
      }
    } catch (e) {
      debugPrint("signIn Error! $e");

      flutterToast("로그인에 실패했습니다.");
    }
  }

  void ticketSetter() {
    final box = Hive.box("UserData");

    print("티켓 box: ${box.keys}");

    //신규 유저(noLocalData) 또는 이전 종료가 정상종료였으면 fb에서 받아옴
    if (box.get("saved") == null || box.get("saved") == "saved") {
      box.put("passTicket", nowUser!.passTicket);
      box.put("saved", "get");
    }
  }

  Future<void> ticketSave() async {
    final box = Hive.box("UserData");
    int _ticket = box.get("passTicket");

    await FirebaseFirestore.instance
        .doc("User/${nowUser!.uid}")
        .update({"passTicket": _ticket});

    box.put("saved", "saved");
    print("ticketSave box4: ${Hive.box("UserData").values}");
  }

  Future<void> signOut() async {
    print("signOut box: ${Hive.box("UserData").values}");

    await ticketSave();
    currentUser = await serv.signOut();
    nowUser = null;
    userName = "guest";
  }

  Future<void> guest() async {
    currentUser = await serv.guestUser();
    nowUser = null;
    userName = "guest";
  }

  Future<UserModel?> signUp() async {
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

    ticketSetter();

    return _newUser;
  }

  Future<void> checkUserAtDB() async {
    final userDB = await FirebaseFirestore.instance.collection('User').get();

    //기존 DB에 있을 경우 받아오고, 없으면 신규 가입
    if (userDB.docs.where((db) {
      debugPrint("checkUserAtDB 들어옴3: ${currentUser!.email}");
      return db["userID"] == currentUser!.email;
    }).isNotEmpty) {
      setNowUser();
    } else {
      debugPrint("썌유쪄");
      return;
    }
  }

  //로그인 하면 nowUser 셋팅
  Future<void> setNowUser() async {
    final _user =
        await FirebaseFirestore.instance.doc("User/${currentUser!.uid}").get();

    nowUser = UserModel.fromDB(
      _user.data()!,
    );

    print("록읜 후 nowUser: $nowUser");

    ticketSetter();
  }
}
