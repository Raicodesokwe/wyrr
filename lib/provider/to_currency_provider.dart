import 'package:flutter/cupertino.dart';

import '../models/to_currency_model.dart';

class ToCurrencyProvider with ChangeNotifier {
  final List<ToCurrenciesModel> _tocurrencieslist = [
    ToCurrenciesModel(image: 'usflag.jpg', name: 'USD'),
    ToCurrenciesModel(image: 'uk.png', name: 'GBP'),
    ToCurrenciesModel(image: 'euro.png', name: 'EUR'),
    ToCurrenciesModel(image: 'aus.jpg', name: 'AUD'),
    ToCurrenciesModel(image: 'japan.png', name: 'JPY'),
    ToCurrenciesModel(image: 'sa.jpg', name: 'ZAR'),
  ];
  List<ToCurrenciesModel> get tocurrencieslist {
    return [..._tocurrencieslist];
  }

  String selectedtocurrency = 'GBP';
  String selectedtoimage = 'uk.png';
  void selectToCurrency(int tocurrency) {
    selectedtocurrency = _tocurrencieslist[tocurrency].name;
    selectedtoimage = _tocurrencieslist[tocurrency].image;
    notifyListeners();
  }
}
