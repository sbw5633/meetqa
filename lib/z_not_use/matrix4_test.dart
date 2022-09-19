import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Matrix4Test extends StatefulWidget {
  const Matrix4Test({Key? key}) : super(key: key);

  @override
  State<Matrix4Test> createState() => _Matrix4TestState();
}

class _Matrix4TestState extends State<Matrix4Test>
    with SingleTickerProviderStateMixin {
  Offset _offset = Offset.zero;

  @override
  void initState() {
    super.initState();
  }

  Stream<int> rotateController() async* {
    for (int i = 0; i < 100; i++) {
      yield i;
      await Future.delayed(Duration(milliseconds: 100));
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: StreamBuilder<int>(
              stream: rotateController(),
              builder: (context, snapshot) {
                print("snapshot: ${snapshot.data}");
                if (snapshot.hasData) {
                  _offset = Offset(_offset.dx + snapshot.data!, _offset.dy);
                }
                return Transform(
                    transform: Matrix4.identity()
                      ..setEntry(3, 3, 0.5)
                      ..setEntry(3, 2, 0.001)
                      ..rotateX(0.01 * _offset.dy)
                      ..rotateY(-0.01 * _offset.dx),
                    alignment: FractionalOffset.center,
                    child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.black,
                        )));
              })),
    );
  }
}
