import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl.dart' show toBeginningOfSentenceCase;
import 'package:shimmer/shimmer.dart';
import 'package:wyrrdemo/screens/check_rates.dart';
import 'package:wyrrdemo/screens/login_page.dart';
import 'package:wyrrdemo/services/auth_service.dart';
import 'package:wyrrdemo/widgets/background_neon.dart';

import '../utils/app_color.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  TabController? tabController;
  NumberFormat numberFormat = NumberFormat.decimalPattern();
  User? user = FirebaseAuth.instance.currentUser;
  Future<DocumentSnapshot<Map<String, dynamic>>>? _usernameFuture;
  late Stream<DocumentSnapshot<Map<String, dynamic>>>? _amountStream;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    // tabTwoController = TabController(length: 2, vsync: this);

    tabController!.addListener(() {
      setState(() {});
    });

    _usernameFuture =
        FirebaseFirestore.instance.collection('users').doc(user!.uid).get();

    _amountStream = FirebaseFirestore.instance
        .collection('finances')
        .doc(user!.uid)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BackgroundNeon(
        child: SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: Icon(
                  FontAwesomeIcons.arrowRightFromBracket,
                  color: AppColor.greenColor,
                ),
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                },
              ),
            ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello',
                      style: TextStyle(color: Colors.white60, fontSize: 18),
                    ),
                    FutureBuilder(
                        future: _usernameFuture,
                        builder: (context, AsyncSnapshot snapshot) {
                          if (snapshot.hasError) {
                            return Text(
                              'Error',
                              style: TextStyle(color: AppColor.whiteColor),
                            );
                          } else if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Shimmer.fromColors(
                              baseColor: AppColor.greenColor.withOpacity(0.5),
                              highlightColor:
                                  AppColor.greenColor.withOpacity(0.2),
                              child: Container(
                                height: 50,
                                width: size.width * 0.4,
                                decoration: BoxDecoration(
                                    color: AppColor.greenColor.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            );
                          }
                          final userItem = snapshot.data;
                          return Text(
                            toBeginningOfSentenceCase(userItem['username'])!,
                            style: TextStyle(
                                color: AppColor.whiteColor,
                                fontSize: 20,
                                fontWeight: FontWeight.w600),
                          );
                        })
                  ],
                ),
                Spacer(),
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      color: AppColor.pinkColor,
                      borderRadius: BorderRadius.circular(12)),
                  child: SvgPicture.asset('assets/images/nut.svg'),
                ),
              ],
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            Container(
              height: size.height * 0.25,
              width: double.infinity,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Balance',
                      style: TextStyle(color: Colors.white),
                    ),
                    StreamBuilder(
                        stream: _amountStream,
                        builder: (context, AsyncSnapshot snapshot) {
                          if (snapshot.hasError) {
                            return Text(
                              'Error',
                              style: TextStyle(color: AppColor.whiteColor),
                            );
                          } else if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Shimmer.fromColors(
                              baseColor: AppColor.greenColor.withOpacity(0.5),
                              highlightColor:
                                  AppColor.greenColor.withOpacity(0.2),
                              child: Container(
                                height: 50,
                                width: size.width * 0.4,
                                decoration: BoxDecoration(
                                    color: AppColor.greenColor.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            );
                          }
                          final amount = snapshot.data!;
                          print('amount is ${amount['amount']}');

                          return Text(
                            '\$${numberFormat.format(amount['amount'])}',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.w600),
                          );
                        }),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 50,
                          width: size.width * 0.3,
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 30,
                                  width: 30,
                                  child: Center(
                                    child: Icon(
                                      FontAwesomeIcons.moneyBillTransfer,
                                      size: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColor.pinkColor),
                                ),
                                SizedBox(
                                  width: 2,
                                ),
                                Text('Send'),
                              ],
                            ),
                          ),
                          decoration: BoxDecoration(
                              color: AppColor.whiteColor,
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => CheckRates()));
                          },
                          child: Container(
                            height: 50,
                            width: size.width * 0.3,
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 30,
                                    width: 30,
                                    child: Center(
                                      child: Icon(
                                        Icons.change_circle,
                                        size: 15,
                                        color: Colors.white,
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColor.pinkColor),
                                  ),
                                  SizedBox(
                                    width: 2,
                                  ),
                                  Text('Change\ncurrency'),
                                ],
                              ),
                            ),
                            decoration: BoxDecoration(
                                color: AppColor.whiteColor,
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              decoration: BoxDecoration(
                  border:
                      Border.all(color: AppColor.whiteColor.withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(12),
                  color: AppColor.whiteColor.withOpacity(0.1)),
            ),
            SizedBox(
              height: 20,
            ),
            // DefaultTabController(
            //     length: 2,
            //     child: TabBar(
            //         isScrollable: true,
            //         labelPadding: EdgeInsets.zero,
            //         labelColor: Colors.black,
            //         labelStyle: const TextStyle(
            //             fontSize: 12, fontWeight: FontWeight.w600),
            //         unselectedLabelColor: Colors.white,
            //         controller: tabController,
            //         indicatorColor: AppColor.greenColor.withOpacity(0.28),
            //         tabs: [
            //           Padding(
            //             padding: const EdgeInsets.only(right: 10),
            //             child: Chip(
            //               side: const BorderSide(color: Colors.black, width: 1),
            //               labelPadding: const EdgeInsets.symmetric(
            //                   horizontal: 10, vertical: 5),
            //               label: const Text(
            //                 'History',
            //                 style: TextStyle(color: Colors.black),
            //               ),
            //               backgroundColor: tabController!.index == 0
            //                   ? AppColor.greenColor.withOpacity(0.28)
            //                   : AppColor.greenColor.withOpacity(0.1),
            //             ),
            //           ),
            //           Padding(
            //             padding: const EdgeInsets.only(right: 10),
            //             child: Chip(
            //               side: const BorderSide(color: Colors.black, width: 1),
            //               labelPadding: const EdgeInsets.symmetric(
            //                   horizontal: 10, vertical: 5),
            //               label: const Text(
            //                 'Friends',
            //                 style: TextStyle(color: Colors.black),
            //               ),
            //               backgroundColor: tabController!.index == 1
            //                   ? AppColor.greenColor.withOpacity(0.28)
            //                   : AppColor.greenColor.withOpacity(0.1),
            //             ),
            //           ),
            //         ])),
            // SizedBox(
            //   height: size.height * 0.48,
            //   width: double.infinity,
            //   child: TabBarView(controller: tabController, children: [
            //     Container(),
            //     Container(),
            //   ]),
            // )
          ],
        ),
      ),
    ));
  }
}
