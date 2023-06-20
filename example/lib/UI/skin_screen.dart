import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:plugin_mirrar_example/UI/footer.dart';

import 'skin_items.dart';

class SkinScreen extends StatelessWidget {
  final Map<String, dynamic> jsonData;
  final String imageBase;

  SkinScreen({required this.jsonData,required this.imageBase});
  @override
  Widget build(BuildContext context) {
     const IconData upload = IconData(0xe695, fontFamily: 'MaterialIcons');
    return MaterialApp(
      home: Scaffold(
        appBar: null,
        body: Column(
        children:[
          Expanded(child: 
          Container(
          color: Color(0xFFDEE4F4),
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              
              
                Stack(
            children: [
            
            Padding(
              padding: EdgeInsets.fromLTRB(0, 70, 0, 0),
              child: SkinItems(jsonData: jsonData),),

             
                Container(
  margin: EdgeInsets.fromLTRB(110, 10, 0, 0),
  width: 140,
  height: 200,
  decoration: BoxDecoration(
    color: Colors.grey,
    borderRadius: BorderRadius.circular(20),
  ),
  child: ClipRRect(
    borderRadius: BorderRadius.circular(20),
    child: Image.memory(
      base64Decode(imageBase),
      fit: BoxFit.fill,
    ),
  ),
),
            ]),
            ],
          ),
        ),),
      Footer(
             
            ),
              ])
      ),
    );
  }
}
