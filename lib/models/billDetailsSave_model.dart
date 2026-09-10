// To parse this JSON data, do
//
//     final billDetailsSaveResponse = billDetailsSaveResponseFromJson(jsonString);

import 'dart:convert';

BillDetailsSaveResponse billDetailsSaveResponseFromJson(String str) => BillDetailsSaveResponse.fromJson(json.decode(str));

String billDetailsSaveResponseToJson(BillDetailsSaveResponse data) => json.encode(data.toJson());

class BillDetailsSaveResponse {
  int? id;
  String? billNo;
  String? billDate;
  int? companyId;
  double? billAmount;
  double? gst;
  double? netAmount;
  String? companyName;

  BillDetailsSaveResponse({
    this.id,
    this.billNo,
    this.billDate,
    this.companyId,
    this.billAmount,
    this.gst,
    this.netAmount,
    this.companyName,
  });

  factory BillDetailsSaveResponse.fromJson(Map<String, dynamic> json) => BillDetailsSaveResponse(
    id: json["id"],
    billNo: json["billNo"],
    billDate: json["billDate"],
    companyId: json["companyId"],
    billAmount: json["billAmount"],
    gst: json["gst"],
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
    "netAmount": netAmount,
    "companyName": companyName,
  };
}
