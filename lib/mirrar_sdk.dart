import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:device_info/device_info.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:modern_form_esys_flutter_share/modern_form_esys_flutter_share.dart';
import 'package:path_provider/path_provider.dart';
import 'package:plugin_mirrar/plugin_mirrar.dart';
import 'package:webview_flutter/webview_flutter.dart' as webview;

import 'code_map.dart';

InAppWebViewController? _webViewController;
String? uuid;
String? baseUrl;
bool load = false;
String mode = "webview";

class MirrarSDK extends StatefulWidget {
  final String uuid;
  final String jsonData;
  final Function(String, String, String) onMessageCallback;

  const MirrarSDK(
      {Key? key,
      required this.jsonData,
      required this.uuid,
      required this.onMessageCallback})
      : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  _MyHomePageState createState() => _MyHomePageState(
      jsonData: jsonData, uuid: uuid, onMessageCallback: onMessageCallback);
}

class _MyHomePageState extends State<MirrarSDK> {
  final String? jsonData;
  final String? uuid;

  final Function(String, String, String) onMessageCallback;
  final GlobalKey webViewKey = GlobalKey();
  _MyHomePageState(
      {required this.jsonData,
      required this.uuid,
      required this.onMessageCallback});

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      webview.WebView.platform = webview.SurfaceAndroidWebView();
    }
    checkAPI();
  }

  Future<void> checkAPI() async {
    Map<String, CodeMap> showMap = {};
    Map<String, List<String>> mCodes = {};

    Map valueMap = json.decode(jsonData!);
    // print(valueMap);
    //print(valueMap['options']['productData']);

    var showProductMap =
        valueMap['options']['productData'] as Map<String, dynamic>;

    for (String key in showProductMap.keys) {
      showMap.putIfAbsent(key, () => CodeMap.fromJson(showProductMap[key]));
    }

    showMap.forEach((key, value) {
      // ignore: deprecated_member_use
      // ignore: prefer_collection_literals
      List<String> codes = List<String>.filled(0, '', growable: true);
      for (var element in value.items!) {
        codes.add(element);
      }

      if (codes.isNotEmpty) {
        mCodes.putIfAbsent(key, () => codes);
      }
    });

//print(activeMap['Necklaces'].items );
    //print(mCodes.length);

    List<String> codes = List<String>.filled(0, '', growable: true);
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
      baseUrl =
          "https://cdn.mirrar.com/general/mirrar.html?brand_id=${uuid!}$csv&sku=${codes[1] ?? ""}&platform=android-sdk-flutter";
      print(baseUrl);
      load = true;
    });

    if (Platform.isIOS) {
      var iosInfo = await DeviceInfoPlugin().iosInfo;

      var version = iosInfo.systemVersion;
      if (int.parse(version) < 14.3) {
        mode = "safari";
        openSafari(showProductMap);
      } else {
        setState(() {
          load = true;
        });
      }
    } else {
      setState(() {
        load = true;
      });
    }
  }

  openSafari(var productData) async {
    var options = {"brandId": uuid, "productData": productData};
    PluginMirrar.launchTyrOn(options);
  }

  Future<bool> _exitApp(BuildContext context) async {
    if (await _webViewController!.canGoBack()) {
      print("onwill goback");
      _webViewController!.goBack();
      return Future.value(false);
    } else {
      Navigator.pop(context);
      return Future.value(false);
    }
  }

  Future<bool> _exitAppSafari(BuildContext context) async {
    Navigator.pop(context);
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    if (load) {
      return Scaffold(
        backgroundColor: Colors.black,
        bottomNavigationBar: Container(
          height: 50,
          color: Colors.white,
          child: InkWell(
            onTap: () => _exitApp(context),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 4, 0, 0),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.arrow_back_ios_new,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  const Text('Dismiss'),
                ],
              ),
            ),
          ),
        ),
        body: InAppWebView(
          key: webViewKey,
          initialUrlRequest: URLRequest(url: Uri.parse(baseUrl!)),
          initialOptions: InAppWebViewGroupOptions(
            crossPlatform: InAppWebViewOptions(
                mediaPlaybackRequiresUserGesture: false,
                useOnDownloadStart: true,
                useShouldOverrideUrlLoading: true),
          ),
          shouldOverrideUrlLoading: (controller, navigationAction) async {
            var uri = navigationAction.request.url;
            String url = uri.toString();
            if (url.contains('whatsapp')) {
              int t = url.indexOf('text');
              int end = url.indexOf('source');
              String sendUrl = url.substring(t + 5, end - 1);
              Share.text('MirrAR', sendUrl, 'text/plain');
              onMessageCallback("whatsapp", sendUrl, "");
              return NavigationActionPolicy.CANCEL;
            } else {
              return NavigationActionPolicy.ALLOW;
            }
          },
          onWebViewCreated: (InAppWebViewController controller) {
            _webViewController = controller;

            _webViewController!.addJavaScriptHandler(
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
                  String secondArg = '';
                  for (int i = j + 2; i < str.length; i++) {
                    if (str[i] != ",") {
                      secondArg += str[i];
                    } else {
                      break;
                    }
                  }

                  String thirdArg = '';
                  for (int i = j + 2; i < str.length; i++) {
                    if (str[i] != ",") {
                      thirdArg += str[i];
                    } else {
                      break;
                    }
                  }
                  // print("eventName: $event");
                  if (event == "mirrar-popup-closed") {
                    onMessageCallback(
                        "mirrar-popup-closed", secondArg, thirdArg);
                  } else if (event == "details") {
                    onMessageCallback("details", secondArg, thirdArg);
                  } else if (event == "wishlist") {
                    onMessageCallback("wishlist", secondArg, thirdArg);
                  } else if (event == "unwishlist") {
                    onMessageCallback("unwishlist", secondArg, thirdArg);
                  } else if (event == "cart") {
                    onMessageCallback("cart", secondArg, thirdArg);
                  } else if (event == "remove_cart") {
                    onMessageCallback("remove_cart", secondArg, thirdArg);
                  } else if (event == "share") {
                    print("checkitonce");
                    List<String> listStr =
                        List<String>.filled(0, '', growable: true);
                    listStr = str.split(',');
                    // for(int i=0;i<listStr.length;i++){
                    //   print("checkitonce: ${listStr.elementAt(i)}");
                    // }
                    String substring = listStr.elementAt(2);
                    Uint8List bytes = base64.decode(substring);
                    Share.file('MirrAR SDK', 'mirrar.jpg', bytes, 'image/jpg');
                    onMessageCallback("share", substring, "");
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
          onDownloadStartRequest: (controller, url) async {
            print("onDownloadStart $url");
            onMessageCallback("download", url.toString(), "");

            _createFileFromString(url.toString());
          },
        ),
      );
    } else {
      return Scaffold(
          backgroundColor: Colors.white,
          bottomNavigationBar: Container(
            height: 50,
            color: Colors.white,
            child: InkWell(
              onTap: () => _exitAppSafari(context),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 4, 0, 0),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.arrow_back_ios_new,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    const Text('Dismiss'),
                  ],
                ),
              ),
            ),
          ),
          body: const Center(
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
