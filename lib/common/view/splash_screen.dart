import 'package:flutter/material.dart';
import 'package:meetqa/common/layout/default_layout.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      backgroundColor: Colors.white,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Image.asset(
          'assets/images/diamond.png',
          width: MediaQuery.of(context).size.width * 0.7,
        ),
        SizedBox(
          height: 16,
        ),
        CircularProgressIndicator(),
      ]),
    );
  }
}
