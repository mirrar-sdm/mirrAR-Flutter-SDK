# Mirrar SDK

Virtual jewellery try-on Flutter package project.

## How to import mirrAR flutter SDK

1. Add these lines in your pubspec.yaml under dependencies

```
  mirrar_sdk:
    git: git://github.com/shivammaindola/flutter_sdk.git
  permission_handler: ^5.1.0+2
```

2. Add these 2 lines inside main
   ```
   WidgetsFlutterBinding.ensureInitialized();
   await Permission.camera.request();
   ```
3. Minimum sdk shoud be greater than 19 in android

4. Use MirrarSDK widget with three constructor to navigate 

```String jsonData="{\"options\": {\"productData\": {\"Necklaces\": {\"items\": [\"513319NDJAA40\"],\"type\": \"neck\"}}}}";```

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

    
