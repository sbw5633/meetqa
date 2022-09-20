import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meetqa/question/model/question_model.dart';

class FirebaseManager {
  //db에서 데이터 받아오기
  static Future<List<QuestionModel>> getDataFromFirebaseDB(
      String category) async {
    // question데이터 받아오기
    final db = await FirebaseFirestore.instance
        .collection('Datas/QuestionDatas/[${category}]_questions')
        .get();

    List<QuestionModel> questions = [];

    for (final question in db.docs) {
      QuestionModel questionModel =
          QuestionModel.fromJSON(json: question.data());
      questions.add(questionModel);
    }

    return questions;
  }
}
