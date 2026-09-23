// To parse this JSON data, do
//
//     final tdsReportResponse = tdsReportResponseFromJson(jsonString);

import 'dart:convert';

TdsReportResponse tdsReportResponseFromJson(String str) => TdsReportResponse.fromJson(json.decode(str));

String tdsReportResponseToJson(TdsReportResponse data) => json.encode(data.toJson());

class TdsReportResponse {
  bool? success;
  List<OveralltdsTotal>? data;
  OveralltdsTotal? overallTotal;
  String? message;

  TdsReportResponse({
    this.success,
    this.data,
    this.overallTotal,
    this.message
  });

  factory TdsReportResponse.fromJson(Map<String, dynamic> json) => TdsReportResponse(
    success: json["success"],
    data: json["data"] == null ? [] : List<OveralltdsTotal>.from(json["data"]!.map((x) => OveralltdsTotal.fromJson(x))),
    overallTotal: json["overallTotal"] == null ? null : OveralltdsTotal.fromJson(json["overallTotal"]),
    message: json["message"]
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "overallTotal": overallTotal?.toJson(),
    "message": message
  };
}

class OveralltdsTotal {
  String? companyName;
  double? tdsAmount;
  int? receivedAmount;
  double? balanceAmount;

  OveralltdsTotal({
    this.companyName,
    this.tdsAmount,
    this.receivedAmount,
    this.balanceAmount,
  });

  factory OveralltdsTotal.fromJson(Map<String, dynamic> json) => OveralltdsTotal(
    companyName: json["companyName"],
    tdsAmount: json["tdsAmount"]?.toDouble(),
    receivedAmount: json["receivedAmount"],
    balanceAmount: json["balanceAmount"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "companyName": companyName,
    "tdsAmount": tdsAmount,
    "receivedAmount": receivedAmount,
    "balanceAmount": balanceAmount,
  };
}
