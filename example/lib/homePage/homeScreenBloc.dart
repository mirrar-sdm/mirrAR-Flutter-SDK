import 'dart:async';

import 'package:flutter/material.dart';
import 'package:plugin_mirrar_example/categoryPage/categoryScreen.dart';
import 'package:plugin_mirrar_example/commonUtils/commonMethods.dart';
import 'package:plugin_mirrar_example/models/categoriesResponse.dart';
import 'package:plugin_mirrar_example/models/dynamicInventory.dart';
import 'package:plugin_mirrar_example/models/errorResponse.dart';
import 'package:plugin_mirrar_example/models/inventoryResponse.dart';

import '../models/manageInventory.dart';

class HomeBloc {
  late BuildContext _context;
  final brandIdController = new TextEditingController();
  final loadingCtrl = StreamController<bool>.broadcast();
  late CategoriesResponse categories;
  late CommonMethods commonMethods;
  late Map<String, List<Map<String, dynamic>>> setData;
  List<DynamicInventory> inventories = [];

  HomeBloc(this._context);

  void init() {}

  void onSubmit() async {
    // try {
    // // start loading
    // if (!loadingCtrl.isClosed) loadingCtrl.sink.add(true);
    commonMethods = CommonMethods(brandId: brandIdController.text);
    categories = await commonMethods.getCategories();
    for (var category in categories.data) {
      var response = await commonMethods.getInventory(
          category: category.label, type: category.type);
      inventories.add(DynamicInventory(
          setData: response.setData,
          inventoryResponse: response.inventoryResponse,
          category: category.label,
          categoryType: category.type));
    }
    Navigator.push(
        _context,
        MaterialPageRoute(
            builder: ((context) => CategoryScreen(
                  inventory: inventories,
                  brandId: brandIdController.text,
                ))));
    // } on ErrorResponse catch (error) {
    //   CommonWidgets.errorDialog(_context, error.meta.message);
    //   if (!loadingCtrl.isClosed) loadingCtrl.sink.add(false);
    // } catch (exception) {
    //   CommonWidgets.errorDialog(_context, exception.toString());
    //   if (!loadingCtrl.isClosed) loadingCtrl.sink.add(false);
    // } finally {
    //   // stop loading
    //   if (!loadingCtrl.isClosed) loadingCtrl.sink.add(false);
    // }
  }
}
