// To parse this JSON data, do
//
//     final outStandingReport = outStandingReportFromJson(jsonString);

import 'dart:convert';

OutStandingReport outStandingReportFromJson(String str) => OutStandingReport.fromJson(json.decode(str));

String outStandingReportToJson(OutStandingReport data) => json.encode(data.toJson());

class OutStandingReport {
  bool? success;
  List<OverallTotal>? data;
  OverallTotal? overallTotal;
  String? message;

  OutStandingReport({
    this.success,
    this.data,
    this.overallTotal,
    this.message
  });

  factory OutStandingReport.fromJson(Map<String, dynamic> json) => OutStandingReport(
    success: json["success"],
    data: json["data"] == null ? [] : List<OverallTotal>.from(json["data"]!.map((x) => OverallTotal.fromJson(x))),
    overallTotal: json["overallTotal"] == null ? null : OverallTotal.fromJson(json["overallTotal"]),
    message: json["message"]
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "overallTotal": overallTotal?.toJson(),
    "message": message
  };
}

class OverallTotal {
  String? companyName;
  double? salesAmount;
  double? receiptAmount;
  double? balanceAmount;

  OverallTotal({
    this.companyName,
    this.salesAmount,
    this.receiptAmount,
    this.balanceAmount,
  });

  factory OverallTotal.fromJson(Map<String, dynamic> json) => OverallTotal(
    companyName: json["companyName"],
    salesAmount: json["salesAmount"]?.toDouble(),
    receiptAmount: json["receiptAmount"],
    balanceAmount: json["balanceAmount"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "companyName": companyName,
    "salesAmount": salesAmount,
    "receiptAmount": receiptAmount,
    "balanceAmount": balanceAmount,
  };
}
