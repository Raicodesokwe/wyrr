import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:wyrrdemo/utils/app_color.dart';

import '../provider/from_currency_provider.dart';
import '../provider/to_currency_provider.dart';

class FromCurrencyOverlay extends StatefulWidget {
  const FromCurrencyOverlay({Key? key}) : super(key: key);

  @override
  State<FromCurrencyOverlay> createState() => _FromCurrencyOverlayState();
}

class _FromCurrencyOverlayState extends State<FromCurrencyOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnimation;
  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.elasticInOut);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final fromcurrency = Provider.of<FromCurrencyProvider>(context);
    return ScaleTransition(
      scale: scaleAnimation,
      child: AlertDialog(
          backgroundColor: AppColor.greenColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            'From:',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
          ),
          content: Padding(
            padding: const EdgeInsets.all(8),
            child: Consumer<ToCurrencyProvider>(
              builder: (context, notifier, child) => Wrap(
                spacing: 25,
                runSpacing: 15,
                alignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.start,
                direction: Axis.horizontal,
                runAlignment: WrapAlignment.start,
                verticalDirection: VerticalDirection.down,
                clipBehavior: Clip.none,
                children: List.generate(fromcurrency.fromcurrencieslist.length,
                    (index) {
                  final frlist = fromcurrency.fromcurrencieslist[index];
                  return GestureDetector(
                    onTap: () {
                      fromcurrency.selectFromCurrency(index);
                      Navigator.of(context).pop();
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage(
                                      "assets/images/${frlist.image}")),
                              color: Colors.white54,
                              shape: BoxShape.circle),
                        ),
                        Text(
                          frlist.name,
                          style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.w600,
                              fontSize: 13),
                        )
                      ],
                    ),
                  );
                }),
              ),
            ),
          )),
    );
  }
}
