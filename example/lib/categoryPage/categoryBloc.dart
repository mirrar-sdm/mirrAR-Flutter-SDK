import 'dart:async';

import 'package:checkbox_grouped/checkbox_grouped.dart';
import 'package:flutter/material.dart';
import 'package:plugin_mirrar_example/commonUtils/commonMethods.dart';
import 'package:plugin_mirrar_example/models/categoriesResponse.dart';
import 'package:plugin_mirrar_example/models/inventoryResponse.dart';
import 'package:plugin_mirrar_example/models/manageInventory.dart';
import 'package:plugin_mirrar_example/models/selectedItemsRequest.dart';

class CategoryBloc {
  BuildContext context;
  String brandId;
  List<ManageInventory> inventory;
  late TabController tabController;
  List<Tab> tabs = [];
  List<SelectedItemsRequest> selectedItems = [];
  List<String> selectedProductCodes = [];
  bool isItemSelected = false;
  GroupController controller = GroupController();
  List<int> selectedItemsIndex = [];

  CategoryBloc(
      {required this.inventory, required this.brandId, required this.context});

  void init() {
    for (var i in inventory) {
      tabs.add(Tab(
        text: i.category,
      ));
    }
  }

  void onSubmit() {
    for (var i in inventory.where((element) => element.isChecked == true)) {
      for (var j in i.inventoryResponse.data.where((element) =>
          element.isChecked == true &&
          element.productCode == i.category.contains(element.productCode))) {
        selectedProductCodes.add(j.productCode);
        selectedItems.add(SelectedItemsRequest(
            category: i.category,
            categoryType: i.categoryType,
            productCode: selectedProductCodes));
      }
    }
    for (var i in selectedItems) {
      print("${i.category},${i.categoryType},${i.productCode}");
    }
  }
}
