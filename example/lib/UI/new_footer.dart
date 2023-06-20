 
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:plugin_mirrar/mirrar_sdk.dart';

import 'skin_items.dart';

class NewFooter extends StatelessWidget {

 final VoidCallback onBackButtonPressed;

  NewFooter({required this.onBackButtonPressed});

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
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(1),
                        child: ElevatedButton(
  style: ButtonStyle(
    backgroundColor: MaterialStateProperty.resolveWith((states) =>Colors.black,),
  ),
     onPressed: onBackButtonPressed,

  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
    
      Icon(Icons.arrow_back, size: 20),
    ],
  ),
)),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: ElevatedButton(
  style: ButtonStyle(
    backgroundColor: MaterialStateProperty.resolveWith((states) =>Color.fromRGBO(152, 34, 84, 1),),
  ),
  onPressed: () {
    // Handle button onPressed
   //MirrarSDK.getHairStyles()
  },
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text('Continue'),
      Icon(Icons.arrow_forward, size: 20),
    ],
  ),
)),

                    ],
                  ),
                ],
              ),
              );
  }}