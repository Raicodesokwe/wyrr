import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wyrrdemo/widgets/background_neon.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackgroundNeon(
        child: Center(
      child: SvgPicture.asset('assets/images/logo.svg'),
    ));
  }
}
