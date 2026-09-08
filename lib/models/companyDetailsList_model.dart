// To parse this JSON data, do
//
//     final companyDetailsGetAllResponse = companyDetailsGetAllResponseFromJson(jsonString);

import 'dart:convert';

CompanyDetailsGetAllResponse companyDetailsGetAllResponseFromJson(String str) => CompanyDetailsGetAllResponse.fromJson(json.decode(str));

String companyDetailsGetAllResponseToJson(CompanyDetailsGetAllResponse data) => json.encode(data.toJson());

class CompanyDetailsGetAllResponse {
  bool? success;
  List<Result>? result;
  String? message;

  CompanyDetailsGetAllResponse({
    this.success,
    this.result,
    this.message
  });

  factory CompanyDetailsGetAllResponse.fromJson(Map<String, dynamic> json) => CompanyDetailsGetAllResponse(
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
  String? companyName;
  String? companyAddress;
  String? contactNo;
  String? city;
  String? email;
  String? gstNo;
  dynamic salesDetails;

  Result({
    this.id,
    this.companyName,
    this.companyAddress,
    this.contactNo,
    this.city,
    this.email,
    this.gstNo,
    this.salesDetails,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    companyName: json["companyName"],
    companyAddress: json["companyAddress"],
    contactNo: json["contactNo"],
    city: json["city"],
    email: json["email"],
    gstNo: json["gstNo"],
    salesDetails: json["salesDetails"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "companyName": companyName,
    "companyAddress": companyAddress,
    "contactNo": contactNo,
    "city": city,
    "email": email,
    "gstNo": gstNo,
    "salesDetails": salesDetails,
  };
}

