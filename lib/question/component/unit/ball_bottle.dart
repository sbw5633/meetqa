import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meetqa/common/const/colors.dart';
import 'package:meetqa/question/component/unit/pingpong_ball.dart';
import 'package:meetqa/question/model/question_model.dart';

class BallBottle extends StatefulWidget {
  final String category;
  final List<QuestionModel> questions;
  final colors;
  final onTapBall;

  BallBottle({
    Key? key,
    required this.category,
    required this.colors,
    required this.questions,
    required this.onTapBall,
  }) : super(key: key);

  @override
  State<BallBottle> createState() => _BallBottleState();
}

class _BallBottleState extends State<BallBottle>
    with SingleTickerProviderStateMixin {
  late double _ranX;
  late double _ranY;

  late AnimationController _controller;
  late Animation _lightTranslateAnimation;

  late Offset _beginOffset;
  late Offset _endOffset;

  double _opacity = 0;

  int touchTextOpacityDuration = 500;

  bool offBalls = false;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 10))
          ..forward();

    // _endOffset = newMovePoint();
    // _beginOffset = Offset(_endOffset.dx * -1, _endOffset.dy);

    // _lightTranslateAnimation =
    //     Tween<Offset>(begin: _beginOffset, end: _endOffset)
    //         .animate(_controller);

    setLightPos();

    _opacity = 1;

    _controller.addListener(() {
      if (_controller.value >= 0.7 && _opacity == 1) {
        _opacity = 0;
      }
      if (_controller.value <= 0.5 && _opacity == 0) {
        _opacity = 1;
      }
    });

    _controller.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        await Future.delayed(Duration(seconds: 3));
        setLightPos();
        _controller.value = 0;
        _controller.forward();
      }
    });
  }

  void setLightPos() {
    _endOffset = newMovePoint();
    _beginOffset = Offset(_endOffset.dx * -1, _endOffset.dy);

    _lightTranslateAnimation =
        Tween<Offset>(begin: _beginOffset, end: _endOffset)
            .animate(_controller);
  }

  @override
  void dispose() {
    _controller.stop();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        child: Row(
          children: [
            Expanded(flex: 1, child: Container()),
            Expanded(
              flex: 3,
              child: Center(
                child: InkWell(
                  onTap: widget.onTapBall,
                  child: Stack(alignment: Alignment.center, children: [
                    Transform(
                        transform: Matrix4.identity()
                          ..rotateX(pi / 2.4)
                          ..setEntry(1, 3, 100),
                        alignment: FractionalOffset.center,
                        child: Container(
                            alignment: Alignment.center,
                            width: 230,
                            height: 230,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    Color.fromARGB(255, 92, 92, 92),
                                    PRIMARY_COLOR,
                                  ],
                                  stops: [0.4, 0.99],
                                )))),
                    Container(
                      alignment: Alignment.center,
                      height: 210,
                      width: 210,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(width: 1, color: Colors.white),
                        gradient: const RadialGradient(
                          colors: [Color(0xFF65BAFF), Colors.blue],
                          stops: [0.96, 1],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white,
                            spreadRadius: 18,
                            blurRadius: 58,
                          ),
                        ],
                      ),
                      child:
                          // 원 기울기(지구본기울기)
                          // Transform.rotate(
                          //   angle: getRadians(23.5),
                          //   child:
                          Container(
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                          gradient: RadialGradient(colors: [
                            Colors.white,
                            Color(0xFF9BD2FF),
                            Color(0xFF65BAFF)
                          ], stops: [
                            0.2,
                            0.7,
                            1
                          ]),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Stack(alignment: Alignment.center, children: [
                          offBalls
                              ? Container()
                              : Stack(
                                  children: List.generate(
                                      // 공 생성자
                                      widget.questions.length,
                                      (idx) => ballCreater(idx))),
                          AnimatedBuilder(
                            animation: _controller,
                            builder: (context, child) {
                              return Container(
                                // height: 200,
                                // width: 200,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: Transform.translate(
                                    offset: _lightTranslateAnimation.value,
                                    child: AnimatedOpacity(
                                      opacity: _opacity,
                                      duration: Duration(seconds: 3),
                                      child: Container(
                                        height: 8,
                                        width: 17,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.white
                                                      .withOpacity(0.5),
                                                  spreadRadius: 23,
                                                  blurRadius: 25)
                                            ]),
                                      ),
                                    )),
                              );
                            },
                          ),
                          StreamBuilder<double>(
                              stream: touchTextOpacityManager(),
                              builder: (context, snapshot) {
                                return AnimatedOpacity(
                                  opacity:
                                      snapshot.hasData ? snapshot.data! : 1,
                                  duration: Duration(
                                      milliseconds: touchTextOpacityDuration),
                                  child: Text(
                                    "Touch!",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w900,
                                        shadows: [
                                          Shadow(
                                              color: Colors.yellow,
                                              blurRadius: 2,
                                              offset: Offset(1, 2))
                                        ]),
                                  ),
                                );
                              })
                        ]),
                      ),
                      // ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ]),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Transform.translate(
                    offset: Offset(0, 60),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          offBalls = !offBalls;
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            color: offBalls
                                ? Color.fromARGB(255, 60, 60, 60)
                                    .withOpacity(0.7)
                                : Color.fromARGB(255, 0, 137, 206),
                            borderRadius: BorderRadius.circular(15)),
                        child: Stack(children: [
                          Center(
                            child: Icon(
                              Icons.sports_baseball,
                              color: Colors.amberAccent,
                            ),
                          ),
                          Center(
                            child: Icon(
                              Icons.cancel_outlined,
                              color: !offBalls
                                  ? Colors.white.withOpacity(0)
                                  : Colors.black.withOpacity(0.7),
                              size: 50,
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ),
                  Text("ver: ${Hive.box("DataVersion").get(widget.category)}")
                ],
              ),
            ),
          ],
        ));
  }

  Stream<double> touchTextOpacityManager() async* {
    int i = 0;
    while (i < 100) {
      yield i++ % 2;
      await Future.delayed(Duration(milliseconds: touchTextOpacityDuration));
    }
  }

  //공 만들기
  Widget ballCreater(int idx) {
    return PingPongBall(
      getDistance: getDistance,
      newMovePoint: newMovePoint,
      color: widget.colors[idx],
      idx: idx,
    );

    // RotateBall(
    //   getDistance: getDistance,
    //   newMovePoint: newMovePoint,
    //   color: widget.colors[idx],
    //   idx: idx,
    // );
  }

  Offset newMovePoint() {
    do {
      _ranX = 100 - Random().nextDouble() * 200;
    } while (_ranX <= 30 && _ranX >= -30);
    int _z = Random().nextBool() ? 1 : -1;
    double _powRanX = _ranX * _ranX;
    _ranY = _powRanX >= 10000
        ? sqrt((_powRanX) - 10000) * _z
        : sqrt(10000 - (_powRanX)) * _z;

    return Offset(_ranX, _ranY);

    //x^2 + y^2 = r^2 ,      r==1;

    //y2 = 1 - x2
  }

  Duration getDistance(Offset _begin, Offset _end) {
    double disX = _end.dx - _begin.dx;
    double disY = _end.dy - _begin.dy;

    double dis = sqrt(pow(disX, 2) + pow(disY, 2));

    // dis/100 = 1second = 1000milliseconds
    // (dis / 100) * 1000 == dis * 10

    Duration bToeDis = Duration(milliseconds: (dis * 10).round());

    return bToeDis;
  }

  double getRadians(double degree) {
    double radians = degree * pi / 180;

    return radians;
  }
}
