// To parse this JSON data, do
//
//     final receiptDetailsEditesponse = receiptDetailsEditesponseFromJson(jsonString);

import 'dart:convert';

ReceiptDetailsEditesponse receiptDetailsEditesponseFromJson(String str) => ReceiptDetailsEditesponse.fromJson(json.decode(str));

String receiptDetailsEditesponseToJson(ReceiptDetailsEditesponse data) => json.encode(data.toJson());

class ReceiptDetailsEditesponse {
  bool? success;
  Result? result;
  String? message;

  ReceiptDetailsEditesponse({
    this.success,
    this.result,
    this.message
  });

  factory ReceiptDetailsEditesponse.fromJson(Map<String, dynamic> json) => ReceiptDetailsEditesponse(
    success: json["success"],
    result: json["result"] == null ? null : Result.fromJson(json["result"]),
    message: json["message"]
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "result": result?.toJson(),
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
