// To parse this JSON data, do
//
//     final inventoryResponse = inventoryResponseFromJson(jsonString);

import 'dart:convert';

InventoryResponse inventoryResponseFromJson(String str) =>
    InventoryResponse.fromJson(json.decode(str));

String inventoryResponseToJson(InventoryResponse data) =>
    json.encode(data.toJson());

class InventoryResponse {
  InventoryResponse({
    required this.data,
  });

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
  Datum({
    required this.data,
    required this.productCode,
    this.isChecked = false,
  });

  Data data;

  String productCode;

  bool isChecked;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
      data: Data.fromJson(json["data"]),
      productCode: json["product_code"],
      isChecked: json["is_checked"] == null ? false : json["is_checked"]);

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "product_code": productCode,
        "is_checked": isChecked
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
