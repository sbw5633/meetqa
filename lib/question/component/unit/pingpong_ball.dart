import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class PingPongBall extends StatefulWidget {
  final getDistance;
  final newMovePoint;
  final color;
  final idx;
  const PingPongBall({
    Key? key,
    required this.getDistance,
    required this.newMovePoint,
    required this.color,
    required this.idx,
  }) : super(key: key);

  @override
  State<PingPongBall> createState() => _PingPongBallState();
}

class _PingPongBallState extends State<PingPongBall>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;
  late Offset _beginOffset;
  late Offset _endOffset;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 1000))
          ..forward();

    _beginOffset = Offset(_controller.value, _controller.value);
    _endOffset = widget.newMovePoint();
    _animation = Tween<Offset>(begin: _beginOffset, end: _endOffset)
        .animate(_controller);
    widget.getDistance(_beginOffset, _endOffset);

    //listener에서 지속적으로 상태값을 변경할 수 있도록 함.

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        //시작점, 도착점 재지정
        _beginOffset = _endOffset;
        _endOffset = widget.newMovePoint();

        //시작점-도착점 위치값을 기반으로 속도(시간) 재계산
        _controller.duration = widget.getDistance(_beginOffset, _endOffset);

        //애니메이션 실행
        _animation = Tween<Offset>(begin: _beginOffset, end: _endOffset)
            .animate(_controller);
        _controller.value = 0;
        _controller.forward();
      }
    });

    //한 방향으로 갔다가 돌아오는 애니메이션
    // _controller.addListener(() {
    //   if (_controller.value >= 0.85) {
    //     _controller.reverse();
    //   } else if (_controller.value <= 0) {
    //     //시작점, 도착점 재지정
    //     _beginOffset = Offset(0, 0);
    //     _endOffset = widget.newMovePoint();

    //     //시작점-도착점 위치값을 기반으로 속도(시간) 재계산
    //     _controller.duration = widget.getDistance(_beginOffset, _endOffset);

    //     //애니메이션 실행
    //     _animation = Tween<Offset>(begin: _beginOffset, end: _endOffset)
    //         .animate(_controller);
    //     // _controller.value = 0;
    //     _controller.forward();
    //   }
    // });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      child: Container(
        decoration:
            BoxDecoration(gradient: widget.color, shape: BoxShape.circle),
        height: 10,
        width: 10,
      ),
      builder: (context, child) {
        return Transform.translate(
          offset: _animation.value,
          child: child,
        );
      },
    );
  }
}
