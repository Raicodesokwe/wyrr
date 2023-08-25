import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wyrrdemo/utils/app_color.dart';
import 'package:wyrrdemo/widgets/success_overlay.dart';

import '../data/currency_converter_bloc.dart';
import '../models/currency_change_model.dart';
import '../screens/send_money.dart';

class ConfirmOverlay extends StatefulWidget {
  final String userId;
  final int userAmount;
  final String myId;
  final int myAmount;
  const ConfirmOverlay({
    Key? key,
    required this.controller,
    required this.widget,
    required this.userId,
    required this.userAmount,
    required this.myId,
    required this.myAmount,
  }) : super(key: key);

  final TextEditingController controller;
  final SendMoney widget;

  @override
  State<ConfirmOverlay> createState() => _ConfirmOverlayState();
}

class _ConfirmOverlayState extends State<ConfirmOverlay> {
  StreamSubscription? currencyConverterSubscription;
  final CurrencyConverterBloc _bloc = CurrencyConverterBloc();
  String changedAmount = '';
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _convertCurrency();
  }

  void _convertCurrency() {
    currencyConverterSubscription =
        _bloc.getCurrencyConverterStream.listen((CurrencyChangeModel response) {
      currencyConverterSubscription?.cancel();

      changedAmount = response.result!.toStringAsFixed(2).toString();
      print("amount is $changedAmount");
    });
    _bloc.currencyConverter(
        to: 'NGN', from: 'CAD', amount: widget.controller.text);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
                return Text(
                  'Are you sure you want to send CAD\$${widget.controller.text} (NGN$changedAmount) to ${widget.widget.userName} ??',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                );
              }),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  height: 50,
                  width: size.width * 0.3,
                  child: Center(
                    child: Text(
                      'No',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColor.greenColor),
                    ),
                  ),
                  decoration: BoxDecoration(
                      border: Border.all(
                        width: 3,
                        color: AppColor.greenColor,
                      ),
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isLoading = true;
                  });
                  FirebaseFirestore.instance
                      .collection('finances')
                      .doc(widget.userId)
                      .update({'amount': widget.userAmount});
                  FirebaseFirestore.instance
                      .collection('finances')
                      .doc(widget.myId)
                      .update({'amount': widget.myAmount}).then((value) {
                    setState(() {
                      isLoading = false;
                    });
                    showDialog(
                        context: context,
                        builder: (ctx) {
                          return SuccessOverlay();
                        });
                  });
                },
                child: Container(
                  height: 50,
                  width: size.width * 0.3,
                  child: Center(
                    child: isLoading
                        ? CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Text(
                            'Yes',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: AppColor.pinkColor),
                          ),
                  ),
                  decoration: BoxDecoration(
                      color: AppColor.greenColor,
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
