import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wyrrdemo/api/api_provider.dart';
import 'package:wyrrdemo/utils/app_color.dart';
import 'package:wyrrdemo/widgets/background_neon.dart';

import '../data/currency_converter_bloc.dart';
import '../models/currency_change_model.dart';
import '../widgets/confirm_overlay.dart';
import '../widgets/keypad_circle.dart';

class SendMoney extends StatefulWidget {
  final String userId;
  final String myId;
  final String userName;
  final int myAmount;
  SendMoney(
      {Key? key,
      required this.userId,
      required this.userName,
      required this.myId,
      required this.myAmount})
      : super(key: key);

  @override
  State<SendMoney> createState() => _SendMoneyState();
}

class _SendMoneyState extends State<SendMoney> {
  final TextEditingController controller = TextEditingController();
  StreamSubscription? currencyConverterSubscription;
  Future<DocumentSnapshot<Map<String, dynamic>>>? _amountFuture;
  String changedAmount = '';
  final CurrencyConverterBloc _bloc = CurrencyConverterBloc();
  int? userAmount;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _convertCurrency();
    _amountFuture = FirebaseFirestore.instance
        .collection('finances')
        .doc(widget.userId)
        .get();
  }

  void _convertCurrency() {
    currencyConverterSubscription =
        _bloc.getCurrencyConverterStream.listen((CurrencyChangeModel response) {
      currencyConverterSubscription?.cancel();

      changedAmount = response.result!.toStringAsFixed(2).toString();
      print("amount is $changedAmount");
    });
    _bloc.currencyConverter(to: 'NGN', from: 'CAD', amount: '1');
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundNeon(
      child: FutureBuilder(
          future: _amountFuture,
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasError ||
                !snapshot.hasData ||
                snapshot.connectionState == ConnectionState.waiting) {
              return Shimmer.fromColors(
                  child: Center(
                    child: Container(
                      width: 150,
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.pink.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  baseColor: Colors.pink.withOpacity(0.7),
                  highlightColor: Colors.pink.withOpacity(0.3));
            }
            userAmount = snapshot.data!['amount'];
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          color: AppColor.pinkColor,
                          borderRadius: BorderRadius.circular(12)),
                      child: SvgPicture.asset('assets/images/circle.svg'),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      widget.userName,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 17),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                StreamBuilder(
                    stream: _bloc.getCurrencyConverterStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasError ||
                          !snapshot.hasData ||
                          snapshot.connectionState == ConnectionState.waiting) {
                        return Shimmer.fromColors(
                            child: Container(
                              width: 100,
                              height: 50,
                              decoration: BoxDecoration(
                                  color: Colors.pink.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(7)),
                            ),
                            baseColor: Colors.pink.withOpacity(0.7),
                            highlightColor: Colors.pink.withOpacity(0.3));
                      }
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image:
                                        AssetImage("assets/images/canada.png")),
                                color: Colors.white54,
                                shape: BoxShape.circle),
                          ),
                          Text(
                            '1 CAD\$',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Icon(
                            FontAwesomeIcons.arrowRightLong,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage(
                                        "assets/images/nigeria.png")),
                                color: Colors.white54,
                                shape: BoxShape.circle),
                          ),
                          Text(
                            'NGN $changedAmount',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ],
                      );
                    }),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                    height: 70,
                    child: Center(
                        child: TextField(
                      style: TextStyle(
                          fontFamily:
                              Theme.of(context).textTheme.bodyText2!.fontFamily,
                          fontSize: 40,
                          color: AppColor.greenColor),
                      decoration: InputDecoration(border: InputBorder.none),
                      controller: controller,
                      textAlign: TextAlign.center,
                      showCursor: false,

                      // Disable the default soft keybaord
                      keyboardType: TextInputType.none,
                    )),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      KeypadCircle(
                        number: 1,
                        controller: controller,
                      ),
                      KeypadCircle(
                        number: 2,
                        controller: controller,
                      ),
                      KeypadCircle(
                        number: 3,
                        controller: controller,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      KeypadCircle(
                        number: 4,
                        controller: controller,
                      ),
                      KeypadCircle(
                        number: 5,
                        controller: controller,
                      ),
                      KeypadCircle(
                        number: 6,
                        controller: controller,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      KeypadCircle(
                        number: 7,
                        controller: controller,
                      ),
                      KeypadCircle(
                        number: 8,
                        controller: controller,
                      ),
                      KeypadCircle(
                        number: 9,
                        controller: controller,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          controller.text = controller.text.substring(
                              0,
                              controller.text.isNotEmpty
                                  ? controller.text.length - 1
                                  : 0);
                        },
                        child: Container(
                          height: 70,
                          width: 70,
                          child: Center(
                            child: Icon(
                              Icons.close,
                              color:
                                  Theme.of(context).textTheme.bodyText2!.color,
                            ),
                          ),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColor.greenColor),
                        ),
                      ),
                      KeypadCircle(
                        number: 0,
                        controller: controller,
                      ),
                      GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                                context: context,
                                backgroundColor: AppColor.pinkColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(12),
                                        topRight: Radius.circular(12))),
                                builder: (ctx) {
                                  return ConfirmOverlay(
                                      myAmount: widget.myAmount -
                                          int.parse(controller.text),
                                      userAmount: userAmount! +
                                          int.parse(controller.text),
                                      userId: widget.userId,
                                      myId: widget.myId,
                                      controller: controller,
                                      widget: widget);
                                });
                          },
                          child: Container(
                            height: 70,
                            width: 70,
                            child: Center(
                              child: Icon(Icons.check),
                            ),
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.green.withAlpha(225),
                                      blurRadius: 45,
                                      spreadRadius: 15,
                                      offset: Offset(0, 0))
                                ],
                                gradient: LinearGradient(
                                    colors: [Colors.green, Colors.greenAccent],
                                    begin: Alignment.centerRight,
                                    end: Alignment.centerLeft),
                                shape: BoxShape.circle,
                                color: AppColor.greenColor),
                          ))
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }
}
