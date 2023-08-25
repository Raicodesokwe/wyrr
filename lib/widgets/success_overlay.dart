import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:wyrrdemo/utils/app_color.dart';

class SuccessOverlay extends StatelessWidget {
  const SuccessOverlay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AlertDialog(
      backgroundColor: AppColor.blackColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Text(
        'Successfully sent the funds!!',
        style:
            TextStyle(color: AppColor.greenColor, fontWeight: FontWeight.w600),
      ),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        Lottie.asset('assets/images/success.json'),
        GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
            height: 50,
            width: size.width * 0.4,
            child: Center(
              child: Text(
                'Ok',
                style: TextStyle(
                    color: AppColor.greenColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColor.greenColor, width: 2)),
          ),
        )
      ]),
    );
  }
}
