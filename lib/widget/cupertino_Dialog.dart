import 'package:assingment/widget/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

showDial(BuildContext context) {
  showCupertinoDialog(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      content: SizedBox(
        height: 50,
        width: 50,
        child: Center(
          child: CircularProgressIndicator(
            color: blue,
          ),
        ),
      ),
    ),
  );
}
