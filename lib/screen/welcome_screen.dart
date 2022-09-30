import 'package:flutter/material.dart';
import 'package:meetqa/common/component/unit/custom_text_field.dart';
import 'package:meetqa/common/const/user_info.dart';
import 'package:meetqa/common/model/person_model.dart';
import 'package:meetqa/question/model/question_model.dart';
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
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
      child: Column(
        children: [
          Expanded(
              flex: 7,
              child: Image.asset(
                "assets/images/notice.png",
                fit: BoxFit.contain,
              )),
          Expanded(
            flex: 3,
            child: Form(
              key: formKey,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                      2,
                      (i) => InputUserInfo(
                          onPressed: () => onConrirmPressed(i),
                          confirm: confirm[i],
                          idx: i)),
                ),
              ),
            ),
          ),
          Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                      onPressed: confirm.every((confirm) => confirm == true)
                          ? () => onSavePressed()
                          : null,
                      child: const Text("저장")),
                ],
              ))
        ],
      ),
    ));
  }

  void onConrirmPressed(int i) {
    setState(() {
      confirm[i] = !confirm[i];
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

class InputUserInfo extends StatefulWidget {
  final VoidCallback onPressed;
  final bool confirm;
  final int idx;
  const InputUserInfo({
    Key? key,
    required this.onPressed,
    required this.confirm,
    required this.idx,
  }) : super(key: key);

  @override
  State<InputUserInfo> createState() => _InputUserInfoState();
}

class _InputUserInfoState extends State<InputUserInfo> {
  List<bool> genderSelect = [false, false];

  List<Widget> genderList = const [Icon(Icons.man), Icon(Icons.woman)];

  List<bool> isReady = [false, false];

  @override
  Widget build(BuildContext context) {
    int idx = widget.idx;
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: CustomTextField(
            label: "이름",
            initialValue: user[idx].name == '' ? userName : user[idx].name,
            maxLength: 8,
            textInputType: TextInputType.name,
            validatorMsg: "이름을 입력해주세요",
            confirm: widget.confirm,
            onSaved: (String? val) {
              user[idx] =
                  PersonModel(name: val!, gender: parseToEnum(genderSelect));
            },
            onChanged: !isReady[0]
                ? (value) {
                    setState(() {
                      isReady[0] = true;
                    });
                  }
                : (value) {
                    if (value == '') {
                      setState(() {
                        isReady[0] = false;
                      });
                    }
                  },
          ),
        ),
        const SizedBox(
          width: 12,
        ),
        Expanded(
          flex: 2,
          child: ToggleButtons(
            children: genderList,
            isSelected: genderSelect,
            onPressed: widget.confirm
                ? (idx) {}
                : (_idx) {
                    setState(() {
                      isReady[1] = true;
                      for (int i = 0; i < genderSelect.length; i++) {
                        genderSelect[i] = i == _idx;
                      }
                    });
                  },
          ),
        ),
        Expanded(
            flex: 1,
            child: TextButton(
              onPressed: isReady.every((ready) => ready == true)
                  ? widget.onPressed
                  : () {},
              child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    Text(
                      '확인',
                      style: TextStyle(
                          color: isReady.every((ready) => ready == true)
                              ? Colors.black
                              : Colors.grey.shade300),
                    ),
                    Positioned(
                        bottom: 1,
                        left: 1,
                        child: widget.confirm
                            ? const Icon(
                                Icons.check,
                                size: 35,
                                color: Colors.redAccent,
                              )
                            : Container()),
                  ]),
            )),
      ],
    );
  }

  Gender parseToEnum(List<bool> _gender) {
    if (_gender[0]) {
      return Gender.Male;
    } else if (_gender[1]) {
      return Gender.Female;
    } else {
      return Gender.Unselect;
    }
  }
}
