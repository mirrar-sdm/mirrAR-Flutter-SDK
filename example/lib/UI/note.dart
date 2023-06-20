import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:plugin_mirrar_example/UI/footer.dart';

import 'skin_items.dart';

class CameraNote extends StatelessWidget {
 void goBackAndExecuteFunction(BuildContext context) {
    // Execute the desired function here
    // ...

    // Go back to the previous screen (A widget)
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
     const IconData upload = IconData(0xe695, fontFamily: 'MaterialIcons');
    return MaterialApp(
      home: Scaffold(
      backgroundColor: Colors.black,
        body: Column(
        children:[
          Expanded(child: 
          Container(
          color: Colors.black,
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
             Container(
      margin: EdgeInsets.fromLTRB(10, 170, 10, 10),
      height: 450,
      decoration: BoxDecoration(
        color: Color.fromRGBO(28, 28, 28, 1),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
        child: Column(
        children:[
          Center(child: Text("Important Instructions",style: TextStyle(
            fontSize:16,
            fontWeight: FontWeight.bold,
            color: Colors.white),)),
          Padding(padding: EdgeInsets.all(30),
          child:
           Text("In order to get the best results from the smart mirror, please follow these instructions - \n"+
"1. If you have long hair, please tie your hair.\n"+
"2. If you are wearing any eyeglasses, please remove the eyeglasses.\n"+
"3. Look straight in the mirror with your face properly visible.\n"+
"4. Please try to keep a neutral expression for the best results."
,style: TextStyle(color: Colors.white)
))

,
 SizedBox(width: 10.0),
                      ElevatedButton(
                        style: ButtonStyle(backgroundColor:  MaterialStateProperty.resolveWith((states) => Color.fromRGBO(152, 34, 84, 1)),),
                        onPressed: () {
                          // Handle button 2 onPressed
                        goBackAndExecuteFunction(context);
                        },
                        child: Text('Ready'),
                      ),
        ])))
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
