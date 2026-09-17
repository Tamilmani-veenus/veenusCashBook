// To parse this JSON data, do
//
//     final salesDetailsSaveResponse = salesDetailsSaveResponseFromJson(jsonString);

import 'dart:convert';

SalesDetailsSaveResponse salesDetailsSaveResponseFromJson(String str) => SalesDetailsSaveResponse.fromJson(json.decode(str));

String salesDetailsSaveResponseToJson(SalesDetailsSaveResponse data) => json.encode(data.toJson());

class SalesDetailsSaveResponse {
  int? id;
  String? salesNo;
  String? date;
  int? companyId;
  double? erpCost;
  double? cashPortion;
  double? accountPortion;
  double? gst;
  double? gstPercentage;
  double? netAmount;
  double? tds;
  double? tdsPercentage;
  bool? tdsCheck;
  String? companyName;

  SalesDetailsSaveResponse({
    this.id,
    this.salesNo,
    this.date,
    this.companyId,
    this.erpCost,
    this.cashPortion,
    this.accountPortion,
    this.gst,
    this.gstPercentage,
    this.netAmount,
    this.tds,
    this.tdsPercentage,
    this.tdsCheck,
    this.companyName,
  });

  factory SalesDetailsSaveResponse.fromJson(Map<String, dynamic> json) => SalesDetailsSaveResponse(
    id: json["id"],
    salesNo: json["salesNo"],
    date: json["date"],
    companyId: json["companyId"],
    erpCost: json["erpCost"],
    cashPortion: json["cashPortion"],
    accountPortion: json["accountPortion"],
    gst: json["gst"],
    gstPercentage: json["gstPercentage"],
    netAmount: json["netAmount"],
    tds: json["tds"],
    tdsPercentage: json["tdsPercentage"],
    tdsCheck: json["tdsCheck"],
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
    "gstPercentage": gstPercentage,
    "netAmount": netAmount,
    "tds": tds,
    "tdsPercentage": tdsPercentage,
    "tdsCheck": tdsCheck,
    "companyName": companyName,
  };
}
