import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DateInputFormatter extends TextInputFormatter {
  final RegExp _regExp;

  DateInputFormatter(this._regExp);


  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final newText = newValue.text;

    if (_regExp.hasMatch(newText)) {
      return newValue;
    }

    return oldValue;
  }
}
