// To parse this JSON data, do
//
//     final salesDetailsEditResponse = salesDetailsEditResponseFromJson(jsonString);

import 'dart:convert';

SalesDetailsEditResponse salesDetailsEditResponseFromJson(String str) => SalesDetailsEditResponse.fromJson(json.decode(str));

String salesDetailsEditResponseToJson(SalesDetailsEditResponse data) => json.encode(data.toJson());

class SalesDetailsEditResponse {
  bool? success;
  Result? result;
  String? message;

  SalesDetailsEditResponse({
    this.success,
    this.result,
    this.message
  });

  factory SalesDetailsEditResponse.fromJson(Map<String, dynamic> json) => SalesDetailsEditResponse(
    success: json["success"],
    result: json["result"] == null ? null : Result.fromJson(json["result"]),
    message: json["message"]
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "result": result?.toJson(),
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
