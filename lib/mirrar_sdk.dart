library mirrar_sdk;

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';

import 'CodeMap.dart';

InAppWebViewController _webViewController;
String uuid;
String baseUrl;
bool load = false;

class MirrarSDK extends StatefulWidget {
  final String uuid;
  final String jsonData;
  final Function(String,String) onMessageCallback;

  MirrarSDK({Key key, this.jsonData, this.uuid, this.onMessageCallback})
      : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState(
      jsonData: this.jsonData,
      uuid: this.uuid,
      onMessageCallback: this.onMessageCallback);
}

class _MyHomePageState extends State<MirrarSDK> {
  final String jsonData;
  final String uuid;
  final Function(String,String) onMessageCallback;

  _MyHomePageState({this.jsonData, this.uuid, this.onMessageCallback});

  @override
  void initState() {
    super.initState();

    checkAPI();
  }

  Future<void> checkAPI() async {
    Map<String, CodeMap> activeMap = new Map();
    Map<String, CodeMap> showMap = new Map();
    Map<String, List<String>> mCodes = new Map();

    Map valueMap = json.decode(jsonData);
    // print(valueMap);
    //print(valueMap['options']['productData']);

    var showProductMap =
        valueMap['options']['productData'] as Map<String, dynamic>;

    for (String key in showProductMap.keys) {
      showMap.putIfAbsent(key, () => CodeMap.fromJson(showProductMap[key]));
    }

    showMap.forEach((key, value) {
      List<String> codes = new List();
      value.items.forEach((element) {
        codes.add(element);
      });

      if (codes.length > 0) {
        mCodes.putIfAbsent(key, () => codes);
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
        .replaceAll(", ", ",")
        .replaceAll("=,", "=")
        .replaceAll(",&", "&");

    setState(() {
      baseUrl = "https://cdn.styledotme.com/webpack/mirrar.html?brand_id=" +
          uuid +
          csv +
          "&sku=" +
          codes.elementAt((codes.length > 0)&&codes.contains('#') ? 1 : 0) +
          "&platform=android-sdk-flutter";
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
                useOnDownloadStart: true,
                useShouldOverrideUrlLoading: true),
          ),         
          shouldOverrideUrlLoading:
              (controller, shouldOverrideUrlLoadingRequest) async {
            var url = shouldOverrideUrlLoadingRequest.url;
            var uri = Uri.parse(url);
            int t=url.indexOf('text');
            int end=url.indexOf('source');
            String sendUrl=url.substring(t+5,end-1);
         Share.text('MirrAR', '$sendUrl', 'text/plain');
          },
          onWebViewCreated: (InAppWebViewController controller) {
            _webViewController = controller;

            _webViewController.addJavaScriptHandler(
                handlerName: 'message',
                callback: (args) {
                  String str = args.toString();
                  String event = '';
                  int j = 0;
                  for (int i = 9; i < str.length; i++) {
                    if (str[i] != ',') {
                      event += str[i];
                    } else {
                      j = i;
                      break;
                    }
                  }
                  int k = 0;
                  String secondArg = '';
                  int check=0;
                  for (int i = j + 2; i < str.length; i++) {
                    
                      if (str[i] != ",") {
                      secondArg += str[i];
                    
                    } else {
                      k = i;
                      break;
                    }
                  
                    }
                    
                    
                  print("event: $event and $secondArg and $k");

                  if (event == "details") {
                    onMessageCallback("details",secondArg);
                  } else if (event == "whatsapp") {
                    onMessageCallback("whatsapp",secondArg);
                  } else if (event == "download") {
                    onMessageCallback("download",secondArg);
                  } else if (event == "wishlist") {
                    onMessageCallback("wishlist",secondArg);
                  } else if (event == "unwishlist") {
                    onMessageCallback("unwishlist",secondArg);
                  } else if (event == "cart") {
                    onMessageCallback("cart",secondArg);
                  } else if (event == "remove_cart") {
                    onMessageCallback("remove_cart",secondArg);
                  }
                  else if (event == "share") {
                    onMessageCallback("share",secondArg);
                  }
                });
          },
          onConsoleMessage: (controller, consoleMessage) {
            print("checktest $consoleMessage");
          },
          androidOnPermissionRequest: (InAppWebViewController controller,
              String origin, List<String> resources) async {
            return PermissionRequestResponse(
                resources: resources,
                action: PermissionRequestResponseAction.GRANT);
          },
          onDownloadStart: (controller, url) async {
            print("onDownloadStart $url");
            _createFileFromString(url);
           
          },
        ),
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

Future<String> _createFileFromString(String url) async {
  int i = 0;
  for (i = 0; i < url.length; i++) {
    if (url[i] == ',') break;
  }
  String smallUrl = url.substring(i + 1, url.length);
  Uint8List bytes = base64.decode(smallUrl);
  String dir = (await getApplicationDocumentsDirectory()).path;
  String fullPath = '$dir/abc.png';
  print("local file full path $smallUrl");
  File file = File(fullPath);
  await file.writeAsBytes(bytes);
  print(file.path);

  final result = await ImageGallerySaver.saveImage(bytes);
  print(result);

  return file.path;
}
