import 'package:flutter/material.dart';
import 'package:plugin_mirrar/mirrar_sdk.dart';

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
      onMessageCallback: (String event, String message) {
        if (event == "details") {
          //message is the product_code
        } else if (event == "whatsapp") {
          //message is the image url
        } else if (event == "download") {
          //message is the image uri
        } else if (event == "wishlist") {
          //message is the product_code
        } else if (event == "unwishlist") {
          //message is the product_code
        } else if (event == "cart") {
          //message is the product_code
        } else if (event == "remove_cart") {
          //message is the product_code
        } else if (event == "share") {
          //message is the image uri
        } else if (event == "mirrar-popup-closed") {
          //message is the product_code
        }
      },
    ));
  }
}
