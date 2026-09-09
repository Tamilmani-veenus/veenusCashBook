// To parse this JSON data, do
//
//     final receiptDetailsEditResponse = receiptDetailsEditResponseFromJson(jsonString);

import 'dart:convert';

ReceiptDetailsEditResponse receiptDetailsEditResponseFromJson(String str) => ReceiptDetailsEditResponse.fromJson(json.decode(str));

String receiptDetailsEditResponseToJson(ReceiptDetailsEditResponse data) => json.encode(data.toJson());

class ReceiptDetailsEditResponse {
  bool? success;
  List<Result>? result;
  String? message;

  ReceiptDetailsEditResponse({
    this.success,
    this.result,
    this.message
  });

  factory ReceiptDetailsEditResponse.fromJson(Map<String, dynamic> json) => ReceiptDetailsEditResponse(
    success: json["success"],
    result: json["result"] == null ? [] : List<Result>.from(json["result"]!.map((x) => Result.fromJson(x))),
    message: json["message"]
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "result": result == null ? [] : List<dynamic>.from(result!.map((x) => x.toJson())),
    "message": message
  };
}

class Result {
  int? id;
  String? receiptNo;
  String? date;
  int? companyId;
  double? receivedAmount;
  double? cashPortion;
  double? bankPortion;
  double? tds;
  String? companyName;

  Result({
    this.id,
    this.receiptNo,
    this.date,
    this.companyId,
    this.receivedAmount,
    this.cashPortion,
    this.bankPortion,
    this.tds,
    this.companyName,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    receiptNo: json["receiptNo"],
    date: json["receiptDate"],
    companyId: json["companyId"],
    receivedAmount: json["receivedAmount"],
    cashPortion: json["cashPortion"],
    bankPortion: json["bankPortion"],
    tds: json["tds"],
    companyName: json["companyName"],
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
    "companyName": companyName,
  };
}
