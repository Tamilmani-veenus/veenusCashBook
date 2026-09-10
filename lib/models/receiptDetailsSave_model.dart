// To parse this JSON data, do
//
//     final receiptDetailsSaveResponse = receiptDetailsSaveResponseFromJson(jsonString);

import 'dart:convert';

ReceiptDetailsSaveResponse receiptDetailsSaveResponseFromJson(String str) => ReceiptDetailsSaveResponse.fromJson(json.decode(str));

String receiptDetailsSaveResponseToJson(ReceiptDetailsSaveResponse data) => json.encode(data.toJson());

class ReceiptDetailsSaveResponse {
  int? id;
  String? receiptNo;
  String? receiptDate;
  int? companyId;
  double? receivedAmount;
  double? cashPortion;
  double? bankPortion;
  double? tds;

  ReceiptDetailsSaveResponse({
    this.id,
    this.receiptNo,
    this.receiptDate,
    this.companyId,
    this.receivedAmount,
    this.cashPortion,
    this.bankPortion,
    this.tds,
  });

  factory ReceiptDetailsSaveResponse.fromJson(Map<String, dynamic> json) => ReceiptDetailsSaveResponse(
    id: json["id"],
    receiptNo: json["receiptNo"],
    receiptDate: json["receiptDate"],
    companyId: json["companyId"],
    receivedAmount: json["receivedAmount"],
    cashPortion: json["cashPortion"],
    bankPortion: json["bankPortion"],
    tds: json["tds"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "receiptNo": receiptNo,
    "receiptDate": receiptDate,
    "companyId": companyId,
    "receivedAmount": receivedAmount,
    "cashPortion": cashPortion,
    "bankPortion": bankPortion,
    "tds": tds,
  };
}
