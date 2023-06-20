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
import 'package:image_gallery_saver/image_gallery_saver.dart';import 'package:path_provider/path_provider.dart';
import 'package:plugin_mirrar/plugin_mirrar.dart';
import 'package:webview_flutter/webview_flutter.dart' as webview;

import 'code_map.dart';

  InAppWebViewController? _webViewController;
String? uuid;
String? baseUrl= "https://beauty.mirrar.com/";
bool load = true;
String mode="webview";
class Makeup extends StatefulWidget {
  final String uuid;
  final String jsonData;
  final Function(String, String) onMessageCallback;

  Makeup({Key? key, required this.jsonData,required  this.uuid,required  this.onMessageCallback})
      : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  _MyHomePageState createState() => _MyHomePageState(
      jsonData: jsonData,
      uuid: uuid,
      onMessageCallback: onMessageCallback);
}

class _MyHomePageState extends State<Makeup> {

  final String? jsonData;
  final String? uuid;
   static const platform = MethodChannel('com.sdk.mirrarflutter/navToTryOn');
  
  final Function(String, String) onMessageCallback;
  final GlobalKey webViewKey = GlobalKey();
  final Completer<InAppWebViewController> _completeController =
  Completer<InAppWebViewController>();
  _MyHomePageState({required this.jsonData,required  this.uuid,required  this.onMessageCallback});

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      webview.WebView.platform = webview.SurfaceAndroidWebView();
    }
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
    if (load){
      return Scaffold(
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
                    Icons.arrow_back_ios,
                    color: Theme.of(context).accentColor,
                  ),
                  Text('Dismiss'),
                ],
              ),
            ),
          ),),
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
            if(url.contains('whatsapp')){
            int t = url.indexOf('text');
            int end = url.indexOf('source');
            String sendUrl = url.substring(t + 5, end - 1);
            Share.text('MirrAR', '$sendUrl', 'text/plain');
            onMessageCallback("whatsapp", sendUrl);
             return NavigationActionPolicy.CANCEL;
            }
            else
             return NavigationActionPolicy.ALLOW;
           
          },
          onWebViewCreated: (InAppWebViewController controller) {
            _webViewController = controller;

            _webViewController!.addJavaScriptHandler(
                handlerName: 'message',
                callback: (args) {
                  String str = args.toString();
                  print("message: asasasaas $str");
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
                  int check = 0;
                  for (int i = j + 2; i < str.length; i++) {
                    if (str[i] != ",") {
                      secondArg += str[i];
                    } else {
                      k = i;
                      break;
                    }
                  }

                  
                 
                // print("eventName: $event");
                  if (event == "mirrar-popup-closed") {
                    onMessageCallback("mirrar-popup-closed", secondArg);
                  }
                  else if (event == "details") {
                    onMessageCallback("details", secondArg);
                  } else if (event == "wishlist") {
                    onMessageCallback("wishlist", secondArg);
                  } else if (event == "unwishlist") {
                    onMessageCallback("unwishlist", secondArg);
                  } else if (event == "cart") {
                    onMessageCallback("cart", secondArg);
                  } else if (event == "remove_cart") {
                    onMessageCallback("remove_cart", secondArg);
                  } else if (event == "share") {
                    print("checkitonce");
                    List<String> listStr =  List<String>.filled(0,'', growable:true);
                  listStr = str.split(',');
                  // for(int i=0;i<listStr.length;i++){
                  //   print("checkitonce: ${listStr.elementAt(i)}");
                  // }
                  String substring = listStr.elementAt(2);
                    Uint8List _bytes = base64.decode(substring);
                    Share.file('MirrAR SDK', 'mirrar.jpg', _bytes, 'image/jpg');
                    onMessageCallback("share", substring);
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
            onMessageCallback("download", url.toString());

            _createFileFromString(url.toString());
          },
        ),
      );
    }
    else {
      return Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: Container(
          height: 50,
          color: Colors.white,
          child: InkWell(
            onTap: () => _exitAppSafari(context),
            child: Padding(
              padding: EdgeInsets.fromLTRB(10, 4, 0, 0),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.arrow_back_ios,
                    color: Theme.of(context).accentColor,
                  ),
                  Text('Dismiss'),
                ],
              ),
            ),
          ),),
       
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