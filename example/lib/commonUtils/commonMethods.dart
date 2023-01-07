import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:plugin_mirrar_example/commonUtils/httpService.dart';
import 'package:plugin_mirrar_example/models/categoriesResponse.dart';
import 'package:plugin_mirrar_example/models/dynamicInventory.dart';
import 'package:plugin_mirrar_example/models/inventoryResponse.dart';

class CommonMethods {
  late HttpService httpService;
  final String brandId;
  CommonMethods({required this.brandId}) {
    httpService = HttpService();
  }

  Future<CategoriesResponse> getCategories() async {
    Map<String, dynamic> response;
    //#region Region - Execute Request
    response = await httpService.apiCallGet(
        apiUrl: "https://m.mirrar.com/api/v1/brands/$brandId/categories",
        timeOut: 60,
        headerData: null);

    return CategoriesResponse.fromJson(response);
  }

  Future<DynamicInventory> getInventory(
      {required String category, required String type}) async {
    Map<String, dynamic> response;

    Map<String, String> dataKeys = {"earring_data": "", "necklace_data": ""};

    var map = <String, dynamic>{};
    map['limit'] = "24";
    map['filter_field[disable]'] = "0";
    map['filter_field[isSetOnly]'] = "0";
    map['sort_field'] = "order_key";
    map['sort_by'] = "asc";

    //#region Region - Execute Request
    response = await httpService.apiCallPost(
        apiUrl:
            "https://m.mirrar.com/api/v1/brands/$brandId/categories/$category/inventories",
        formData: map,
        timeOut: 60,
        headerData: null);

    // function to add sets data
    void addSetsData(List<dynamic> metadata) {
      // fetching for earring_data
      for (var metaElement
          in metadata.where((element) => element["type"] == "ear")) {
        var key = metaElement["data_key"];
        print(response["data"][0][key]);
        dataKeys["earring_data"] = key;
      }

      // fetching for necklace_data
      for (var metaElement
          in metadata.where((element) => element["type"] == "neck")) {
        var key = metaElement["data_key"];
        dataKeys["necklace_data"] = key;
      }
    }

    List<dynamic> getSetMeta(data, type) {
      if (type == "set" && data.length > 0) {
        var product = data[0];
        var setMetas = product['meta'];
        return setMetas;
      }
      return [];
    }

    var setsMeta = getSetMeta(response["data"], type);
    if (setsMeta.length > 0) {
      addSetsData(setsMeta);
    }

    return DynamicInventory(
        inventoryResponse: InventoryResponse.fromJson(response),
        category: "",
        categoryType: "",
        setData: dataKeys);
  }
}

class CommonWidgets {
  static void errorDialog(BuildContext context, String errorMessage) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Column(children: [
                const SizedBox(height: 16),
                const Text(
                  "Error",
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20.0),
                Text(
                  errorMessage,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20.0),
                SizedBox(
                    width: 100,
                    height: 40,
                    child: ElevatedButton(
                      child: const Text("OK"),
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.pink,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0),
                        ),
                      ),
                    )),
                //  )
              ]),
              // contentPadding: EdgeInsets.only(left: 100, right: 100),
            ));
  }

  static void callbackDialog(BuildContext context, String errorMessage) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Column(children: [
                const SizedBox(height: 16),
                const Text(
                  "Callback",
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20.0),
                Text(
                  errorMessage,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20.0),
                SizedBox(
                    width: 100,
                    height: 40,
                    child: ElevatedButton(
                      child: const Text("OK"),
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.pink,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0),
                        ),
                      ),
                    )),
                //  )
              ]),
              // contentPadding: EdgeInsets.only(left: 100, right: 100),
            ));
  }
}
