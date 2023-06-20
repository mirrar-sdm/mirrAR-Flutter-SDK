import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:plugin_mirrar/mirrar_sdk.dart';
import 'package:plugin_mirrar_example/UI/footer.dart';
import 'package:dio/dio.dart';
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
import 'package:async/async.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'upload_image_hair.dart';


class HairUI extends StatefulWidget {
  @override
  _HairUIState createState() => _HairUIState();
}

class _HairUIState extends State<HairUI> {
  List<dynamic> hairStyles = [];
  String _userImageId="";


  @override
  void initState() {
    super.initState();
    callHairStyle();
  }


  File? _selectedImage;
  String? resultImageUrl="";
  String? _base64String;
 var openNote=false;
 bool _isUploading = false;
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
        resultImageUrl="";
        _selectedImage = File(pickedImage.path);
        _base64String = base64Encode(_selectedImage!.readAsBytesSync());
        convertAndUpload(_selectedImage!);
      });
    }
  }

   Future<void> convertAndUpload(File imageFile) async {
    setState(() {
      
      _isUploading = true;
    });
   final tempDir = await getTemporaryDirectory();
  final targetPath = '${tempDir.path}/resized_image.png';

  final imageBytes = await imageFile.readAsBytes();
  final image = img.decodeImage(imageBytes.toList());

  final resizedImage = img.copyResize(image!, width: 480, height: 640);
  final resizedBytes = img.encodePng(resizedImage);

  await File(targetPath).writeAsBytes(resizedBytes);

  final resizedImageFile = File(targetPath);

    var stream = new http.ByteStream(DelegatingStream.typed(resizedImageFile.openRead()));
    var length = await resizedImageFile.length();

    var uri = Uri.parse("https://api.hair.mirrar.io/tryon/embed/");

    var request = new http.MultipartRequest("POST", uri);
    var multipartFile = new http.MultipartFile('user_image', stream, length,
        filename: basename(resizedImageFile.path));

    request.files.add(multipartFile);

    // Set _isUploading to true to show the progress bar
    

    var response = await request.send();

   if (response.statusCode == 200) {
  // Handle the response here
  String responseString = await response.stream.transform(utf8.decoder).join();
  Map<String, dynamic> responseData = jsonDecode(responseString);
  print("checkString: $responseData");
    String userImageId = responseData['user_image_id'].toString();
  print('user_image_id: $userImageId');

  setState(() {
    _userImageId=userImageId;
    _isUploading = false;
  });
} else {
  // Handle the error case
  setState(() {
    _isUploading = false;
  });
}

    // Set _isUploading to false to hide the progress bar
  
  }



Future<void> _resizeAndEncodeImage() async {
  if (_selectedImage == null) return;

  final tempDir = await getTemporaryDirectory();
  final targetPath = '${tempDir.path}/resized_image.png';

  final imageBytes = await _selectedImage!.readAsBytes();
  final image = img.decodeImage(imageBytes.toList());

  final resizedImage = img.copyResize(image!, width: 480, height: 640);
  final resizedBytes = img.encodeJpg(resizedImage);

  await File(targetPath).writeAsBytes(resizedBytes);

  final url = Uri.parse('https://api.hair.mirrar.io/tryon/embed/');
  final request = http.MultipartRequest('POST', url);

  request.files.add(await http.MultipartFile.fromPath('user_image', targetPath));

  final response = await http.Response.fromStream(await request.send());
  print('Request failed with status: ${response.statusCode} and ${targetPath}');

  if (response.statusCode == 200) {
    final responseData = response.body;
    // Handle the response data here
    print("responsecheck  " + responseData);
  } else {
    // Handle the error case
    print('Request failed with status: ${response.body}');
  }
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

  void callHairStyle() async {
    
  final responseJson = await MirrarSDK.fetchHairStyle();
  if(responseJson!=null){
final response = jsonDecode(responseJson);
    final hairStyleData = response['data']['hairStyle'];

    setState(() {
      hairStyles = hairStyleData;
    });
  }
  }
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
               
              GestureDetector(
      onTap: () {
        navigateToCameraNote(context);
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(30, 10, 30, 10),
        height: 350,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Stack(
          children: [
            if (_selectedImage != null)
              Container(
                height: 350,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  image: resultImageUrl!.isEmpty?DecorationImage(
                    image:  FileImage(_selectedImage!),
                    fit: BoxFit.cover,
                  ):
                  DecorationImage(
                    image:  NetworkImage(resultImageUrl!),
                    fit: BoxFit.cover,
                  )
                  
                ),
              )
            else
              Center(child: Column(
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
              ),),
            if (_isUploading)
              Center(
                child: CircularProgressIndicator(
                  color: Color.fromRGBO(152, 34, 84, 1),
                ),
              ),
          ],
        ),
      ),
    ),

            
              SizedBox(width: 20.0,height: 20,),
              
              SizedBox(height: 20.0),
            Expanded(
  child: ListView.builder(
    scrollDirection: Axis.horizontal,
    itemCount: hairStyles.length,
    itemBuilder: (context, index) {
      final hairStyle = hairStyles[index];
      final thumbnailImage = hairStyle['hairStyleThumbnailImage'];
      final hairStyleIdentifier = hairStyle['hairStyleIdentifier'];

      return GestureDetector(
        onTap: () {
          // Handle the onClick event here
          // You can perform any actions or navigate to another screen
            setState(() {
      _isUploading = true;
    });
          callImageApi(hairStyleIdentifier);
          print('Clicked on card $index with hairStyleIdentifier: $hairStyleIdentifier');
        },
        child: Container(
          margin: EdgeInsets.all(8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(
              thumbnailImage,
              width: 100,
              height: 50,
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    },
  ),
),



         
             
            ],
            
          ),
        ),),
        
         Footer(
             
            ),
              ])
      ),
    );
  }

  Future<void> callImageApi(String hairStyleIdentifier) async {
      if(_userImageId.isNotEmpty){
          
          print("inside allImageApi");
            final responseJson = await MirrarSDK.getImageFilter(hairStyleIdentifier, _userImageId);
              Map<String, dynamic> responseData = jsonDecode(responseJson);
              String imageUrl = "https://api.hair.mirrar.io" + responseData['result'];

                setState(() {
                  resultImageUrl=imageUrl;
                _isUploading = false;
                 _selectedImage=null;
              });

                print("response: $responseJson");
          }
}
}
