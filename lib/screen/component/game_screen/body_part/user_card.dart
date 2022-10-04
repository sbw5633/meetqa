import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meetqa/common/const/path.dart';
import 'package:meetqa/common/model/person_model.dart';

class UserCard extends StatelessWidget {
  final PersonModel user;
  final bool isAsker;
  const UserCard({
    Key? key,
    required this.user,
    required this.isAsker,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double cardSize = MediaQuery.of(context).size.width * 0.35;

    TextStyle nameTs =
        TextStyle(fontSize: cardSize * 0.15, fontWeight: FontWeight.bold);

    return Column(
      children: [
        Stack(
          children: [
            CardContainer(
                isAsker: isAsker,
                cardSize: cardSize,
                child: AnimatedCard(
                  gender: user.gender,
                  isAsker: isAsker,
                )),
            if (!isAsker)
              CardContainer(
                  isAsker: isAsker,
                  cardSize: cardSize,
                  color: Colors.black.withOpacity(0.3))
          ],
        ),
        SizedBox(
          height: 12,
        ),
        Container(
          width: cardSize,
          height: cardSize * 0.3,
          decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Center(
              child: Text(
            user.name,
            style: nameTs,
          )),
        )
      ],
    );
  }
}

class AnimatedCard extends StatefulWidget {
  final Gender gender;
  final bool isAsker;
  const AnimatedCard({
    Key? key,
    required this.gender,
    required this.isAsker,
  }) : super(key: key);

  @override
  State<AnimatedCard> createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<AnimatedCard> {
  int opacityDuration = 1000;
  Color accentBorderColor = Colors.red.shade300;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Image.asset(
              widget.gender == Gender.Female ? WOMAN_CHARACTER : MAN_CHARACTER,
              fit: BoxFit.contain),
        ),
        if (widget.isAsker)
          StreamBuilder<double>(
              stream: opacityManager(),
              builder: (context, snapshot) {
                return AnimatedOpacity(
                    opacity: snapshot.hasData ? snapshot.data! : 0.8,
                    duration: Duration(milliseconds: opacityDuration),
                    child: Container(
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: accentBorderColor, width: 5),
                          borderRadius: BorderRadius.circular(10)),
                    ));
              }),
      ],
    );
  }

  Stream<double> opacityManager() async* {
    int i = 0;
    while (i < 500) {
      yield (i++ % 2 + 1) * 0.4;
      await Future.delayed(Duration(milliseconds: opacityDuration));
    }
  }
}

class CardContainer extends StatelessWidget {
  final Widget? child;
  final Color? color;
  final double cardSize;
  final bool isAsker;

  CardContainer({
    Key? key,
    required this.cardSize,
    required this.isAsker,
    this.color,
    this.child,
  }) : super(key: key);

  BoxDecoration isAskerDeco = BoxDecoration(
      border: Border.all(color: Color(0xFF002150), width: 1),
      borderRadius: const BorderRadius.all(Radius.circular(10)));

  @override
  Widget build(BuildContext context) {
    return Container(
        width: cardSize,
        height: cardSize,
        decoration: isAsker
            ? isAskerDeco
            : isAskerDeco.copyWith(border: Border.all(), color: color),
        child: child);
  }
}
