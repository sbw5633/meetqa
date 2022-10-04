import 'package:flutter/material.dart';
import 'package:flutter_keyboard_size/flutter_keyboard_size.dart';
import 'package:meetqa/common/component/unit/custom_text_field.dart';
import 'package:meetqa/common/const/user_info.dart';
import 'package:meetqa/common/model/person_model.dart';
import 'package:meetqa/question/model/question_model.dart';
import 'package:meetqa/screen/component/welcome_screen/input_user_info.dart';
import 'package:meetqa/screen/home_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final GlobalKey<FormState> formKey = GlobalKey();

  List<bool> confirm = [false, false];

  List<QuestionModel> questions = [];

  String initName = '';

  final ScrollController _scrollController = ScrollController();

  final TextStyle labelTs =
      TextStyle(fontSize: 12, fontWeight: FontWeight.bold);

  final AppBar _appBar = AppBar(
    backgroundColor: Colors.white,
    title: Image.asset('assets/images/logo/appbar_logo.png'),
  );

  @override
  void initState() {
    createUserData();

    super.initState();
  }

  void createUserData() {
    for (int i = 0; i < 2; i++) {
      user.add(PersonModel(name: '', gender: Gender.Unselect));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (initName == "" && nowUser != null) initName = nowUser!.userName!;

    return SafeArea(
      child: KeyboardSizeProvider(
        child: Scaffold(
            appBar: _appBar,
            body: GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Consumer<ScreenHeight>(builder: (context, _res, child) {
                  if (_res.isOpen) {
                    _scrollController.jumpTo(_res.keyboardHeight);
                  }
                  return SizedBox(
                    height: MediaQuery.of(context).size.height -
                        _appBar.preferredSize.height,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(flex: 6, child: _partNotice()),
                          Expanded(
                            flex: 3,
                            child: Column(
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: _partInput(),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: ElevatedButton(
                                      onPressed: confirm.every(
                                              (confirm) => confirm == true)
                                          ? () => onSavePressed()
                                          : null,
                                      child: const Text("저장")),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(),
                            flex: 1,
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            )),
      ),
    );
  }

  Widget _partNotice() {
    return Image.asset(
      "assets/images/text_img/notice.png",
      fit: BoxFit.contain,
    );
  }

  Widget _partInput() {
    return Form(
      key: formKey,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    flex: 2,
                    child: Text(
                      "이름을 입력해주세요.",
                      style: labelTs,
                    )),
                SizedBox(
                  width: 56,
                ),
                Expanded(
                    flex: 1,
                    child: Text(
                      "성별을 선택해주세요.",
                      style: labelTs,
                    )),
              ],
            ),
            SizedBox(
              height: 6,
            ),
            Column(
              children: List.generate(
                  2, (i) => InputUserInfo(isConfirmed: isConfirmed, idx: i)),
            ),
          ],
        ),
      ),
    );
  }

  void isConfirmed(int i, bool check) {
    setState(() {
      confirm[i] = check;
    });
  }

  void onSavePressed() {
    if (formKey.currentState == null) {
      return;
    }
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => HomeScreen()));
    }
  }
}
