import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:meetqa/common/component/unit/chance_paper.dart';
import 'package:meetqa/common/const/colors.dart';

class ChanceCard extends StatefulWidget {
  const ChanceCard({Key? key}) : super(key: key);

  @override
  State<ChanceCard> createState() => _ChanceCardState();
}

class _ChanceCardState extends State<ChanceCard> {
  List<Gradient> gColors = rainbowColors;

  HashSet<int> randomNo = HashSet();

  int numberOfChances = 7;

  @override
  Widget build(BuildContext context) {
    while (randomNo.length < numberOfChances) {
      randomNo.add(Random().nextInt(gColors.length));
    }

    List<int> randNo = randomNo.toList();

    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.6,
        child: Stack(children: [
          Stack(
              children: List.generate(numberOfChances,
                  (index) => renderChancePaper(index, randNo[index]))),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                height: 200,
                // width: MediaQuery.of(context).size.width * 0.9,
                color: Colors.black,
              ),
            ),
          )
        ]),
      ),
    );
  }

  Widget renderChancePaper(int index, int no) {
    return Positioned(
        left: index * 50, child: ChancePaper(index: index, color: gColors[no]));
  }
}
