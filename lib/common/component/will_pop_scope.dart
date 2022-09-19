import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meetqa/common/component/flutter_toast.dart';

//뒤로가기버튼 컨트롤

class OnWillPopController {
  static DateTime? currentBackPressTime;
  bool? isAni;
  bool wantExit;

  OnWillPopController({required this.wantExit, this.isAni});

  Future<bool> backCtlChange() {
    if (isAni != null && isAni!) {
      flutterToast("다시 시도해주세요.");
      return Future.value(false);
    }

    debugPrint("currentBackPressTime: $currentBackPressTime");
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        currentBackPressTime!
            .isBefore(now.subtract(const Duration(seconds: 1)))) {
      currentBackPressTime = now;

      flutterToast(
          wantExit ? "뒤로가기를 한 번 더 누르면 종료합니다." : "뒤로가기를 한 번 더 누르면 홈화면으로 돌아갑니다.");
      return Future.value(false);
    }

    if (wantExit) {
      SystemNavigator.pop();
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}
