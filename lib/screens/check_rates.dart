import 'dart:async';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wyrrdemo/widgets/background_neon.dart';

import '../data/currency_converter_bloc.dart';
import '../models/currency_change_model.dart';
import '../provider/from_currency_provider.dart';
import '../provider/to_currency_provider.dart';
import '../utils/app_color.dart';
import '../widgets/from_currency_overlay.dart';
import '../widgets/to_currency_overlay.dart';

class CheckRates extends StatefulWidget {
  CheckRates({Key? key}) : super(key: key);

  @override
  State<CheckRates> createState() => _CheckRatesState();
}

class _CheckRatesState extends State<CheckRates> {
  StreamSubscription? currencyConverterSubscription;

  final CurrencyConverterBloc _bloc = CurrencyConverterBloc();
  late String amount;

  late String result;

  String? from;
  String? fromCurrency;
  String? fromImage;

  String? to;
  String? toCurrency;
  String? toImage;

  String changedAmount = '';

  final TextEditingController amountController = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void _convertCurrency() {
    currencyConverterSubscription =
        _bloc.getCurrencyConverterStream.listen((CurrencyChangeModel response) {
      currencyConverterSubscription?.cancel();

      changedAmount = response.result!.toStringAsFixed(2).toString();
      print("amount is $changedAmount");
    });
    _bloc.currencyConverter(to: toCurrency, from: fromCurrency, amount: amount);
  }

  bool selected = false;
  @override
  Widget build(BuildContext context) {
    toCurrency = Provider.of<ToCurrencyProvider>(context).selectedtocurrency;
    fromCurrency =
        Provider.of<FromCurrencyProvider>(context).selectedfromcurrency;
    toImage = Provider.of<ToCurrencyProvider>(context).selectedtoimage;
    fromImage = Provider.of<FromCurrencyProvider>(context).selectedfromimage;
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    Size size = MediaQuery.of(context).size;
    return BackgroundNeon(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!isKeyboard)
              Text(
                'Currency\nConverter',
                style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.w600,
                    color: AppColor.whiteColor),
              ),
            SizedBox(
              height: size.height * 0.1,
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
                  controller: amountController,
                  style: const TextStyle(color: Colors.white70),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a valid amount';
                    }

                    return null;
                  },
                  onChanged: (value) {
                    this.amount = value;
                  },
                  cursorColor: Colors.white60,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      hintText: 'Enter amount',
                      hintStyle: TextStyle(
                          fontFamily: 'Good-Sans', color: Colors.white60),
                      labelStyle: TextStyle(
                          fontFamily: 'Good-Sans', color: Colors.white60),
                      border: InputBorder.none),
                )),
            SizedBox(
              height: size.height * 0.03,
            ),
            Row(
              children: [
                Text(
                  'From:',
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(
                  width: 7,
                ),
                ActionChip(
                  onPressed: () {
                    showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (context) {
                          return FromCurrencyOverlay();
                        });
                  },
                  side: BorderSide(color: const Color(0xFFE6E6E6), width: 1),
                  labelPadding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  label: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 25,
                        width: 25,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage("assets/images/$fromImage")),
                            color: Colors.white54,
                            shape: BoxShape.circle),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        fromCurrency!,
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                  backgroundColor: Colors.transparent,
                ),
                Spacer(),
                Text(
                  'To:',
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(
                  width: 7,
                ),
                ActionChip(
                  onPressed: () {
                    showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (context) {
                          return ToCurrencyOverlay();
                        });
                  },
                  side: BorderSide(color: const Color(0xFFE6E6E6), width: 1),
                  labelPadding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  label: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 25,
                        width: 25,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage("assets/images/$toImage")),
                            color: Colors.white54,
                            shape: BoxShape.circle),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        toCurrency!,
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                  backgroundColor: Colors.transparent,
                ),
              ],
            ),
            SizedBox(
              height: size.height * 0.07,
            ),
            selected
                ? Row(
                    children: [
                      Text(
                        'They\'ll receive . . .',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      Spacer(),
                      StreamBuilder(
                          stream: _bloc.getCurrencyConverterStream,
                          builder: (context, snapshot) {
                            if (snapshot.hasError ||
                                !snapshot.hasData ||
                                snapshot.connectionState ==
                                    ConnectionState.waiting) {
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
                              toCurrency == 'USD'
                                  ? '\$$changedAmount'
                                  : toCurrency == 'GBP'
                                      ? '￡$changedAmount'
                                      : toCurrency == 'ZAR'
                                          ? 'ZAR $changedAmount'
                                          : toCurrency == 'EUR'
                                              ? '€$changedAmount'
                                              : toCurrency == 'JPY'
                                                  ? '¥$changedAmount'
                                                  : toCurrency == 'NGN'
                                                      ? 'NGN$changedAmount'
                                                      : changedAmount,
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            );
                          })
                    ],
                  )
                : Center(
                    child: Text(
                    'They\'ll receive . . .',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  )),
            SizedBox(
              height: size.height * 0.07,
            ),
            amountController.text.isEmpty
                ? Center(
                    child: Container(
                      height: 100,
                      width: 100,
                      child: Center(
                        child: Icon(
                          Icons.swap_horiz,
                          color: AppColor.greenColor,
                          size: 55,
                        ),
                      ),
                      decoration: BoxDecoration(
                          // shape: BoxShape.circle,
                          border: Border.all(color: Colors.pink, width: 4)),
                    ),
                  )
                : Center(
                    child: GestureDetector(
                      onTap: () {
                        _convertCurrency();
                        setState(() {
                          selected = true;
                        });
                      },
                      child: Container(
                        height: 100,
                        width: 100,
                        child: Center(
                          child: Icon(
                            Icons.swap_vert,
                            size: 55,
                            color: Colors.white,
                          ),
                        ),
                        decoration: BoxDecoration(
                            // shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.pink.withAlpha(225),
                                  blurRadius: 45,
                                  spreadRadius: 15,
                                  offset: Offset(0, 0))
                            ],
                            gradient: LinearGradient(
                                colors: [Colors.pink, Colors.pinkAccent],
                                begin: Alignment.centerRight,
                                end: Alignment.centerLeft),
                            border: Border.all(color: Colors.pink, width: 4)),
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
