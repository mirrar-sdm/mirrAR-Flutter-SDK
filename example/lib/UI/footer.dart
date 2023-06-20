 
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:plugin_mirrar/mirrar_sdk.dart';

import 'skin_items.dart';

class Footer extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    return Container(
                color: Colors.white,
                child:
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(   
                    margin: EdgeInsets.fromLTRB(20, 0, 0, 0),                
                    height: 80,
                    width: 80,         
                    child:
                  Image.asset('assets/images/mirrar_logo.png')), // Replace with your image path
              
                ],
              ),
              );
  }}