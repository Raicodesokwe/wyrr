import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wyrrdemo/utils/app_color.dart';

import '../provider/to_currency_provider.dart';

class ToCurrencyOverlay extends StatefulWidget {
  const ToCurrencyOverlay({Key? key}) : super(key: key);

  @override
  State<ToCurrencyOverlay> createState() => _ToCurrencyOverlayState();
}

class _ToCurrencyOverlayState extends State<ToCurrencyOverlay>
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
    final tocurrency = Provider.of<ToCurrencyProvider>(context);
    return ScaleTransition(
      scale: scaleAnimation,
      child: AlertDialog(
          backgroundColor: AppColor.pinkColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            'To:',
            style: TextStyle(fontSize: 30, color: Colors.white),
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
                children:
                    List.generate(tocurrency.tocurrencieslist.length, (index) {
                  final tolist = tocurrency.tocurrencieslist[index];
                  return GestureDetector(
                    onTap: () {
                      tocurrency.selectToCurrency(index);
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
                                      "assets/images/${tolist.image}")),
                              color: Colors.white54,
                              shape: BoxShape.circle),
                        ),
                        Text(
                          tolist.name,
                          style: TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.w600),
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
