// To parse this JSON data, do
//
//     final dropDownCityValues = dropDownCityValuesFromJson(jsonString);

import 'dart:convert';

DropDownCityValues dropDownCityValuesFromJson(String str) => DropDownCityValues.fromJson(json.decode(str));

String dropDownCityValuesToJson(DropDownCityValues data) => json.encode(data.toJson());

class DropDownCityValues {
  bool? success;
  List<Result>? result;
  String? message;

  DropDownCityValues({
    this.success,
    this.result,
    this.message
  });

  factory DropDownCityValues.fromJson(Map<String, dynamic> json) => DropDownCityValues(
    success: json["success"],
    result: json["result"] == null ? [] : List<Result>.from(json["result"]!.map((x) => Result.fromJson(x))),
    message: json["message"]
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "result": result == null ? [] : List<dynamic>.from(result!.map((x) => x.toJson())),
    "message": message
  };
}

class Result {
  int? cityId;
  String? cityName;
  int? companyId;
  String? companyName;

  Result({
    this.cityId,
    this.cityName,
    this.companyId,
    this.companyName,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    cityId: json["cityID"],
    cityName: json["cityName"],
    companyId: json['id'],
    companyName: json["companyName"],
  );

  Map<String, dynamic> toJson() => {
    "cityID": cityId,
    "cityName": cityName,
    "id": companyId,
    "companyName": companyName,
  };
}
