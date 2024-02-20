import 'package:assingment/widget/style.dart';
import 'package:flutter/material.dart';

class LongTextField extends StatefulWidget {
  final TextEditingController controller;
  const LongTextField({super.key, required this.controller});

  @override
  State<LongTextField> createState() => _LongTextFieldState();
}

class _LongTextFieldState extends State<LongTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 30,
        child: TextFormField(
          controller: widget.controller,
          decoration: const InputDecoration(
              contentPadding: EdgeInsets.only(top: 0, bottom: 0, left: 5)),
          style: const TextStyle(fontSize: 15),
        ));
  }
}
