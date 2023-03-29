// To parse this JSON data, do
//
//     final categoriesResponse = categoriesResponseFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

CategoriesResponse categoriesResponseFromJson(String str) =>
    CategoriesResponse.fromJson(json.decode(str));

String categoriesResponseToJson(CategoriesResponse data) =>
    json.encode(data.toJson());

class CategoriesResponse {
  CategoriesResponse({
    required this.meta,
    required this.data,
  });

  Meta meta;
  List<Datum> data;

  factory CategoriesResponse.fromJson(Map<String, dynamic> json) =>
      CategoriesResponse(
        meta: Meta.fromJson(json["meta"]),
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "meta": meta.toJson(),
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    required this.category,
    required this.label,
    required this.type,
    required this.sequence,
    required this.setsInfo,
    required this.activeProductCount,
  });

  String category;
  String label;
  String type;
  int sequence;
  List<SetsInfo> setsInfo;
  int activeProductCount;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        category: json["category"],
        label: json["label"],
        type: json["type"],
        sequence: json["sequence"],
        setsInfo: List<SetsInfo>.from(
            json["sets_info"].map((x) => SetsInfo.fromJson(x))),
        activeProductCount: json["active_product_count"],
      );

  Map<String, dynamic> toJson() => {
        "category": category,
        "label": label,
        "type": type,
        "sequence": sequence,
        "sets_info": List<dynamic>.from(setsInfo.map((x) => x.toJson())),
        "active_product_count": activeProductCount,
      };
}

class SetsInfo {
  SetsInfo({
    required this.setCategory,
    required this.category,
    required this.type,
    required this.categorySingular,
    required this.dataKey,
    required this.codeKey,
  });

  String setCategory;
  String category;
  String type;
  String categorySingular;
  String dataKey;
  String codeKey;

  factory SetsInfo.fromJson(Map<String, dynamic> json) => SetsInfo(
        setCategory: json["set_category"],
        category: json["category"],
        type: json["type"],
        categorySingular: json["category_singular"],
        dataKey: json["data_key"],
        codeKey: json["code_key"],
      );

  Map<String, dynamic> toJson() => {
        "set_category": setCategory,
        "category": category,
        "type": type,
        "category_singular": categorySingular,
        "data_key": dataKey,
        "code_key": codeKey,
      };
}

class Meta {
  Meta({
    required this.message,
    required this.code,
  });

  String message;
  int code;

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        message: json["message"],
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "code": code,
      };
}
