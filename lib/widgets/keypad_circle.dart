import 'package:flutter/material.dart';
import 'package:wyrrdemo/utils/app_color.dart';

class KeypadCircle extends StatelessWidget {
  final int number;
  final TextEditingController controller;
  const KeypadCircle({Key? key, required this.number, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        controller.text += number.toString();
      },
      child: Container(
        height: 70,
        width: 70,
        child: Center(
          child: Text(
            number.toString(),
            style: TextStyle(fontSize: 23),
          ),
        ),
        decoration:
            BoxDecoration(shape: BoxShape.circle, color: AppColor.greenColor),
      ),
    );
  }
}
