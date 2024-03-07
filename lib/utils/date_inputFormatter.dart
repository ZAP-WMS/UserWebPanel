import 'package:flutter/services.dart';

class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;
    var buffer = StringBuffer();
    int count = 0;

    for (var i = 0; i < text.length; i++) {
      if (count < 2 && text[i] != '/') {
        buffer.write(text[i]);
        count++;
      } else if (count == 2 && text[i] != '/') {
        buffer.write('/');
        buffer.write(text[i]);
        count = 1;
      }
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}
