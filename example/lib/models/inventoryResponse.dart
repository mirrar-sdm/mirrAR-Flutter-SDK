// To parse this JSON data, do
//
//     final inventoryResponse = inventoryResponseFromJson(jsonString);

import 'dart:convert';

InventoryResponse inventoryResponseFromJson(String str) =>
    InventoryResponse.fromJson(json.decode(str));

String inventoryResponseToJson(InventoryResponse data) =>
    json.encode(data.toJson());

class InventoryResponse {
  InventoryResponse({required this.data});

  List<Datum> data;

  factory InventoryResponse.fromJson(Map<String, dynamic> json) =>
      InventoryResponse(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum(
      {required this.data,
      required this.productCode,
      this.isChecked = false,
      required this.rawData
      // required this.meta,
      });

  Data data;

  String productCode;

  bool isChecked;

  dynamic rawData;

  // List<Metaa> meta;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
      data: Data.fromJson(json["data"]),
      rawData: json,
      productCode: json["product_code"],
      isChecked: json["is_checked"] == null ? false : json["is_checked"]

      // meta: List<Metaa>.from(json["meta"].map((e) => Metaa.fromJson(e))),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "product_code": productCode,
        "is_checked": isChecked,
        "rawData": rawData
      };
}

class Metaa {
  Metaa(
      {required this.type,
      required this.category,
      required this.codeKey,
      required this.dataKey});

  String type;
  String category;
  String codeKey;
  String dataKey;

  factory Metaa.fromJson(Map<String, dynamic> json) => Metaa(
      type: json["type"],
      category: json["category"],
      codeKey: json["code_key"],
      dataKey: json["data_key"]);

  Map<String, dynamic> toJson() => {
        "type": type,
        "category": category,
        "code_key": codeKey,
        "data_key": dataKey,
      };
}

class Data {
  Data({
    required this.imageUrl,
  });

  String imageUrl;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        imageUrl: json["image_url"] == null ? "" : json["image_url"],
      );

  Map<String, dynamic> toJson() => {
        "image_url": imageUrl,
      };
}
