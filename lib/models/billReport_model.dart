// To parse this JSON data, do
//
//     final billReportDetails = billReportDetailsFromJson(jsonString);

import 'dart:convert';

BillReportDetails billReportDetailsFromJson(String str) => BillReportDetails.fromJson(json.decode(str));

String billReportDetailsToJson(BillReportDetails data) => json.encode(data.toJson());

class BillReportDetails {
  bool? success;
  List<BillResult>? result;
  String? message;

  BillReportDetails({
    this.success,
    this.result,
    this.message
  });

  factory BillReportDetails.fromJson(Map<String, dynamic> json) => BillReportDetails(
    success: json["success"],
    result: json["result"] == null ? [] : List<BillResult>.from(json["result"]!.map((x) => BillResult.fromJson(x))),
    message: json["message"]
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "result": result == null ? [] : List<dynamic>.from(result!.map((x) => x.toJson())),
    "message": message
  };
}

class BillResult {
  int? companyId;
  String? companyName;
  String? companyDate;
  List<BillDetail>? billDetails;

  BillResult({
    this.companyId,
    this.companyName,
    this.companyDate,
    this.billDetails,
  });

  factory BillResult.fromJson(Map<String, dynamic> json) => BillResult(
    companyId: json["companyId"],
    companyName: json["companyName"],
    companyDate: json["companyDate"],
    billDetails: json["billDetails"] == null ? [] : List<BillDetail>.from(json["billDetails"]!.map((x) => BillDetail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "companyId": companyId,
    "companyName": companyName,
    "companyDate": companyDate,
    "billDetails": billDetails == null ? [] : List<dynamic>.from(billDetails!.map((x) => x.toJson())),
  };
}

class BillDetail {
  int? id;
  String? billNo;
  String? date;
  int? companyId;
  double? billAmount;
  double? gst;
  double? gstPercentage;
  double? netAmount;
  dynamic companyLink;

  BillDetail({
    this.id,
    this.billNo,
    this.date,
    this.companyId,
    this.billAmount,
    this.gst,
    this.gstPercentage,
    this.netAmount,
    this.companyLink,
  });

  factory BillDetail.fromJson(Map<String, dynamic> json) => BillDetail(
    id: json["id"],
    billNo: json["billNo"],
    date: json["billDate"],
    companyId: json["companyId"],
    billAmount: json["billAmount"],
    gst: json["gst"]?.toDouble(),
    gstPercentage: json["gstPercentage"],
    netAmount: json["netAmount"]?.toDouble(),
    companyLink: json["companyLink"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "billNo": billNo,
    "billDate": date,
    "companyId": companyId,
    "billAmount": billAmount,
    "gst": gst,
    "gstPercentage": gstPercentage,
    "netAmount": netAmount,
    "companyLink": companyLink,
  };
}
