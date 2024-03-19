import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomFilledTextField extends StatelessWidget {
  late TextEditingController? controller = TextEditingController();
  final String hintText;
  final void Function(String)? onChanged;
  final int? maxLines;
  final int? minLines;

  CustomFilledTextField({
    super.key,
    this.controller,
    this.onChanged,
    this.hintText = '',
    this.maxLines = 1,
    this.minLines,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      minLines: minLines,
      maxLines: maxLines,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
        hintText: hintText,
        hintStyle: const TextStyle(fontSize: 14),
        filled: true,
      ),
    );
  }
}
