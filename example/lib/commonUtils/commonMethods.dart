import 'package:flutter/material.dart';
import 'package:plugin_mirrar_example/commonUtils/httpService.dart';
import 'package:plugin_mirrar_example/models/categoriesResponse.dart';
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
    response = await httpService.apiCall(
        apiUrl: "https://m.mirrar.com/api/v1/brands/$brandId/categories",
        timeOut: 60,
        headerData: null);

    return CategoriesResponse.fromJson(response);
  }

  Future<InventoryResponse> getInventory({required String category}) async {
    Map<String, dynamic> response;

    //#region Region - Execute Request
    response = await httpService.apiCall(
        apiUrl:
            "https://m.mirrar.com/api/v1/brands/$brandId/categories/$category/inventories?limit=24",
        timeOut: 60,
        headerData: null);

    return InventoryResponse.fromJson(response);
  }
}

class CommonWidgets {
  static void errorDialog(BuildContext context, String errorMessage) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Column(children: [
                SizedBox(height: 16),
                Text(
                  "Error",
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20.0),
                Text(
                  "$errorMessage",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20.0),
                Container(
                    width: 100,
                    height: 40,
                    child: ElevatedButton(
                      child: Text("OK"),
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.pink,
                        onPrimary: Colors.white,
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
