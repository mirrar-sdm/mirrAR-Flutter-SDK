// To parse this JSON data, do
//
//     final errorResponse = errorResponseFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

ErrorResponse errorResponseFromJson(String str) =>
    ErrorResponse.fromJson(json.decode(str));

String errorResponseToJson(ErrorResponse data) => json.encode(data.toJson());

class ErrorResponse {
  ErrorResponse({
    required this.meta,
    required this.data,
  });

  Meta meta;
  List<dynamic> data;

  factory ErrorResponse.fromJson(Map<String, dynamic> json) => ErrorResponse(
        meta: Meta.fromJson(json["meta"]),
        data: List<dynamic>.from(json["data"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "meta": meta.toJson(),
        "data": List<dynamic>.from(data.map((x) => x)),
      };
}

class Meta {
  Meta({
    required this.code,
    required this.message,
  });

  int code;
  String message;

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        code: json["code"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
      };
}
