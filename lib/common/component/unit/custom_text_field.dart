import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final FormFieldSetter<String> onSaved;
  final ValueChanged onChanged;
  final String? initialValue;
  final String validatorMsg;
  final int maxLength;
  final TextInputType textInputType;
  const CustomTextField({
    Key? key,
    required this.onSaved,
    required this.onChanged,
    this.initialValue,
    required this.validatorMsg,
    required this.maxLength,
    required this.textInputType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onSaved: onSaved,
      onChanged: onChanged,
      validator: (String? val) {
        if (val == null || val.isEmpty) {
          return validatorMsg;
        }
        return null;
      },
      initialValue: initialValue,
      maxLength: maxLength,
      keyboardType: textInputType,
      decoration: InputDecoration(
        border: InputBorder.none,
        filled: true,
        fillColor: Color.fromARGB(255, 229, 229, 229),
        counterText: '',
      ),
    );
  }
  // child: Column(
  //   children: [
  //     Text(
  //       label,
  //       style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
  //     ),
  //     renderTextFormField(),
  //   ],
  // ),

  Widget renderTextFormField() {
    return TextFormField(
      onSaved: onSaved,
      onChanged: onChanged,
      validator: (String? val) {
        if (val == null || val.isEmpty) {
          return validatorMsg;
        }
        return null;
      },
      initialValue: initialValue,
      maxLength: maxLength,
      keyboardType: textInputType,
      decoration: InputDecoration(
        border: InputBorder.none,
        filled: true,
        fillColor: Color.fromARGB(255, 229, 229, 229),
      ),
    );
  }
}
