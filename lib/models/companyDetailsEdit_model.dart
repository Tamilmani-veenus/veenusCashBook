// To parse this JSON data, do
//
//     final companyDetailsEditRes = companyDetailsEditResFromJson(jsonString);

import 'dart:convert';

CompanyDetailsEditRes companyDetailsEditResFromJson(String str) => CompanyDetailsEditRes.fromJson(json.decode(str));

String companyDetailsEditResToJson(CompanyDetailsEditRes data) => json.encode(data.toJson());

class CompanyDetailsEditRes {
  bool? success;
  CompanyEditResult? result;
  String? message;

  CompanyDetailsEditRes({
    this.success,
    this.result,
    this.message
  });

  factory CompanyDetailsEditRes.fromJson(Map<String, dynamic> json) => CompanyDetailsEditRes(
    success: json["success"],
    result: json["result"] == null ? null : CompanyEditResult.fromJson(json["result"]),
    message: json["message"]
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "result": result?.toJson(),
    "message": message
  };
}

class CompanyEditResult {
  int? id;
  String? companyName;
  String? companyAddress;
  String? companyDate;
  String? date;
  String? contactNo;
  String? city;
  String? email;
  String? gstNo;
  dynamic salesDetails;

  CompanyEditResult({
    this.id,
    this.companyName,
    this.companyDate,
    this.companyAddress,
    this.date,
    this.contactNo,
    this.city,
    this.email,
    this.gstNo,
    this.salesDetails,
  });

  factory CompanyEditResult.fromJson(Map<String, dynamic> json) => CompanyEditResult(
    id: json["id"],
    companyName: json["companyName"],
    companyDate: json["companyDate"],
    companyAddress: json["companyAddress"],
    date: json["companyDate"],
    contactNo: json["contactNo"],
    city: json["city"],
    email: json["email"],
    gstNo: json["gstNo"],
    salesDetails: json["salesDetails"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "companyName": companyName,
    "companyDate": companyDate,
    "companyAddress": companyAddress,
    "companyDate": date,
    "contactNo": contactNo,
    "city": city,
    "email": email,
    "gstNo": gstNo,
    "salesDetails": salesDetails,
  };
}
