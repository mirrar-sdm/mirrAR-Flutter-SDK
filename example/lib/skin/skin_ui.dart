import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:plugin_mirrar/mirrar_sdk.dart';
import 'package:plugin_mirrar_example/UI/footer.dart';

import 'upload_image_skin.dart';

class SkinUi extends StatelessWidget {

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
              
              SizedBox(height: 100.0),
               
              UploadImageSkin(),

            
              SizedBox(width: 20.0,height: 60,),
              
              

         
             
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
