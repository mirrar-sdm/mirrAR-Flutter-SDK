import 'package:plugin_mirrar_example/models/inventoryResponse.dart';

class ManageInventory {
  String category;
  String categoryType;
  bool isChecked;
  InventoryResponse inventoryResponse;

  ManageInventory(
      {required this.category,
      required this.categoryType,
      this.isChecked = false,
      required this.inventoryResponse});
}
