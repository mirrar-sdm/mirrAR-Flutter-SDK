import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;
import 'package:plugin_mirrar/mirrar_sdk.dart';
import 'package:plugin_mirrar_example/UI/note.dart';
import 'package:plugin_mirrar_example/UI/skin_screen.dart';


class UploadImageSkin extends StatefulWidget {
  @override
  _UploadImageContainerState createState() => _UploadImageContainerState();
}

class _UploadImageContainerState extends State<UploadImageSkin> {
  File? _selectedImage;
  String? _base64String;
  var openNote = false;
  bool isLoading = false; 

Future<void> _selectImage(BuildContext context) async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Select Image'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              GestureDetector(
                child: Text('Camera'),
                onTap: () {
                  _getImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
              Padding(padding: EdgeInsets.all(8.0)),
              GestureDetector(
                child: Text('Gallery'),
                onTap: () {
                  _getImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}
  Future<void> _getImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await ImagePicker.pickImage(source: source);

    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
        _base64String = base64Encode(_selectedImage!.readAsBytesSync());
        _resizeAndEncodeImage();
      });
    }
  }

Future<void> _resizeAndEncodeImage() async {
  if (_selectedImage == null) return;

  final tempDir = await getTemporaryDirectory();
  final targetPath = '${tempDir.path}/resized_image.png';

  final imageBytes = await _selectedImage!.readAsBytes();
  final image = img.decodeImage(imageBytes.toList());

  final resizedImage = img.copyResize(image!, width: 640, height: 480);
  final resizedBytes = img.encodeJpg(resizedImage);

  await File(targetPath).writeAsBytes(resizedBytes);

  final bytes = await File(targetPath).readAsBytes();
  setState(() {
    _base64String = base64Encode(bytes);
  });
}


  void navigateToCameraNote(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CameraNote()),
    );

    _selectImage(context);
    print("checkResulkt: $result");
    // Handle the result here if needed
    // ...
  }
   @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        navigateToCameraNote(context);
      },
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(30, 0, 30, 10),
                height: 400,
                width: 350,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_selectedImage != null)
                      Container(
                        height: 400,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          image: DecorationImage(
                            image: FileImage(_selectedImage!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    else
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.upload,
                            size: 50,
                            color: Colors.white,
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Upload',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith(
                        (states) => Colors.white,
                      ),
                    ),
                    onPressed: () {
                      startDiagnosis();
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Start Diagnosis',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (isLoading)
            Container(
    
              margin: EdgeInsets.fromLTRB(0, 150, 0, 0),
              child: Center(
                child: CircularProgressIndicator(
                  color: Color.fromRGBO(152, 34, 84, 1),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> startDiagnosis() async {
    if (_base64String == null) {
      // Handle null case
      return;
    }

    setState(() {
      isLoading = true; // Set loading state to true
    });

    final response = await MirrarSDK.myApiFunction(_base64String!);

    setState(() {
      isLoading = false; // Set loading state to false
    });

    if (response != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SkinScreen(
            jsonData: jsonDecode(response),
            imageBase: _base64String!,
          ),
        ),
      );
    }
  }
}