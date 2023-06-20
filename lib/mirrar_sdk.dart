import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:device_info/device_info.dart';
import 'package:dio/dio.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:plugin_mirrar/plugin_mirrar.dart';
import 'package:webview_flutter/webview_flutter.dart' as webview;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'code_map.dart';

  InAppWebViewController? _webViewController;
String? uuid;
String? baseUrl;
bool load = false;
String mode="webview";
class MirrarSDK  {
  
  static Future<String> myApiFunction(String _base64String) async {
    // Make the API call with the provided argument and return the result
    return await callSkinAPI(_base64String);
  }

  static Future<String> getSubBrandId(String brandId) async {
    // Make the API call with the provided argument and return the result
    return await fetchSubBrandId(brandId);
  }

  static Future<String> fetchHairStyle() async {
    // Make the API call with the provided argument and return the result
    return await getHairStyles();
  }

   static Future<String> uploadImageToServer() async {
    // Make the API call with the provided argument and return the result
    return await uploadImage();
  }

   static Future<String> getImageFilter(String imagePath, String imageId) async {
    // Make the API call with the provided argument and return the result
    return await getImageTryOnResponse(imagePath,imageId);
  }

}

 Future<String> callSkinAPI(String _base64String) async {
    if (_base64String == null) return throw Exception('API call failed with status: Null string}');

    final url = Uri.parse('https://api.lakme.mirrar.com/webhook/skin/analysis');
    final headers = {'Content-Type': 'application/json'};

    final currentDate = DateTime.now();
    final fileNameString = 'image_${currentDate.year}${currentDate.month}${currentDate.day}${currentDate.hour}${currentDate.minute}${currentDate.second}.png';

    final body = json.encode({
      'image': _base64String,
      'name': fileNameString,
    });

    final response = await http.post(url, headers: headers, body: body);
      print('Request failed with status: ${response.body}');

    if (response.statusCode == 200) {
      // Request successful
      final jsonResponse = json.decode(response.body);
      return response.body;
  
    } else {
      // Request failed
          throw Exception('API call failed with status: ${response.statusCode}');

    }
  }

  Future<String> fetchSubBrandId(String brandId) async {
     String url = 'https://api.lakme.mirrar.com/brand/beauty/id-login';
  Map<String, String> requestBody = {
    'brand_id': brandId,
  };
  try {
    var response = await http.post(Uri.parse(url), body: jsonEncode(requestBody));

    if (response.statusCode == 200) {
      var responseData = response.body;
      // Process the responseData here
      return responseData;
    } else {
      print('Request failed with status: ${response.statusCode}');
       throw Exception('API call failed with status: ${response.statusCode}');
    }
  } catch (error) {
     throw Exception('API call failed with status: $error');
  }
}


Future<String> getHairStyles() async {
  var url = Uri.parse('https://api.lakme.mirrar.com/hairstylecolor/hairType/all/brand/ec3e6733-cdd4-474f-b01d-c073655fa105/subBrandId/a9562e09-7a61-472f-a1f7-e719c897e97c');
  
  try {
    var response = await http.get(url);

    if (response.statusCode == 200) {
      // API call successful, you can handle the response here
      print(response.body);
      return response.body;
    } else {
      // API call failed, handle the error
      print('API request failed with status code: ${response.statusCode}');
      throw Exception('API call failed with status: ${response.statusCode}');
    }
  } catch (error) {
    // Exception occurred during API call
    print('API request failed with error: $error');
    throw Exception('API call failed with status: $error');
  }
}

Future<String> uploadImage() async {
  var url = Uri.parse('https://api.lakme.mirrar.com/hairstylecolor/hairType/all/brand/ec3e6733-cdd4-474f-b01d-c073655fa105/subBrandId/a9562e09-7a61-472f-a1f7-e719c897e97c');
  
  try {
    var response = await http.get(url);

    if (response.statusCode == 200) {
      // API call successful, you can handle the response here
      print(response.body);
      return response.body;
    } else {
      // API call failed, handle the error
      print('API request failed with status code: ${response.statusCode}');
      throw Exception('API call failed with status: ${response.statusCode}');
    }
  } catch (error) {
    // Exception occurred during API call
    print('API request failed with error: $error');
    throw Exception('API call failed with status: $error');
  }
}

Future<String> getImageTryOnResponse(String imagePath, String imageId) async {
  var url = Uri.parse('https://api.hair.mirrar.io/tryon/');
  
  var request = http.MultipartRequest('POST', url);
  request.fields['hairstyle_image_path'] = imagePath;
  request.fields['user_image_id'] = imageId;
  
  var response = await request.send();
  
  if (response.statusCode == 200) {
    String responseString = await response.stream.transform(utf8.decoder).join();
    print("checkMessage $responseString");
    return responseString;
  } else {
    print('Request failed with status: ${response.statusCode}');
        throw Exception('API call failed with status: ${response.statusCode}');

  }
}


