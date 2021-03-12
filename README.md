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
3. Use MirrarSDK widget with three constructor to navigate 

```String jsonData="{\"options\": {\"productData\": {\"Necklaces\": {\"items\": [\"513319NDJAA40\"],\"type\": \"neck\"}}}}";```

```
MirrarSDK(
      username: '',
      password: '',
      jsonObject: jsonData,
    )
```

    
