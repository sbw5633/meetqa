import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meetqa/question/model/question_model.dart';

class DataManager {
  late Excel excel;

  final checkBox = Hive.box("DataVersion");

  Future<void> getDataFlow() async {
    excel = await getExcelDatas(); //엑셀 데이터 통째로 저장

    for (String table in excel.tables.keys) {
      //cate(table)별로 쪼개서 버전 확인 및 로컬에 저장

      await setDatasToLocal(cate: table);
    }
  }

  Future<void> setDatasToLocal({required String cate}) async {
    List<QuestionModel> questions = [];

    String _ver = "";

    for (int i = 0; i < excel.tables[cate]!.rows.length; i++) {
      if (i == 0) {
        _ver = excel.tables[cate]!.rows[i][1]!.value.toString();

        debugPrint("받아온 엑셀(cate: $cate)버전: $_ver");
        debugPrint("하이브데이터 Version: ${checkBox.get(cate)}");

        if (checkBox.values.isNotEmpty && checkBox.get(cate) == _ver) {
          return;
        }
        print("데이터 받ㅇ아오기: $cate");
      } else if (i > 1) {
        //실 데이터는 3행부터 있으므로 i=2부터 시작.
        var row = excel.tables[cate]!.rows[i];
        List<dynamic> tempData = [];
        List<String?> tempTag = [];
        for (int j = 0; j < row.length; j++) {
          if (j < 4) {
            tempData.add(row[j]!.value);
          } else {
            if (row[j]?.value != null) {
              tempTag.add(row[j]!.value);
            }
          }
        }
        QuestionModel question = QuestionModel(
          index: tempData[0],
          theme: tempData[1],
          deep: tempData[2],
          asking: tempData[3],
          tag: tempTag,
        );

        questions.add(question);
      }
    }

    ///.................................///
    ///     save Data to Local(Hive)    ///
    ///.................................///

    final box = Hive.box<QuestionModel>("Question_$cate");

    for (QuestionModel question in questions) {
      box.put(question.index, question);
    }

    Hive.box("DataVersion").put(cate, _ver);

    debugPrint(
        "success input data to Hive: ${Hive.box<QuestionModel>("Question_$cate")}");
  }

  Future<Excel> getExcelDatas() async {
    var file = await rootBundle.load("assets/data/asking_data.xlsx");
    var bytes = file.buffer.asUint8List(file.offsetInBytes, file.lengthInBytes);
    var _excel = Excel.decodeBytes(bytes);

    return _excel;
  }
}
