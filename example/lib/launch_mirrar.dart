import 'package:flutter/material.dart';
import 'package:plugin_mirrar/mirrar_sdk.dart';

class MirrarPage extends StatefulWidget {
  _CounterPageState createState() => _CounterPageState();
}

class _CounterPageState extends State<MirrarPage> {
  int count = 0;
  String jsonData =
      "{\"options\":{\"productData\":{\"Earrings\":{\"items\":[\"0079-500x500\",\"0097-500x500\",\"00118-500x500sdfghjk\"],\"type\":\"ear\"},\"Sets\":{\"items\":[\"DSC_0206S\",\"DSC_0204S\"],\"type\":\"set\"}}}\n}";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: MirrarSDK(
      jsonData: jsonData,
      uuid: '',
      onMessageCallback: (String event,String message) {
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
        } else if(event=="share"){
          //message is the image uri
        }else if (event == "mirrar-popup-closed") {
          //message is the product_code
        }
      },
    ));
  }
}
