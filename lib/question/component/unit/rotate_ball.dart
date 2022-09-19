import 'package:flutter/material.dart';

class RotateBall extends StatefulWidget {
  final getDistance;
  final newMovePoint;
  final color;
  final idx;
  const RotateBall({
    Key? key,
    required this.getDistance,
    required this.newMovePoint,
    required this.color,
    required this.idx,
  }) : super(key: key);

  @override
  State<RotateBall> createState() => _RotateBallState();
}

class _RotateBallState extends State<RotateBall>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _translateAnimation;
  late Animation _scaleAnimation;
  double _ballOpacity = 0;
  late Offset _beginOffset;
  late Offset _midOffset;
  late Offset _endOffset;

  late Gradient color;

  bool frontMove = false;
  bool toMid = true;

  @override
  void initState() {
    super.initState();

    //처음,중간,끝 지점 offset
    _beginOffset = widget.newMovePoint();
    _midOffset = Offset(0, _beginOffset.dy);
    _endOffset = Offset(_beginOffset.dx * -1, _beginOffset.dy);

    _controller = AnimationController(
        vsync: this, duration: widget.getDistance(_beginOffset, _endOffset));

    Future.delayed(Duration(milliseconds: widget.idx * 500), () {
      _controller.forward();
    });

    //중간지점까지 이동
    _translateAnimation = Tween<Offset>(begin: _beginOffset, end: _midOffset)
        .animate(_controller);

    //중간지점까지 scale.
    _scaleAnimation = Tween<double>(begin: 0, end: 0.3)
        .animate(_controller)
        .drive(CurveTween(curve: Curves.linear));

    //최초: 뒤편, 중앙(우->좌)으로 진행 후 변경될 값 : 뒤편, 중앙->좌측
    frontMove = false;
    toMid = false;

    _ballOpacity = changeOpacity();

    //listener에서 지속적으로 상태값을 변경할 수 있도록 함.
    _controller.addStatusListener((status) {
      if (_controller.status == AnimationStatus.completed) {
        _ballOpacity = changeOpacity();
        _translateAnimation = transManager();
        _scaleAnimation = scaleManager();
        _controller.value = 0;
        _controller.forward();
      }
    });

    color = widget.color;
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
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: color,
        ),
        height: 10,
        width: 10,
      ),
      builder: (context, child) {
        return Transform.translate(
            offset: _translateAnimation.value,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: AnimatedOpacity(
                opacity: _ballOpacity,
                duration: Duration(milliseconds: 1000),
                child: child,
              ),
            ));
      },
    );
  }

  Animation scaleManager() {
    double _s = 0.3;
    double _m = 0.7;
    double _l = 1.0;
    double _begin;
    double _end;

    if (frontMove) {
      if (toMid) {
        //앞쪽, 중앙으로
        _begin = _m;
        _end = _l;
        toMid = false;
        frontMove = true;
      } else {
        //앞쪽, 끝으로
        _begin = _l;
        _end = _m;
        toMid = true;
        frontMove = false;
      }
    } else {
      if (toMid) {
        //뒤쪽, 중앙으로
        _begin = _m;
        _end = _s;
        toMid = false;
        frontMove = false;
      } else {
        //뒤쪽, 끝으로
        _begin = _s;
        _end = _m;
        toMid = true;
        frontMove = true;
      }
    }

    return Tween<double>(begin: _begin, end: _end)
        .animate(_controller)
        .drive(CurveTween(curve: Curves.linear));
  }

  Animation transManager() {
    Offset start;
    Offset arive;
    if (frontMove) {
      if (toMid) {
        //앞쪽, 중앙으로
        start = _endOffset;
        arive = _midOffset;
      } else {
        //앞쪽, 끝지점(우측)으로
        start = _midOffset;
        arive = _beginOffset;
      }
    } else {
      if (toMid) {
        //뒤쪽, 중앙으로
        start = _beginOffset;
        arive = _midOffset;
      } else {
        //뒤쪽, 끝지점(좌측)으로
        start = _midOffset;
        arive = _endOffset;
      }
    }

    return Tween<Offset>(begin: start, end: arive).animate(_controller);
  }

  double changeOpacity() {
    if (frontMove) {
      return 1.0;
    } else {
      return 0.5;
    }
  }
}
