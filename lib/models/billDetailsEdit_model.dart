// To parse this JSON data, do
//
//     final billDetailsEditResponse = billDetailsEditResponseFromJson(jsonString);

import 'dart:convert';

BillDetailsEditResponse billDetailsEditResponseFromJson(String str) => BillDetailsEditResponse.fromJson(json.decode(str));

String billDetailsEditResponseToJson(BillDetailsEditResponse data) => json.encode(data.toJson());

class BillDetailsEditResponse {
  bool? success;
  Result? result;
  String? message;

  BillDetailsEditResponse({
    this.success,
    this.result,
    this.message
  });

  factory BillDetailsEditResponse.fromJson(Map<String, dynamic> json) => BillDetailsEditResponse(
    success: json["success"],
    result: json["result"] == null ? null : Result.fromJson(json["result"]),
    message: json['message']
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "result": result?.toJson(),
    "message": message
  };
}

class Result {
  int? id;
  String? billNo;
  String? billDate;
  int? companyId;
  double? billAmount;
  double? gst;
  double? gstPercentage;
  double? netAmount;
  String? companyName;

  Result({
    this.id,
    this.billNo,
    this.billDate,
    this.companyId,
    this.billAmount,
    this.gst,
    this.gstPercentage,
    this.netAmount,
    this.companyName,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    billNo: json["billNo"],
    billDate: json["billDate"],
    companyId: json["companyId"],
    billAmount: json["billAmount"],
    gst: json["gst"],
    gstPercentage: json["gstPercentage"],
    netAmount: json["netAmount"],
    companyName: json["companyName"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "billNo": billNo,
    "billDate": billDate,
    "companyId": companyId,
    "billAmount": billAmount,
    "gst": gst,
    "gstPercentage": gstPercentage,
    "netAmount": netAmount,
    "companyName": companyName,
  };
}
