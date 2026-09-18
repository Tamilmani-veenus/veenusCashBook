// To parse this JSON data, do
//
//     final receiptReportDetails = receiptReportDetailsFromJson(jsonString);

import 'dart:convert';

ReceiptReportDetails receiptReportDetailsFromJson(String str) => ReceiptReportDetails.fromJson(json.decode(str));

String receiptReportDetailsToJson(ReceiptReportDetails data) => json.encode(data.toJson());

class ReceiptReportDetails {
  bool? success;
  List<ReceiptResult>? result;
  String? message;

  ReceiptReportDetails({
    this.success,
    this.result,
    this.message
  });

  factory ReceiptReportDetails.fromJson(Map<String, dynamic> json) => ReceiptReportDetails(
    success: json["success"],
    result: json["result"] == null ? [] : List<ReceiptResult>.from(json["result"]!.map((x) => ReceiptResult.fromJson(x))),
    message: json["message"]
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "result": result == null ? [] : List<dynamic>.from(result!.map((x) => x.toJson())),
    "message": message
  };
}

class ReceiptResult {
  int? companyId;
  String? companyName;
  DateTime? companyDate;
  List<ReceiptDetail>? receiptDetails;

  ReceiptResult({
    this.companyId,
    this.companyName,
    this.companyDate,
    this.receiptDetails,
  });

  factory ReceiptResult.fromJson(Map<String, dynamic> json) => ReceiptResult(
    companyId: json["companyId"],
    companyName: json["companyName"],
    companyDate: json["companyDate"] == null ? null : DateTime.parse(json["companyDate"]),
    receiptDetails: json["receiptDetails"] == null ? [] : List<ReceiptDetail>.from(json["receiptDetails"]!.map((x) => ReceiptDetail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "companyId": companyId,
    "companyName": companyName,
    "companyDate": companyDate == null ? null : "${companyDate!.year.toString().padLeft(4, '0')}-${companyDate!.month.toString().padLeft(2, '0')}-${companyDate!.day.toString().padLeft(2, '0')}",
    "receiptDetails": receiptDetails == null ? [] : List<dynamic>.from(receiptDetails!.map((x) => x.toJson())),
  };
}

class ReceiptDetail {
  int? id;
  String? receiptNo;
  String? date;
  int? companyId;
  double? receivedAmount;
  double? cashPortion;
  double? bankPortion;
  double? tds;
  double? tdsPercentage;
  double? gst;
  double? gstPercentage;
  bool? tdsCheck;
  dynamic companyLink;

  ReceiptDetail({
    this.id,
    this.receiptNo,
    this.date,
    this.companyId,
    this.receivedAmount,
    this.cashPortion,
    this.bankPortion,
    this.tds,
    this.tdsPercentage,
    this.gst,
    this.gstPercentage,
    this.tdsCheck,
    this.companyLink,
  });

  factory ReceiptDetail.fromJson(Map<String, dynamic> json) => ReceiptDetail(
    id: json["id"],
    receiptNo: json["receiptNo"],
    date: json["receiptDate"],
    companyId: json["companyId"],
    receivedAmount: json["receivedAmount"],
    cashPortion: json["cashPortion"],
    bankPortion: json["bankPortion"],
    tds: json["tds"]?.toDouble(),
    tdsPercentage: json["tdsPercentage"],
    gst: json["gst"]?.toDouble(),
    gstPercentage: json["gstPercentage"],
    tdsCheck: json["tdsCheck"],
    companyLink: json["companyLink"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "receiptNo": receiptNo,
    "receiptDate": date,
    "companyId": companyId,
    "receivedAmount": receivedAmount,
    "cashPortion": cashPortion,
    "bankPortion": bankPortion,
    "tds": tds,
    "tdsPercentage": tdsPercentage,
    "gst": gst,
    "gstPercentage": gstPercentage,
    "tdsCheck": tdsCheck,
    "companyLink": companyLink,
  };
}
