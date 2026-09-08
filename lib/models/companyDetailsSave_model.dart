// To parse this JSON data, do
//
//     final companyDetailsSaveResponse = companyDetailsSaveResponseFromJson(jsonString);

import 'dart:convert';

CompanyDetailsSaveResponse companyDetailsSaveResponseFromJson(String str) => CompanyDetailsSaveResponse.fromJson(json.decode(str));

String companyDetailsSaveResponseToJson(CompanyDetailsSaveResponse data) => json.encode(data.toJson());

class CompanyDetailsSaveResponse {
  int? id;
  String? companyName;
  String? companyAddress;
  String? contactNo;
  String? city;
  String? email;
  String? gstNo;

  CompanyDetailsSaveResponse({
    this.id,
    this.companyName,
    this.companyAddress,
    this.contactNo,
    this.city,
    this.email,
    this.gstNo,
  });

  factory CompanyDetailsSaveResponse.fromJson(Map<String, dynamic> json) => CompanyDetailsSaveResponse(
    id: json["id"],
    companyName: json["companyName"],
    companyAddress: json["companyAddress"],
    contactNo: json["contactNo"],
    city: json["city"],
    email: json["email"],
    gstNo: json["gstNo"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "companyName": companyName,
    "companyAddress": companyAddress,
    "contactNo": contactNo,
    "city": city,
    "email": email,
    "gstNo": gstNo,
  };
}
