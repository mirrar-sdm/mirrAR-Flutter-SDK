import 'package:flutter/material.dart';
import 'package:plugin_mirrar/mirrar_sdk.dart';
import 'package:plugin_mirrar_example/commonUtils/commonMethods.dart';

class MirrarPage extends StatefulWidget {
  final String jsonData;
  final String brandID;

  const MirrarPage({Key? key, required this.jsonData, required this.brandID})
      : super(key: key);

  @override
  _CounterPageState createState() => _CounterPageState();
}

class _CounterPageState extends State<MirrarPage> {
  int count = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: MirrarSDK(
      jsonData: widget.jsonData,
      uuid: widget.brandID,
      onMessageCallback: (String event, String message, String productCode) {
        if (event == "details") {
          CommonWidgets.callbackDialog(
              context, "details event called for product $productCode");
        } else if (event == "whatsapp") {
          //message is the image url
          CommonWidgets.callbackDialog(context, "whatsapp event called");
        } else if (event == "download") {
          //message is the image uri
          CommonWidgets.callbackDialog(context, "download event called");
        } else if (event == "wishlist") {
          //message is the product_code
          CommonWidgets.callbackDialog(
              context, "wishlist event called for product $productCode");
        } else if (event == "unwishlist") {
          //message is the product_code
          CommonWidgets.callbackDialog(
              context, "unwishlist event called for product $productCode");
        } else if (event == "cart") {
          //message is the product_code
          CommonWidgets.callbackDialog(
              context, "cart event called for product $productCode");
        } else if (event == "remove_cart") {
          //message is the product_code
          CommonWidgets.callbackDialog(
              context, "remove cart event called for product $productCode");
        } else if (event == "share") {
          //message is the image uri
          CommonWidgets.callbackDialog(context, "share event called");
        } else if (event == "mirrar-popup-closed") {
          //message is the product_code
          CommonWidgets.callbackDialog(context,
              "mirrar popup closed event called for product $productCode");
        }
      },
    ));
  }
}
