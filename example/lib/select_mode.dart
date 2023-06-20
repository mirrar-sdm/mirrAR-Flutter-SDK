import 'package:flutter/material.dart';
import 'package:plugin_mirrar/mirrar_sdk.dart';
import 'package:plugin_mirrar/open_webview.dart';
import 'package:plugin_mirrar_example/hair/hair_ui.dart';
import 'package:plugin_mirrar_example/skin/skin_ui.dart';
import 'package:plugin_mirrar_example/skin/upload_image_skin.dart';


class SelectMode extends StatelessWidget {
    int count = 0;
  String jsonData =
      "{\"options\":{\"productData\":{\"Earrings\":{\"items\":[\"0079-500x500\",\"0097-500x500\",\"00118-500x500sdfghjk\"],\"type\":\"ear\"},\"Sets\":{\"items\":[\"DSC_0206S\",\"DSC_0204S\"],\"type\":\"set\"}}}\n}";
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      home: Scaffold(
        appBar:null,
        body: Center(
          child: Container(
            color: Color(0xFFDEE4F4),
          child: Column(
            children: [
              Row(
                children: [
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      // Handle cross image onPressed
                    },
                  ),
                ],
              ),
              
            Center(
          child: Column(
                children: [ Container(
                  margin:const EdgeInsets.only(top: 200),
                  child: Text(
                    'Start your journey',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
          
             Container(
                  margin: const EdgeInsets.only(top: 70),
                  child:  Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.all(10),
                    height: 110,
                    width: 100,
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(8.0), // Adjust the border radius as needed
    border: Border.all(
      color: Colors.white,
      width: 1.0,
    ),
  ),
  child: Padding(
    padding: EdgeInsets.all(10),
  child:FlatButton(
    onPressed: () {
      // Handle Card 1 onPressed
      Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HairUI()));
      
    },
    child: Column(
      children: [
        Image.asset('assets/images/hair.png'),
         Padding(
    padding: EdgeInsets.fromLTRB(0,20,0,0),
  child:Text('Hair'),
         )
      ],
    ),
  ),
),
                  ),

Container(
                    margin: EdgeInsets.all(10),
                    height: 110,
                    width: 100,
  decoration: BoxDecoration(
        color: Colors.white,

    borderRadius: BorderRadius.circular(8.0), // Adjust the border radius as needed
    border: Border.all(
      color: Colors.white,
      width: 1.0,
    ),
  ),
  child: Padding(
    padding: EdgeInsets.all(10),
  child: FlatButton(
    onPressed: () {
      // Handle Card 1 onPressed
      Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SkinUi()));
    },
    child: Column(
      children: [
       Image.asset('assets/images/face.png'),
       Padding(
    padding: EdgeInsets.fromLTRB(0,14,0,0),
  child:Text('Skin'),
         )
      ],
    ),
  ),)
),

Container(
                    margin: EdgeInsets.all(10),
                    height: 110,
                    width: 100,
  decoration: BoxDecoration(
        color: Colors.white,

    borderRadius: BorderRadius.circular(8.0), // Adjust the border radius as needed
    border: Border.all(
      color: Colors.white,
      width: 1.0,
    ),
  ),
  child: Padding(
    padding: EdgeInsets.all(5),
  child:FlatButton(
    onPressed: () {
      // Handle Card 1 onPressed

      Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>   Makeup(
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
    )));
                                    
                      

    
  
    },
    child: Column(
      children: [
        Image.asset('assets/images/makeover.png'),
        Padding(
    padding: EdgeInsets.fromLTRB(0,16,0,0),
  child:Text('Makeup'),
         )
      ],
    ),
  ),)
),
            
                ],
              ),),
            ])),
            ],
          ),
        ),
        )
      ),
    );
  }
}

class CardButton extends StatelessWidget {
  final Image image;
  final String text;
  final VoidCallback onPressed;

  const CardButton({required this.image, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
  height: 150, // Replace with desired height
  width: 120, // Replace with desired width
  child: Card(
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding:const EdgeInsets.all(10.0),
            child:image,
          )
        ),
        Text(text),
      ],
    ),
  ),
),
    );
  }
}