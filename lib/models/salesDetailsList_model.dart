// To parse this JSON data, do
//
//     final salesDetailsGetAllResponse = salesDetailsGetAllResponseFromJson(jsonString);

import 'dart:convert';

SalesDetailsGetAllResponse salesDetailsGetAllResponseFromJson(String str) => SalesDetailsGetAllResponse.fromJson(json.decode(str));

String salesDetailsGetAllResponseToJson(SalesDetailsGetAllResponse data) => json.encode(data.toJson());

class SalesDetailsGetAllResponse {
  bool? success;
  List<Result>? result;
  String? message;

  SalesDetailsGetAllResponse({
    this.success,
    this.result,
    this.message
  });

  factory SalesDetailsGetAllResponse.fromJson(Map<String, dynamic> json) => SalesDetailsGetAllResponse(
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
  int? id;
  String? salesNo;
  String? date;
  int? companyId;
  double? erpCost;
  double? cashPortion;
  double? accountPortion;
  double? gst;
  double? netAmount;
  double? tds;
  String? companyName;

  Result({
    this.id,
    this.salesNo,
    this.date,
    this.companyId,
    this.erpCost,
    this.cashPortion,
    this.accountPortion,
    this.gst,
    this.netAmount,
    this.tds,
    this.companyName,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    salesNo: json["salesNo"],
    date: json["date"],
    companyId: json["companyId"],
    erpCost: json["erpCost"],
    cashPortion: json["cashPortion"],
    accountPortion: json["accountPortion"],
    gst: json["gst"],
    netAmount: json["netAmount"],
    tds: json["tds"],
    companyName: json["companyName"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "salesNo": salesNo,
    "date": date,
    "companyId": companyId,
    "erpCost": erpCost,
    "cashPortion": cashPortion,
    "accountPortion": accountPortion,
    "gst": gst,
    "netAmount": netAmount,
    "tds": tds,
    "companyName": companyName,
  };
}
