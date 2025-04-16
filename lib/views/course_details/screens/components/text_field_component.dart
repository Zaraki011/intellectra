import 'package:flutter/material.dart';

class TextFieldComponent extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? Function(String?)? validator;
  final int maxLines;
  final TextInputType keyboardType;

  const TextFieldComponent({
    super.key,
    required this.controller,
    required this.labelText,
    this.validator,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(),
          // You can add more decoration like hintText, errorStyle etc.
        ),
        validator: validator,
        maxLines: maxLines,
        keyboardType: keyboardType,
      ),
    );
  }
}
