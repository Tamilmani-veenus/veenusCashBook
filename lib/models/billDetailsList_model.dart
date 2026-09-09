// To parse this JSON data, do
//
//     final billDetailsGetAllesponse = billDetailsGetAllesponseFromJson(jsonString);

import 'dart:convert';

BillDetailsGetAllesponse billDetailsGetAllesponseFromJson(String str) => BillDetailsGetAllesponse.fromJson(json.decode(str));

String billDetailsGetAllesponseToJson(BillDetailsGetAllesponse data) => json.encode(data.toJson());

class BillDetailsGetAllesponse {
  bool? success;
  List<Result>? result;
  String? message;

  BillDetailsGetAllesponse({
    this.success,
    this.result,
    this.message
  });

  factory BillDetailsGetAllesponse.fromJson(Map<String, dynamic> json) => BillDetailsGetAllesponse(
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
  String? billNo;
  String? date;
  int? companyId;
  double? billAmount;
  double? gst;
  double? netAmount;
  String? companyName;

  Result({
    this.id,
    this.billNo,
    this.date,
    this.companyId,
    this.billAmount,
    this.gst,
    this.netAmount,
    this.companyName,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    billNo: json["billNo"],
    date: json["billDate"],
    companyId: json["companyId"],
    billAmount: json["billAmount"],
    gst: json["gst"],
    netAmount: json["netAmount"],
    companyName: json["companyName"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "billNo": billNo,
    "billDate": date,
    "companyId": companyId,
    "billAmount": billAmount,
    "gst": gst,
    "netAmount": netAmount,
    "companyName": companyName,
  };
}
