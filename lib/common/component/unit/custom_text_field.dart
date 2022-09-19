import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final FormFieldSetter<String> onSaved;
  final String? initialValue;
  final String validatorMsg;
  final int maxLength;
  final TextInputType textInputType;
  const CustomTextField({
    Key? key,
    required this.label,
    required this.onSaved,
    this.initialValue,
    required this.validatorMsg,
    required this.maxLength,
    required this.textInputType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          renderTextFormField(),
        ],
      ),
    );
  }

  Widget renderTextFormField() {
    return TextFormField(
      onSaved: onSaved,
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
