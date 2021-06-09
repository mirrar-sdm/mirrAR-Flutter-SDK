library mirrar_sdk;

import 'dart:async';
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
import 'package:mirrar_sdk/SafariBrowser.dart';
import 'package:path_provider/path_provider.dart';
import 'package:webview_flutter/webview_flutter.dart' as webview;

import 'CodeMap.dart';

InAppWebViewController _webViewController;
String uuid;
String baseUrl;
bool load = false;

class MirrarSDK extends StatefulWidget {
  final String uuid;
  final String jsonData;
  final Function(String, String) onMessageCallback;

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
  final Function(String, String) onMessageCallback;
  final GlobalKey webViewKey = GlobalKey();
  final Completer<InAppWebViewController> _completeController =
  Completer<InAppWebViewController>();
  final ChromeSafariBrowser browser = new MyChromeSafariBrowser();

  _MyHomePageState({this.jsonData, this.uuid, this.onMessageCallback});

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      webview.WebView.platform = webview.SurfaceAndroidWebView();
    }
    // browser.addMenuItem(new ChromeSafariBrowserMenuItem(
    //     id: 1,
    //     label: 'Custom item menu 1',
    //     action: (url, title) {
    //       print('Custom item menu 1 clicked!');
    //     }));
    checkAPI();
  }

Future<bool> _exitApp(BuildContext context) async {
  if (await _webViewController.canGoBack()) {
    print("onwill goback");
    _webViewController.goBack();
  } else {
    Navigator.pop(context);
    return Future.value(false);
  }
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
      baseUrl = "https://cdn.styledotme.com/mirrar-test/mirrar.html?brand_id=" +
          uuid +
          csv +
          "&sku=" +
          codes.elementAt((codes.length > 0) && codes.contains('#') ? 1 : 0) +
          "&platform=android-sdk-flutter";
      print(baseUrl);
      load = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (load)
      return WillPopScope(
      onWillPop: () => _exitApp(context),
      child: Scaffold(
        backgroundColor: Colors.black,
         bottomNavigationBar: Container(
          height: 50,
          color: Colors.white,
          child: InkWell(
            onTap: () => _exitApp(context),
            child: Padding(
              padding: EdgeInsets.fromLTRB(10, 4, 0, 0),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.arrow_back_ios_new,
                    color: Theme.of(context).accentColor,
                  ),
                  Text('Dismiss'),
                ],
              ),
            ),
          ),),
        body: Center(
          child: ElevatedButton(
            child: Text("Open Browser"),
            onPressed: () async {
              await browser.open(
                  url: Uri.parse(baseUrl),
                  options: ChromeSafariBrowserClassOptions(
                      android: AndroidChromeCustomTabsOptions(
                        enableUrlBarHiding: false,
                        showTitle: false,
                          addDefaultShareMenuItem: false),
                      ios: IOSSafariOptions(barCollapsingEnabled: true)));
            },
          ),),
      ));
    else {
      return Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.pink,
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
