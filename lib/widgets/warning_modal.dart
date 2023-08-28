import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class WarningModal extends StatelessWidget {
  const WarningModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 20,
          ),
          Text(
            'The amount is greater than your balance!!',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 23),
          ),
          Lottie.asset('assets/images/failed.json', height: size.height * 0.2),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              height: 50,
              width: size.width * 0.4,
              child: Center(
                child: Text(
                  'OK',
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8), color: Colors.red),
            ),
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
