import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final FormFieldSetter<String> onSaved;
  final ValueChanged onChanged;
  final String? initialValue;
  final String validatorMsg;
  final int maxLength;
  final TextInputType textInputType;
  final confirm;
  const CustomTextField({
    Key? key,
    required this.label,
    required this.onSaved,
    required this.onChanged,
    this.initialValue,
    required this.validatorMsg,
    required this.maxLength,
    required this.textInputType,
    required this.confirm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        renderTextFormField(),
      ],
    );
  }

  Widget renderTextFormField() {
    return TextFormField(
      readOnly: confirm,
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
