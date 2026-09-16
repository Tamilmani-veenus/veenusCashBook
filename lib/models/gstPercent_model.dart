// To parse this JSON data, do
//
//     final gstPercentageResponse = gstPercentageResponseFromJson(jsonString);

import 'dart:convert';

GstPercentageResponse gstPercentageResponseFromJson(String str) => GstPercentageResponse.fromJson(json.decode(str));

String gstPercentageResponseToJson(GstPercentageResponse data) => json.encode(data.toJson());

class GstPercentageResponse {
  bool? success;
  List<Messge>? messge;
  String? message;

  GstPercentageResponse({
    this.success,
    this.messge,
    this.message
  });

  factory GstPercentageResponse.fromJson(Map<String, dynamic> json) => GstPercentageResponse(
    success: json["success"],
    messge: json["messge"] == null ? [] : List<Messge>.from(json["messge"]!.map((x) => Messge.fromJson(x))),
    message: json["message"]
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "messge": messge == null ? [] : List<dynamic>.from(messge!.map((x) => x.toJson())),
    "message": message
  };
}

class Messge {
  int? id;
  double? percentage;
  int? createdby;
  String? createdDate;

  Messge({
    this.id,
    this.percentage,
    this.createdby,
    this.createdDate,
  });

  factory Messge.fromJson(Map<String, dynamic> json) => Messge(
    id: json["id"],
    percentage: json["percentage"],
    createdby: json["createdby"],
    createdDate: json["createdDate"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "percentage": percentage,
    "createdby": createdby,
    "createdDate": createdDate,
  };
}
