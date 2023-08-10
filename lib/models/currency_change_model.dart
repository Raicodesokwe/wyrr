// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

CurrencyChangeModel welcomeFromJson(String str) =>
    CurrencyChangeModel.fromJson(json.decode(str));

String welcomeToJson(CurrencyChangeModel data) => json.encode(data.toJson());

class CurrencyChangeModel {
  CurrencyChangeModel({
    this.success,
    this.date,
    this.result,
  });

  bool? success;

  DateTime? date;
  double? result;

  factory CurrencyChangeModel.fromJson(Map<String, dynamic> json) =>
      CurrencyChangeModel(
        success: json["success"],
        date: DateTime.parse(json["date"]),
        result: json["result"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "result": result,
      };
}
