# Mirrar SDK

Virtual jewellery try-on Flutter package project.

## How to import mirrAR flutter SDK

1. Add this line in your pubspec.yaml under dependencies

```
mirrar_sdk:
    git:
      url: https://github.com/shivammaindola/flutter_sdk.git
      ref: master
```

2. Use MirrarSDK widget to navigate with three constructor

```String jsonData="{\"options\": {\"productData\": {\"Necklaces\": {\"items\": [\"513319NDJAA40\"],\"type\": \"neck\"}}}}";```

```
MirrarSDK(
      username: '',
      password: '',
      jsonObject: jsonData,
    )
```

    
