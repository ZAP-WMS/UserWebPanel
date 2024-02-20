import 'package:assingment/widget/style.dart';
import 'package:flutter/material.dart';

class CustomCivilTextField extends StatefulWidget {
  final TextEditingController controller;
  String? title;
  CustomCivilTextField(
      {super.key, required this.controller, required this.title});

  @override
  State<CustomCivilTextField> createState() => _CustomCivilTextFieldState();
}

class _CustomCivilTextFieldState extends State<CustomCivilTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(color: lightblue),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  color: lightblue,
                  width: 600,
                  padding: const EdgeInsets.all(3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(width: 150, child: Text('${widget.title}')),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Container(
                            height: 30,
                            child: TextFormField(
                              controller: widget.controller,
                              decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.only(
                                      top: 0, bottom: 0, left: 5)),
                              style: const TextStyle(fontSize: 15),
                            )),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
