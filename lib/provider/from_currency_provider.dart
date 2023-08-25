import 'package:flutter/cupertino.dart';

import '../models/from_currency_model.dart';

class FromCurrencyProvider with ChangeNotifier {
  final List<FromCurrenciesModel> _fromcurrencieslist = [
    FromCurrenciesModel(image: 'usflag.jpg', name: 'USD'),
    FromCurrenciesModel(image: 'uk.png', name: 'GBP'),
    FromCurrenciesModel(image: 'euro.png', name: 'EUR'),
    FromCurrenciesModel(image: 'canada.png', name: 'CAD'),
    FromCurrenciesModel(image: 'japan.png', name: 'JPY'),
    FromCurrenciesModel(image: 'sa.jpg', name: 'ZAR'),
  ];
  List<FromCurrenciesModel> get fromcurrencieslist {
    return [..._fromcurrencieslist];
  }

  String selectedfromcurrency = 'USD';
  String selectedfromimage = 'usflag.jpg';
  void selectFromCurrency(int fromcurrency) {
    selectedfromcurrency = _fromcurrencieslist[fromcurrency].name;
    selectedfromimage = _fromcurrencieslist[fromcurrency].image;
    notifyListeners();
  }
}
