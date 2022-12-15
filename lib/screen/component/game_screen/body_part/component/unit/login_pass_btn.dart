import 'package:flutter/material.dart';
import 'package:meetqa/common/component/flutter_toast.dart';
import 'package:meetqa/common/const/user_info.dart';
import 'package:meetqa/common/manager/sign_manager.dart';
import 'package:meetqa/screen/component/game_screen/appbar_widgets.dart';

class LoginOrPassButton extends StatefulWidget {
  final bool isDone;
  final int passTicket;
  final VoidCallback onTapUseTicket;
  final VoidCallback isOverTurn;
  final onPressed;
  const LoginOrPassButton({
    Key? key,
    required this.isDone,
    required this.passTicket,
    required this.onTapUseTicket,
    required this.isOverTurn,
    required this.onPressed,
  }) : super(key: key);

  @override
  State<LoginOrPassButton> createState() => _LoginOrPassButtonState();
}

class _LoginOrPassButtonState extends State<LoginOrPassButton> {
  @override
  Widget build(BuildContext context) {
    return widget.isDone
        ? TextButton(onPressed: widget.isOverTurn, child: const Text("Next"))
        : nowUser == null
            ? TextButton(
                onPressed: () async {
                  final resp = await SignManager().signIn();
                  // if (resp) {
                  // }
                  // widget.onPressed;
                },
                child: const Text("로그인"))
            : TextButton(
                onPressed: widget.onTapUseTicket, child: const Text("사용"));
  }
}
