import 'dart:convert';

import 'package:checkbox_grouped/checkbox_grouped.dart';
import 'package:flutter/material.dart';
import 'package:plugin_mirrar_example/launch_mirrar.dart';
import 'package:plugin_mirrar_example/models/dynamicInventory.dart';
import 'package:plugin_mirrar_example/models/manageInventory.dart';

class CategoryBloc {
  BuildContext context;
  String brandId;
  late String jsonData;
  List<DynamicInventory> inventory;
  late TabController tabController;
  List<Tab> tabs = [];
  GroupController controller = GroupController();
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
