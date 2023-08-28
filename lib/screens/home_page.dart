import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl.dart' show toBeginningOfSentenceCase;
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wyrrdemo/screens/check_rates.dart';
import 'package:wyrrdemo/screens/login_page.dart';
import 'package:wyrrdemo/screens/send_money.dart';
import 'package:wyrrdemo/services/auth_service.dart';
import 'package:wyrrdemo/widgets/background_neon.dart';

import '../utils/app_color.dart';
import '../utils/date_util.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  TabController? tabController;
  bool isLoading = false;
  int? myAmount;
  NumberFormat numberFormat = NumberFormat.decimalPattern();
  User? user = FirebaseAuth.instance.currentUser;
  List transactionsList = [];
  Future<DocumentSnapshot<Map<String, dynamic>>>? _usernameFuture;
  Future<QuerySnapshot<Map<String, dynamic>>>? _friendsFuture;
  late Stream<DocumentSnapshot<Map<String, dynamic>>>? _amountStream;
  Stream<QuerySnapshot<Object?>>? _transactionsStream;
  // List<QueryDocumentSnapshot<Map<String, dynamic>>>? friendNamesList;
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
    _friendsFuture = FirebaseFirestore.instance.collection('users').get();

    _amountStream = FirebaseFirestore.instance
        .collection('finances')
        .doc(user!.uid)
        .snapshots();
    _transactionsStream = FirebaseFirestore.instance
        .collection('transactions')
        // .where('userId', isEqualTo: user!.uid)
        .orderBy('createdAt', descending: false)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BackgroundNeon(
        child: SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: isLoading
                    ? Shimmer.fromColors(
                        baseColor: AppColor.greenColor.withOpacity(0.5),
                        highlightColor: AppColor.greenColor.withOpacity(0.2),
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              color: AppColor.greenColor.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      )
                    : IconButton(
                        icon: Icon(
                          FontAwesomeIcons.arrowRightFromBracket,
                          color: AppColor.greenColor,
                        ),
                        onPressed: () {
                          setState(() {
                            isLoading = true;
                          });
                          AuthService.signOut(context).then((value) {
                            setState(() {
                              isLoading = true;
                            });
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()));
                          });
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
                                      color:
                                          AppColor.greenColor.withOpacity(0.5),
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
                                      color:
                                          AppColor.greenColor.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                              );
                            }
                            final amount = snapshot.data!;
                            print('amount is ${amount['amount']}');
                            myAmount = amount['amount'];
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'CAD\$',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  '${numberFormat.format(amount['amount'])}',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            );
                          }),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (ctx) {
                                    return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        backgroundColor: AppColor.pinkColor,
                                        content: FutureBuilder(
                                            future: _friendsFuture,
                                            builder: (context,
                                                AsyncSnapshot<
                                                        QuerySnapshot<
                                                            Map<String,
                                                                dynamic>>>
                                                    snapshot) {
                                              if (snapshot.hasError) {
                                                return Text(
                                                  'Error',
                                                  style: TextStyle(
                                                      color:
                                                          AppColor.whiteColor),
                                                );
                                              } else if (snapshot
                                                      .connectionState ==
                                                  ConnectionState.waiting) {
                                                return Shimmer.fromColors(
                                                  baseColor: AppColor.greenColor
                                                      .withOpacity(0.5),
                                                  highlightColor: AppColor
                                                      .greenColor
                                                      .withOpacity(0.2),
                                                  child: Container(
                                                    height: 50,
                                                    width: size.width * 0.4,
                                                    decoration: BoxDecoration(
                                                        color: AppColor
                                                            .greenColor
                                                            .withOpacity(0.5),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                  ),
                                                );
                                              }
                                              final friendNamesList = snapshot
                                                  .data!.docs
                                                  .where((element) =>
                                                      element
                                                          .data()['userId'] !=
                                                      user!.uid)
                                                  .toList();

                                              print('this is $friendNamesList');
                                              friendNamesList.map((e) {
                                                Map<String, dynamic> data =
                                                    e.data()
                                                        as Map<String, dynamic>;
                                              }).toList();
                                              return Wrap(
                                                spacing: 24,
                                                alignment: WrapAlignment.center,
                                                children: List.generate(
                                                    friendNamesList.length,
                                                    (index) => Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            GestureDetector(
                                                              onTap: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .push(MaterialPageRoute(
                                                                        builder: (context) => SendMoney(
                                                                              myAmount: myAmount!,
                                                                              myId: user!.uid,
                                                                              userId: friendNamesList[index]['userId'],
                                                                              userName: friendNamesList[index]['username'],
                                                                            )))
                                                                    .then((value) {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                });
                                                              },
                                                              child: Container(
                                                                height: 50,
                                                                width: 50,
                                                                decoration: BoxDecoration(
                                                                    color: AppColor
                                                                        .greenColor,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            12)),
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              12),
                                                                  child:
                                                                      SvgPicture
                                                                          .asset(
                                                                    'assets/images/circle.svg',
                                                                    fit: BoxFit
                                                                        .cover,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Text(
                                                              friendNamesList[
                                                                      index]
                                                                  ['username'],
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ],
                                                        )),
                                              );
                                            }));
                                  });
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
              FutureBuilder(
                  future: _friendsFuture,
                  builder: (context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.hasError) {
                      return Text(
                        'Error',
                        style: TextStyle(color: AppColor.whiteColor),
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Shimmer.fromColors(
                        baseColor: AppColor.greenColor.withOpacity(0.5),
                        highlightColor: AppColor.greenColor.withOpacity(0.2),
                        child: Container(
                          height: 50,
                          width: size.width * 0.4,
                          decoration: BoxDecoration(
                              color: AppColor.greenColor.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      );
                    }

                    final friendNamesList = snapshot.data!.docs
                        .where(
                            (element) => element.data()['userId'] != user!.uid)
                        .toList();

                    print('this is $friendNamesList');
                    friendNamesList.map((e) {
                      Map<String, dynamic> data =
                          e.data() as Map<String, dynamic>;
                    }).toList();

                    return Row(
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              color: AppColor.greenColor,
                              borderRadius: BorderRadius.circular(12)),
                          child: Icon(Icons.add),
                        ),
                        SizedBox(
                          width: 35,
                        ),
                        Wrap(
                          spacing: 34,
                          children: List.generate(
                              friendNamesList.length,
                              (index) => Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SendMoney(
                                                        myAmount: myAmount!,
                                                        myId: user!.uid,
                                                        userId: friendNamesList[
                                                            index]['userId'],
                                                        userName:
                                                            friendNamesList[
                                                                    index]
                                                                ['username'],
                                                      )));
                                        },
                                        child: Container(
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                              color: AppColor.pinkColor,
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            child: SvgPicture.asset(
                                              'assets/images/circle.svg',
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        friendNamesList[index]['username'],
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  )),
                        ),
                      ],
                    );
                  }),
              SizedBox(
                height: 15,
              ),
              Divider(
                color: Colors.white70,
              ),
              Text(
                'Transactions',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 25),
              ),
              SizedBox(
                height: 15,
              ),
              StreamBuilder(
                  stream: _transactionsStream,
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text(
                        'Error',
                        style: TextStyle(color: AppColor.whiteColor),
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Shimmer.fromColors(
                        baseColor: AppColor.greenColor.withOpacity(0.5),
                        highlightColor: AppColor.greenColor.withOpacity(0.2),
                        child: Container(
                          height: 50,
                          width: size.width * 0.4,
                          decoration: BoxDecoration(
                              color: AppColor.greenColor.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      );
                    } else if (!snapshot.hasData) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.asset('assets/images/empty.json',
                              width: size.width * 0.5),
                          Text(
                            'No transactions available',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 17,
                                color: AppColor.greenColor),
                          )
                        ],
                      );
                    } else {
                      transactionsList = snapshot.data!.docs.where((element) {
                        Map<String, dynamic> data =
                            element.data() as Map<String, dynamic>;
                        return data['userId'] == user!.uid;
                      }).toList();
                      transactionsList.map((e) {
                        Map<String, dynamic> data =
                            e.data() as Map<String, dynamic>;
                      }).toList();
                      return transactionsList.isEmpty
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Lottie.asset('assets/images/empty.json',
                                    width: size.width * 0.5),
                                Text(
                                  'No transactions available',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17,
                                      color: AppColor.greenColor),
                                )
                              ],
                            )
                          : Wrap(
                              children: List.generate(transactionsList.length,
                                  (index) {
                                final transactionItem = transactionsList[index];
                                return Card(
                                  color: AppColor.whiteColor.withOpacity(0.1),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  child: ListTile(
                                    // contentPadding: const EdgeInsets.all(0),
                                    leading: Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                          color: AppColor.pinkColor,
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      child: SvgPicture.asset(
                                          'assets/images/nut.svg'),
                                    ),
                                    title: Text(
                                      'You ${transactionItem['text']}',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    subtitle: Text(
                                      Utils.toDate(
                                          (transactionItem['createdAt'])
                                              .toDate()),
                                      style: TextStyle(
                                          color: Colors.white70, fontSize: 11),
                                    ),
                                    trailing: Container(
                                      width: 60,
                                      height: 20,
                                      // padding: const EdgeInsets.symmetric(
                                      //     horizontal: 7, vertical: 3),
                                      child: Center(
                                        child: Text(
                                          transactionItem['status'],
                                          style: TextStyle(
                                              // fontWeight: FontWeight.w600,
                                              fontSize: 12,
                                              color: Colors.white),
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                          color: transactionItem['status'] ==
                                                  'sent'
                                              ? Colors.red
                                              : Colors.green,
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                    ),
                                  ),
                                );
                              }),
                            );
                    }
                  }),
              SizedBox(
                height: 20,
              )
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
      ),
    ));
  }
}
