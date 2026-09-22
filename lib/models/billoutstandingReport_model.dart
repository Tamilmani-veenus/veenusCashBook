// To parse this JSON data, do
//
//     final billOutStandingReport = billOutStandingReportFromJson(jsonString);

import 'dart:convert';

BillOutStandingReport billOutStandingReportFromJson(String str) => BillOutStandingReport.fromJson(json.decode(str));

String billOutStandingReportToJson(BillOutStandingReport data) => json.encode(data.toJson());

class BillOutStandingReport {
  bool? success;
  List<BillOverallTotal>? data;
  BillOverallTotal? overallTotal;
  String? message;

  BillOutStandingReport({
    this.success,
    this.data,
    this.overallTotal,
    this.message
  });

  factory BillOutStandingReport.fromJson(Map<String, dynamic> json) => BillOutStandingReport(
    success: json["success"],
    data: json["data"] == null ? [] : List<BillOverallTotal>.from(json["data"]!.map((x) => BillOverallTotal.fromJson(x))),
    overallTotal: json["overallTotal"] == null ? null : BillOverallTotal.fromJson(json["overallTotal"]),
    message: json["message"]
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "overallTotal": overallTotal?.toJson(),
    "message": message
  };
}

class BillOverallTotal {
  String? companyName;
  double? salesAmount;
  double? totalReceivedAmount;
  double? billAmount;
  double? balanceAmount;

  BillOverallTotal({
    this.companyName,
    this.salesAmount,
    this.totalReceivedAmount,
    this.billAmount,
    this.balanceAmount,
  });

  factory BillOverallTotal.fromJson(Map<String, dynamic> json) => BillOverallTotal(
    companyName: json["companyName"],
    salesAmount: json["salesAmount"]?.toDouble(),
    totalReceivedAmount: json["totalReceivedAmount"]?.toDouble(),
    billAmount: json["billAmount"]?.toDouble(),
    balanceAmount: json["balanceAmount"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "companyName": companyName,
    "salesAmount": salesAmount,
    "totalReceivedAmount": totalReceivedAmount,
    "billAmount": billAmount,
    "balanceAmount": balanceAmount,
  };
}
