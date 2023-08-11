import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wyrrdemo/widgets/background_neon.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BackgroundNeon(
        child: Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SvgPicture.asset(
          'assets/images/logo.svg',
          width: size.width * 0.5,
        ),
      ),
    ));
  }
}
