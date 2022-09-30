import 'package:flutter/material.dart';
import 'package:meetqa/common/component/flutter_toast.dart';
import 'package:meetqa/common/const/user_info.dart';
import 'package:meetqa/common/manager/sign_manager.dart';

class HomeAppBar extends StatefulWidget {
  final isExpanded;
  final isLoaded;
  const HomeAppBar({
    Key? key,
    required this.isExpanded,
    required this.isLoaded,
  }) : super(key: key);

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar> {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      flexibleSpace: Stack(children: [
        Image.asset(
          "assets/images/logo/logo_bgcolor.png",
          fit: BoxFit.cover,
          height: double.infinity,
          width: double.infinity,
        ),
        FlexibleSpaceBar(
          background: SafeArea(
            child: Container(
              margin: const EdgeInsets.only(top: kToolbarHeight),
              child: titleLogo(),
            ),
          ),
        ),
      ]),
      expandedHeight: 400,
      floating: true,
      pinned: true,
      stretch: true,
      title: widget.isExpanded ? null : Center(child: titleLogo()),
      actions: [
        if (nowUser == null && widget.isLoaded == true)
          InkWell(
            onTap: () async {
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
            child: Container(
              alignment: Alignment.center,
              height: 50,
              width: 80,
              child: const Text(
                "로그인",
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
            ),
          )
      ],
    );
  }

  Widget titleLogo() {
    if (widget.isExpanded) {
      return Image.asset(
        "assets/images/logo/logo_v.png",
      );
    } else {
      return Image.asset(
        "assets/images/logo/logo_h.png",
        width: 200,
        height: 200,
      );
    }
  }
}
