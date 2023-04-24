# plugin_mirrar

A new flutter plugin project.

## Getting Started

This project is a starting point for a Flutter
[plug-in package](https://flutter.dev/developing-packages/),
a specialized package that includes platform-specific implementation code for
Android and/or iOS.

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


## How to pass data to the SDK?

The SDK requires a json data to be passed the sdk in the following format

```
{
    "options": {
        "productData": {
            "Category1": {
                "items": ["sku1", "sku2", "sku3"],
                "type": "ear"
            },
            "Category2": {
                "items": ["sku4", "sku5"],
                "type": "set"
            }
        }
    }
}
```

ProductData contains a key-value pair with Category Name as key and an object as value with items as an array if SKUs/ProductCodes. 

For eg -
```
{
    "options": {
        "productData": {
            "Earrings": {
                "items": ["Earring_1", "Earring_2", "Earring_3"],
                "type": "ear"
            },
            "Sets": {
                "items": ["SET001", "SET002"],
                "type": "set"
            }
        }
    }
}
```


