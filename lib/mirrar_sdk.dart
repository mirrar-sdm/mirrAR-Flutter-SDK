library mirrar_sdk;

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'CodeMap.dart';

InAppWebViewController _webViewController;
String uuid;
String baseUrl;
bool load = false;

class MirrarSDK extends StatefulWidget {
  final String username;
  final String password;
  final String jsonObject;

  MirrarSDK({Key key, this.username, this.password, this.jsonObject})
      : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState(
      username: this.username,
      password: this.password,
      jsonObject: this.jsonObject);
}

class _MyHomePageState extends State<MirrarSDK> {
  final String username;
  final String password;
  final String jsonObject;

  _MyHomePageState({this.username, this.password, this.jsonObject});

  @override
  void initState() {
    super.initState();

    checkAPI();
  }

  Future<void> checkAPI() async {
    Map<String, CodeMap> activeMap = new Map();
    Map<String, CodeMap> showMap = new Map();
    Map<String, List<String>> mCodes = new Map();
    final formData = {
      'username': username,
      'password': password,
      'type': 'android_sdk',
    };

    Dio _dio = new Dio();
    _dio.options.contentType = Headers.formUrlEncodedContentType;

    final responseData = await _dio.post<Map<String, dynamic>>('/api/v1/login',
        options: RequestOptions(
            method: 'POST',
            headers: <String, dynamic>{},
            baseUrl: 'https://m.mirrar.com/'),
        data: formData);

    Map<String, dynamic> map = responseData.data;
    uuid = map['data']['uuid'];
    var rest = map["data"]["active_product_codes"] as Map<String, dynamic>;

    for (String key in rest.keys) {
      activeMap.putIfAbsent(key, () => CodeMap.fromJson(rest[key]));
    }
    //print(activeMap);

    //do with existing json
    String jsonData = jsonObject;
    Map valueMap = json.decode(jsonData);
    // print(valueMap);
    //print(valueMap['options']['productData']);

    var showProductMap =
        valueMap['options']['productData'] as Map<String, dynamic>;

    for (String key in showProductMap.keys) {
      showMap.putIfAbsent(key, () => CodeMap.fromJson(showProductMap[key]));
    }

    showMap.forEach((key, value) {
      if (activeMap.containsKey(key)) {
        List<String> codes = new List();
        value.items.forEach((element) {
          if (activeMap[key].items.contains(element)) {
            codes.add(element);
          }
        });

        if (codes.length > 0) {
          mCodes.putIfAbsent(key, () => codes);
        }
      }
    });

//print(activeMap['Necklaces'].items );
    //print(mCodes.length);

    List<String> codes = new List();
    mCodes.forEach((key, value) {
      codes.add("&$key=");
      codes.addAll(value);
    });

    print(codes.toString());
    String csv = codes
        .toString()
        .replaceAll("[", "")
        .replaceAll("]", "")
        .replaceAll(", ", ",");

    setState(() {
      baseUrl = "https://cdn.styledotme.com/general/mirrar.html?brand_id=" +
          uuid +
          csv +
          "&sku=" +
          codes.elementAt(1).replaceAll("=,", "=").replaceAll(",&", "&");
      print(baseUrl);
      load = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (load)
      return Scaffold(
        backgroundColor: Colors.black,
        body: InAppWebView(
            initialUrl: baseUrl,
            initialOptions: InAppWebViewGroupOptions(
              crossPlatform: InAppWebViewOptions(
                mediaPlaybackRequiresUserGesture: false,
                debuggingEnabled: true,
              ),
            ),
            onWebViewCreated: (InAppWebViewController controller) {
              _webViewController = controller;
            },
            androidOnPermissionRequest: (InAppWebViewController controller,
                String origin, List<String> resources) async {
              return PermissionRequestResponse(
                  resources: resources,
                  action: PermissionRequestResponseAction.GRANT);
            }),
      );
    else {
      return Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.white,
            ),
          ));
    }
  }
}
