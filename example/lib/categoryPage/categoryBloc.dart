import 'dart:async';
import 'dart:convert';

import 'package:checkbox_grouped/checkbox_grouped.dart';
import 'package:flutter/material.dart';
import 'package:plugin_mirrar_example/launch_mirrar.dart';
import 'package:plugin_mirrar_example/models/dynamicInventory.dart';
import 'package:plugin_mirrar_example/models/manageInventory.dart';

import '../commonUtils/commonMethods.dart';
import '../models/categoriesResponse.dart';
import '../models/errorResponse.dart';

class CategoryBloc {
  BuildContext context;
  String brandId;
  late String jsonData;
  List<DynamicInventory> inventory;
  late TabController tabController;
  List<Tab> tabs = [];
  int pageNo = 1;
  int gridItemIndex = 0;
  late CategoriesResponse categories;
  late CommonMethods commonMethods;
  ScrollController gridScrollController = ScrollController();
  List<DynamicInventory> inventories = [];

  final loadingCtrl = StreamController<bool>.broadcast();

  Map<String, Map<String, dynamic>> selectedItems =
      <String, Map<String, dynamic>>{};

  CategoryBloc(
      {required this.inventory, required this.brandId, required this.context});

  void init() {
    for (var i in inventory) {
      tabs.add(Tab(
        text: i.category,
      ));
    }
    gridScrollController.addListener(() {
      if (gridScrollController.hasClients) {
        if (gridScrollController.position.maxScrollExtent ==
            gridScrollController.offset) {
          pageNo += 1;
          fetchDataPage();
        }
      }
    });
  }

  void fetchDataPage() async {
    try {
      // start loading
      if (!loadingCtrl.isClosed) loadingCtrl.sink.add(false);
      commonMethods = CommonMethods(brandId: brandId);
      var response = await commonMethods.getInventorybyPage(
          category: inventory[tabController.index].category,
          type: inventory[tabController.index].categoryType,
          pageNo: pageNo);
      inventory[tabController.index]
          .inventoryResponse
          .data
          .addAll(response.inventoryResponse.data);
    } on ErrorResponse catch (error) {
      CommonWidgets.errorDialog(context, error.meta.message);
      if (!loadingCtrl.isClosed) loadingCtrl.sink.add(false);
    } catch (exception) {
      CommonWidgets.errorDialog(context, exception.toString());
      if (!loadingCtrl.isClosed) loadingCtrl.sink.add(false);
    } finally {
      // stop loading
      if (!loadingCtrl.isClosed) loadingCtrl.sink.add(true);
    }
  }

  void onSubmit() {
    jsonData =
        "{\"options\":{\"productData\":${json.encode(selectedItems)}}\n}";
    print(jsonData);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: ((context) => MirrarPage(
                  jsonData: jsonData,
                  brandID: brandId,
                ))));
  }
}
