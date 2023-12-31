import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:wyrrdemo/provider/from_currency_provider.dart';
import 'package:wyrrdemo/provider/to_currency_provider.dart';

import 'package:wyrrdemo/screens/login_page.dart';
import 'package:wyrrdemo/services/auth_service.dart';
import 'package:wyrrdemo/utils/app_color.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // FlutterNativeSplash.remove();
  await Firebase.initializeApp();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

Future initiaLization(BuildContext? context) async {
  await Future.delayed(Duration(seconds: 3));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ToCurrencyProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => FromCurrencyProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            visualDensity: VisualDensity.adaptivePlatformDensity,
            scaffoldBackgroundColor: AppColor.blackColor,
            fontFamily: 'Good-Sans',
            appBarTheme: const AppBarTheme(
                elevation: 0, backgroundColor: Colors.transparent)),
        home: AuthService.handleAuth(),
      ),
    );
  }
}
