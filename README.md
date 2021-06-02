# Mirrar SDK

Virtual jewellery try-on Flutter package project.

## How to import mirrAR flutter SDK

1. Add these lines in your pubspec.yaml under dependencies

```
  mirrar_sdk:
    git: git://github.com/styledotme/mirrAR-Android-SDK.git
  permission_handler: ^5.1.0+2
```

2. Add these 2 lines inside main
   ```
   WidgetsFlutterBinding.ensureInitialized();
   await Permission.storage.request();
   await Permission.camera.request();
   ```
3. Minimum sdk shoud be greater than 19 in android
  ```
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.CAMERA" />
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
  ```
4. Add these permissions inside Manifest.xml
 
4. Use MirrarSDK widget with three constructor to navigate 

```String jsonData="{\"options\": {\"productData\": {\"Necklaces\": {\"items\": [\"\"],\"type\": \"neck\"}}}}";```

```
MirrarSDK(
      jsonData: jsonData,
      uuid: '',
      onMessageCallback: (String event,String message) {
        if (event == "details") {
          //message is the product_code
        } else if (event == "whatsapp") {
          //message is the image uri
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
        }
      },
    )
```

    
