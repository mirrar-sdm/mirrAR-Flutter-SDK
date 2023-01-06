import 'package:plugin_mirrar_example/models/inventoryResponse.dart';

class SelectedItemsRequest {
  String category;
  String categoryType;
  List<String> productCode;

  SelectedItemsRequest(
      {required this.category,
      required this.categoryType,
      required this.productCode});
}
