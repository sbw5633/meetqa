import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meetqa/common/component/flutter_toast.dart';
import 'package:meetqa/common/const/user_info.dart';
import 'package:meetqa/user/model/user_model.dart';
import 'package:meetqa/common/manager/auth_service.dart';

class SignManager {
  static AuthService serv = AuthService();

  Future<bool> signIn() async {
    final box = Hive.box('UserData');

    try {
      currentUser = await serv.signInWithGoogle();

      // if (currentUser == null) {
      //   return;
      // }

      if (currentUser != null) {
        final _nowUser = await checkUserAtDB();
        box.put('nowUser', _nowUser);

        nowUser = _nowUser;

        ticketSetter();

        print("록읜 후 nowUser: $nowUser");

        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint("signIn Error! $e");

      flutterToast("로그인에 실패했습니다.");

      return false;
    }
  }

  void ticketSetter() {
    final box = Hive.box("UserData");

    print("hi box? :${box.keys}");
    print("box.get? :${box.get('saved')}");

    //신규 유저(noLocalData) 또는 이전 종료가 정상종료였으면 fb에서 받아옴
    if (box.get("saved") == null || box.get("saved") == "saved") {
      box.put("passTicket", nowUser!.passTicket);
      box.put("saved", "get");
    }
    print("티켓 box: ${box.keys}");
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
    nowUser = await serv.signOut();
    currentUser = null;
    final box = Hive.box('UserData');
    box.put('nowUser', nowUser);
    userName = "guest";
  }

  Future<void> guest() async {
    nowUser = await serv.guestUser();
    currentUser = null;
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

    return _newUser;
  }

  Future<UserModel?> checkUserAtDB() async {
    final userDB = await FirebaseFirestore.instance.collection('User').get();

    UserModel? _nowUser;

    //기존 DB에 있을 경우 받아오고, 없으면 신규 가입
    if (userDB.docs.where((db) {
      debugPrint("checkUserAtDB 들어옴3: ${currentUser!.email}");
      return db["userID"] == currentUser!.email;
    }).isNotEmpty) {
      _nowUser = await setNowUser();
    } else {
      debugPrint("썌유쪄");
      _nowUser = await signUp();
    }

    return _nowUser;
  }

  //로그인 하면 nowUser 셋팅
  Future<UserModel> setNowUser() async {
    final _user =
        await FirebaseFirestore.instance.doc("User/${currentUser!.uid}").get();

    final UserModel _nowUser = UserModel.fromDB(
      _user.data()!,
    );
    print("_nowuser?: $_nowUser");

    return _nowUser;
  }
}
