import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wyrrdemo/screens/home_page.dart';
import 'package:wyrrdemo/screens/login_page.dart';

import '../screens/splash_screen.dart';

class AuthService {
  static handleAuth() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (!snapshot.hasData) {
            print(snapshot.stackTrace);
            return LoginScreen();
          } else if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.hasError) {
            return SplashScreen();
          } else {
            return HomePage();
          }
        });
  }

  static Future signOut(context) async {
    try {
      await FirebaseAuth.instance.signOut();
      // Navigator.pushReplacement(
      //     context, MaterialPageRoute(builder: (context) => LoginScreen()));
    } on FirebaseAuthException catch (e) {
      var message = 'Something went wrong';
      if (e.message != null) {
        message = e.message!;
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }
  }

  static resetPasswordLink(String email) {
    FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }
}
