import 'package:plugin_mirrar_example/models/inventoryResponse.dart';

class DynamicInventory {
  Map<String, String> setData;
  InventoryResponse inventoryResponse;
  String category;
  String categoryType;

  DynamicInventory(
      {required this.setData,
      required this.inventoryResponse,
      required this.category,
      required this.categoryType});
}
