import 'package:flutter/material.dart';

class ReLoadButton extends StatelessWidget {
  final VoidCallback onPressed;
  final int limitNo;
  const ReLoadButton({
    Key? key,
    required this.onPressed,
    required this.limitNo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: waitCreate(),
        builder: ((context, snapshot) => Center(
              child: snapshot.connectionState == ConnectionState.done
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: limitNo > 0 ? onPressed : null,
                          child: const Text("다시 섞기"),
                        ),
                        Text("남은 횟수: $limitNo"),
                      ],
                    )
                  : Container(),
            )));
  }

  Future<void> waitCreate() async {
    await Future.delayed(const Duration(milliseconds: 1200));
  }
}
