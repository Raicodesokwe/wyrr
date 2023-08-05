import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    // tabTwoController = TabController(length: 2, vsync: this);

    tabController!.addListener(() {
      setState(() {});
    });
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
            SizedBox(
              height: 15,
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
                    Text(
                      '\$${numberFormat.format(26785)}',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w600),
                    ),
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
            DefaultTabController(
                length: 2,
                child: TabBar(
                    isScrollable: true,
                    labelPadding: EdgeInsets.zero,
                    labelColor: Colors.black,
                    labelStyle: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w600),
                    unselectedLabelColor: Colors.white,
                    controller: tabController,
                    indicatorColor: AppColor.greenColor.withOpacity(0.28),
                    tabs: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Chip(
                          side: const BorderSide(color: Colors.black, width: 1),
                          labelPadding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          label: const Text(
                            'History',
                            style: TextStyle(color: Colors.black),
                          ),
                          backgroundColor: tabController!.index == 0
                              ? AppColor.greenColor.withOpacity(0.28)
                              : AppColor.greenColor.withOpacity(0.1),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Chip(
                          side: const BorderSide(color: Colors.black, width: 1),
                          labelPadding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          label: const Text(
                            'Friends',
                            style: TextStyle(color: Colors.black),
                          ),
                          backgroundColor: tabController!.index == 1
                              ? AppColor.greenColor.withOpacity(0.28)
                              : AppColor.greenColor.withOpacity(0.1),
                        ),
                      ),
                    ])),
            SizedBox(
              height: size.height * 0.6,
              width: double.infinity,
              child: TabBarView(controller: tabController, children: [
                Container(),
                Container(),
              ]),
            )
          ],
        ),
      ),
    ));
  }
}
