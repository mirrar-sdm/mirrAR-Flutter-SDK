import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class SkinItems extends StatelessWidget {
final Map<String, dynamic> jsonData;

  SkinItems({required this.jsonData});
List<Widget> _buildNestedWidgets(Map<dynamic, dynamic> data) {
  List<Widget> widgets = [];

  data.forEach((key, value) {
    if (value is Map<dynamic, dynamic>) {
      widgets.addAll(_buildNestedWidgets(value.cast<String, dynamic>()));
    } else {
      String modifiedKey = key.toString().replaceAll('_', ' ');
      modifiedKey = modifiedKey.replaceAll(RegExp(r'\bscore\b'), '');

      widgets.add(Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                margin: EdgeInsets.all(5),
                height: 40,
                width: 40,
                child: CircularProgressIndicator(
                   color: Color.fromRGBO(152, 34, 84, 1),
                  backgroundColor: Color.fromRGBO(195, 195, 195, 0.5),
                  strokeWidth: 6,
                  value: value/100,
                ),
              ),
              Text(
                '$value',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.0),
          Text(
            '$modifiedKey',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ));
    }
  });

  return widgets;
}

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 30, 10, 10),
      height: 550,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
        margin: EdgeInsets.fromLTRB(10, 130, 10, 30),
        child: GridView.count(
          crossAxisCount: 4,
          childAspectRatio: 0.8,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          children: _buildNestedWidgets(jsonData['data']['output']['outputData'].cast<dynamic, dynamic>()),
        ),
      ),
    );
  }
}






