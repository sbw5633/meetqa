import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meetqa/common/component/unit/custom_text_field.dart';
import 'package:meetqa/common/const/user_id.dart';
import 'package:meetqa/question/data/data_manager.dart';
import 'package:meetqa/question/model/category_card_model.dart';
import 'package:meetqa/question/model/question_model.dart';
import 'package:meetqa/screen/game_screen.dart';
import 'package:meetqa/common/manager/firebase_manager.dart';

class DataLoadScreen extends StatefulWidget {
  final CategoryCardModel cateModel;
  const DataLoadScreen({Key? key, required this.cateModel}) : super(key: key);

  @override
  State<DataLoadScreen> createState() => _DataLoadScreenState();
}

class _DataLoadScreenState extends State<DataLoadScreen> {
  static String? name1;
  static String? name2;
  final GlobalKey<FormState> formKey = GlobalKey();
  bool loading = true;
  List<QuestionModel> questions = [];

  Future<bool> fetchData() async {
    await DataManager().getDataFlow();

    loading = false;
    return loading;
  }

  @override
  void initState() {
    super.initState();
    loading = true;
  }

  @override
  Widget build(BuildContext context) {
    if (name1 == null && nowUser != null) name1 = nowUser!.userName;
    return FutureBuilder(
        future: fetchData(),
        builder: (context, AsyncSnapshot<bool> snapshot) {
          if (!snapshot.hasData &&
              snapshot.connectionState == ConnectionState.none) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Scaffold(
              body: Form(
                key: formKey,
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomTextField(
                      label: "내 이름",
                      initialValue: name1 ?? userName,
                      maxLength: 8,
                      textInputType: TextInputType.name,
                      validatorMsg: "이름을 입력해주세요",
                      onSaved: (String? val) {
                        name1 = val!;
                      },
                    ),
                    CustomTextField(
                      label: "상대방 이름",
                      initialValue: name2,
                      maxLength: 8,
                      textInputType: TextInputType.name,
                      validatorMsg: "이름을 입력해주세요",
                      onSaved: (String? val) {
                        name2 = val!;
                      },
                    ),
                    ElevatedButton(
                        onPressed: snapshot.data == null
                            ? null
                            : () => onSavePressed(),
                        child: const Text("저장"))
                  ],
                )),
              ),
            );
          }
        });
  }

  void onSavePressed() {
    if (formKey.currentState == null) {
      return;
    }
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      if (!loading) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (_) => GameScreen(
                  me: name1!,
                  you: name2!,
                  category: widget.cateModel.category,
                  questions: questions,
                )));
      }
    }
  }
}
