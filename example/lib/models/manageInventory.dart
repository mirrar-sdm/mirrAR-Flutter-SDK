import 'package:plugin_mirrar_example/models/dynamicInventory.dart';
import 'package:plugin_mirrar_example/models/inventoryResponse.dart';

class ManageInventory {
  String category;
  String categoryType;
  bool isChecked;
  DynamicInventory inventoryResponse;

  ManageInventory(
      {required this.category,
      required this.categoryType,
      this.isChecked = false,
      required this.inventoryResponse});
}
