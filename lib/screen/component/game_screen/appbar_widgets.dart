import 'package:flutter/material.dart';
import 'package:meetqa/common/component/flutter_toast.dart';
import 'package:meetqa/common/const/path.dart';
import 'package:meetqa/common/const/user_info.dart';
import 'package:meetqa/common/manager/sign_manager.dart';

class CustomAppBar extends StatefulWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  State<CustomAppBar> createState() => CustomAppBarState();

  static CustomAppBarState? of(BuildContext context) =>
      context.findAncestorStateOfType<CustomAppBarState>();
}

class CustomAppBarState extends State<CustomAppBar> {
  String _string = "please input text";

  set string(String value) => setState(() => _string = value);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 1, child: DefaultAppBarBox(part: _partLeading())),
        Expanded(flex: 2, child: DefaultAppBarBox(part: _partTitle())),
        Expanded(flex: 1, child: DefaultAppBarBox(part: _partAction())),
        // Text(_string),
      ],
    );
  }

  void isReflesh() {
    print("join");
    setState(() {
      print("setState Appbar");
    });
  }

  Widget _partAction() {
    return nowUser == null
        ? OutlinedButton(
            onPressed: () async {
              try {
                await SignManager().signIn();
                if (currentUser != null) {
                  setState(() {});
                } else {
                  flutterToast("로그인에 실패했습니다.");
                }
              } catch (e) {
                flutterToast("로그인에 실패했습니다.");
              }
            },
            child: defaultActionPart(SIGNIN_ICON, "로그인"))
        : OutlinedButton(
            onPressed: () async {
              await SignManager().signOut();
              setState(() {});
            },
            child: defaultActionPart(EXIT_ICON, "로그아웃"));
  }

  Widget defaultActionPart(String iconPath, String text) {
    TextStyle _ts = TextStyle(color: Colors.black, fontSize: 16);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(iconPath),
        SizedBox(
          width: 8,
        ),
        Text(
          text,
          style: _ts,
        ),
      ],
    );
  }

  Widget _partLeading() {
    return InkWell(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.home,
              size: 30,
            ),
            SizedBox(
              width: 8,
            ),
            Text("홈"),
          ],
        ));
  }

  Widget _partTitle() {
    return Image.asset(
      LOGO_H,
      fit: BoxFit.contain,
      // width: MediaQuery.of(context).size.width * 0.5,
    );
  }
}

class DefaultAppBarBox extends StatelessWidget {
  final Widget part;

  const DefaultAppBarBox({Key? key, required this.part}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BoxDecoration _boxDeco = BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)));

    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: _boxDeco,
      child: part,
    );
  }
}
