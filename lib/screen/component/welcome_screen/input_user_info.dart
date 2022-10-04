import 'package:flutter/material.dart';
import 'package:meetqa/common/component/unit/custom_text_field.dart';
import 'package:meetqa/common/const/user_info.dart';
import 'package:meetqa/common/model/person_model.dart';

class InputUserInfo extends StatefulWidget {
  final Function isConfirmed;
  final int idx;
  const InputUserInfo({
    Key? key,
    required this.isConfirmed,
    required this.idx,
  }) : super(key: key);

  @override
  State<InputUserInfo> createState() => _InputUserInfoState();
}

class _InputUserInfoState extends State<InputUserInfo> {
  List<bool> genderSelect = [false, false];

  List<Widget> genderList = const [Icon(Icons.man), Icon(Icons.woman)];

  List<bool> isReady = [true, false];

  @override
  Widget build(BuildContext context) {
    int idx = widget.idx;
    String initName;
    if (idx == 0) {
      if (user[idx].name == '' && nowUser?.userName != null) {
        initName = nowUser!.userName!;
      } else {
        initName = initName1;
      }
    } else {
      user[idx].name == '' ? initName = initName2 : initName = user[idx].name;
    }
    return Padding(
      padding: idx == 0 ? const EdgeInsets.only(bottom: 16.0) : EdgeInsets.zero,
      child: Center(
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: CustomTextField(
                initialValue: initName,
                maxLength: 8,
                textInputType: TextInputType.name,
                validatorMsg: "이름을 입력해주세요",
                onSaved: (String? val) {
                  user[idx] = PersonModel(
                      name: val!, gender: parseToEnum(genderSelect));
                },
                onChanged: !isReady[0]
                    ? (value) {
                        setState(() {
                          isReady[0] = true;
                        });
                        checkIsReady();
                      }
                    : (value) {
                        if (value == '') {
                          setState(() {
                            isReady[0] = false;
                          });
                        }
                        checkIsReady();
                      },
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: ToggleButtons(
                  children: genderList,
                  isSelected: genderSelect,
                  onPressed: (_idx) {
                    setState(() {
                      isReady[1] = true;
                      for (int i = 0; i < genderSelect.length; i++) {
                        genderSelect[i] = i == _idx;
                      }
                      checkIsReady();
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void checkIsReady() {
    if (isReady.every((ready) => ready == true)) {
      widget.isConfirmed(widget.idx, true);
    } else {
      widget.isConfirmed(widget.idx, false);
    }
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
