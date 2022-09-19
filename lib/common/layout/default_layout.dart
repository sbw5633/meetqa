import 'package:flutter/material.dart';
import 'package:meetqa/common/const/colors.dart';

class DefaultLayout extends StatelessWidget {
  final String? title;
  final BottomNavigationBar? bottomNavigationBar;
  final Widget child;
  final bool isDark;
  final Color? backgroundColor;

  const DefaultLayout({
    Key? key,
    this.title,
    this.bottomNavigationBar,
    required this.child,
    this.isDark = false,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color PRIMARY_COLOR = isDark ? PRIMARY_COLOR_DARK : PRIMARY_COLOR_LIGHT;

    return Scaffold(
      backgroundColor: backgroundColor ?? PRIMARY_COLOR,
      appBar: renderAppBar(),
      body: child,
      bottomNavigationBar: bottomNavigationBar,
    );
  }

  AppBar? renderAppBar() {
    if (title == null) {
      return null;
    } else {
      return AppBar(
        backgroundColor: isDark ? Colors.black : Colors.white,
        elevation: 0,
        title: Text(
          title!,
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w500, color: TEXT_COLOR),
        ),
        foregroundColor: Colors.black,
      );
    }
  }
}
