// To parse this JSON data, do
//
//     final salesReportResponse = salesReportResponseFromJson(jsonString);

import 'dart:convert';

SalesReportResponse salesReportResponseFromJson(String str) => SalesReportResponse.fromJson(json.decode(str));

String salesReportResponseToJson(SalesReportResponse data) => json.encode(data.toJson());

class SalesReportResponse {
  bool? success;
  List<SalesResult>? result;
  String? message;

  SalesReportResponse({
    this.success,
    this.result,
    this.message
  });

  factory SalesReportResponse.fromJson(Map<String, dynamic> json) => SalesReportResponse(
    success: json["success"],
    result: json["result"] == null ? [] : List<SalesResult>.from(json["result"]!.map((x) => SalesResult.fromJson(x))),
    message: json["message"]
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "result": result == null ? [] : List<dynamic>.from(result!.map((x) => x.toJson())),
    "message": message
  };
}

class SalesResult {
  int? companyId;
  String? companyName;
  String? companyDate;
  List<SalesDetail>? salesDetails;

  SalesResult({
    this.companyId,
    this.companyName,
    this.companyDate,
    this.salesDetails,
  });

  factory SalesResult.fromJson(Map<String, dynamic> json) => SalesResult(
    companyId: json["companyId"],
    companyName: json["companyName"],
    companyDate: json["companyDate"],
    salesDetails: json["salesDetails"] == null ? [] : List<SalesDetail>.from(json["salesDetails"]!.map((x) => SalesDetail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "companyId": companyId,
    "companyName": companyName,
    "companyDate": companyDate,
    "salesDetails": salesDetails == null ? [] : List<dynamic>.from(salesDetails!.map((x) => x.toJson())),
  };
}

class SalesDetail {
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
  dynamic companyLink;

  SalesDetail({
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
    this.companyLink,
  });

  factory SalesDetail.fromJson(Map<String, dynamic> json) => SalesDetail(
    id: json["id"],
    salesNo: json["salesNo"],
    date: json["date"],
    companyId: json["companyId"],
    erpCost: json["erpCost"],
    cashPortion: json["cashPortion"],
    accountPortion: json["accountPortion"],
    gst: json["gst"]?.toDouble(),
    gstPercentage: json["gstPercentage"],
    netAmount: json["netAmount"]?.toDouble(),
    tds: json["tds"]?.toDouble(),
    tdsPercentage: json["tdsPercentage"],
    tdsCheck: json["tdsCheck"],
    companyLink: json["companyLink"],
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
    "companyLink": companyLink,
  };
}
