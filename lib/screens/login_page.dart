import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:wyrrdemo/screens/home_page.dart';
import 'package:wyrrdemo/screens/sign_up.dart';

import '../utils/app_color.dart';
import '../widgets/background_neon.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailNameController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController nameController = TextEditingController();

  final _emailForm = GlobalKey<FormState>();

  checkFields() {
    final form = _emailForm.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  late String email;

  late String password;

  late String confirmPassword;

  bool isLoading = false;

  var message = 'Something went wrong';

  @override
  Widget build(BuildContext context) {
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    Size size = MediaQuery.of(context).size;
    return BackgroundNeon(
        child: Form(
      key: _emailForm,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // SizedBox(
            //   height: size.height * 0.02,
            // ),
            // if (!isKeyboard)
            //   Lottie.asset('assets/images/login.json', width: size.width * 0.7),
            Text(
              'Login',
              style: TextStyle(
                  color: AppColor.greenColor,
                  fontSize: 50,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                width: size.width * 0.8,
                decoration: BoxDecoration(
                    border: Border.all(color: AppColor.whiteColor),
                    color: AppColor.whiteColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10.0)),
                child: TextFormField(
                  controller: emailNameController,
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    email = value;
                  },
                  cursorColor: Colors.white30,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      hintText: 'email',
                      hintStyle: TextStyle(color: Colors.white),
                      border: InputBorder.none),
                )),
            SizedBox(
              height: size.height * 0.03,
            ),
            Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                width: size.width * 0.8,
                decoration: BoxDecoration(
                    border: Border.all(color: AppColor.whiteColor),
                    color: AppColor.whiteColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10.0)),
                child: TextFormField(
                  controller: passwordController,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    password = value;
                  },
                  cursorColor: Colors.white30,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      hintText: 'password',
                      hintStyle: TextStyle(color: Colors.white),
                      border: InputBorder.none),
                )),
            SizedBox(
              height: size.height * 0.03,
            ),
            if (!isKeyboard)
              GestureDetector(
                onTap: () async {
                  if (checkFields()) {
                    setState(() {
                      isLoading = true;
                    });
                    try {
                      await FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                              email: email.trim(), password: password.trim())
                          .then((value) {
                        setState(() {
                          isLoading = false;
                        });
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomePage()));
                      });
                    } on FirebaseAuthException catch (e) {
                      setState(() {
                        isLoading = false;
                      });

                      if (e.message != null) {
                        message = e.message!;
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(e.message.toString())));
                    }
                  }
                },
                child: Container(
                  height: 50,
                  width: size.width * 0.7,
                  child: Center(
                      child: isLoading
                          ? CircularProgressIndicator(
                              color: AppColor.blackColor,
                            )
                          : Text(
                              'Sign in',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                            )),
                  decoration: BoxDecoration(
                      color: AppColor.greenColor,
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            SizedBox(
              height: size.height * 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Don\'t have an account?',
                  style: TextStyle(color: Colors.white70),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SignupScreen()));
                    },
                    child: Text(
                      'Sign up',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: AppColor.greenColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ))
              ],
            )
          ],
        ),
      ),
    ));
  }
}
