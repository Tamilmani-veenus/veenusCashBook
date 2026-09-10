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
  DateTime? billDate;
  int? companyId;
  int? billAmount;
  int? gst;
  int? netAmount;
  String? companyName;

  Result({
    this.id,
    this.billNo,
    this.billDate,
    this.companyId,
    this.billAmount,
    this.gst,
    this.netAmount,
    this.companyName,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    billNo: json["billNo"],
    billDate: json["billDate"] == null ? null : DateTime.parse(json["billDate"]),
    companyId: json["companyId"],
    billAmount: json["billAmount"],
    gst: json["gst"],
    netAmount: json["netAmount"],
    companyName: json["companyName"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "billNo": billNo,
    "billDate": billDate == null ? null : "${billDate!.year.toString().padLeft(4, '0')}-${billDate!.month.toString().padLeft(2, '0')}-${billDate!.day.toString().padLeft(2, '0')}",
    "companyId": companyId,
    "billAmount": billAmount,
    "gst": gst,
    "netAmount": netAmount,
    "companyName": companyName,
  };
}
