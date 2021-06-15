import Flutter
import UIKit

public class SwiftPluginCodelabPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
   
        let flutterViewController: FlutterViewController = window?.rootViewController as! FlutterViewController
        //
        let tstChannel = FlutterMethodChannel(name: "com.sdk.mirrarflutter/navToTryOn",
                                              binaryMessenger: flutterViewController.binaryMessenger)
        tstChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result: FlutterResult) -> Void in
            guard call.method == "goToTryOn" else {
                result(FlutterMethodNotImplemented)
                return
            }
            if let args = call.arguments as? Dictionary<String, Any> {
                let options = getModelFrom(args)
                self.mainCoordinator?.start(with: options)
            } else {
                result(FlutterMethodNotImplemented)
                return
            }
            
        })
        //
        GeneratedPluginRegistrant.register(with: self)
        //
        let navigationController = UINavigationController(rootViewController: flutterViewController)
        navigationController.isNavigationBarHidden = true
        window?.rootViewController = navigationController
        mainCoordinator = AppCoordinator(navigationController: navigationController)
        window?.makeKeyAndVisible()
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    
  }
}
func getModelFrom(_ dic: Dictionary<String, Any>) -> Options {
    var arrayProducts = [ProductData]()
    let products = (dic["options"] as! [String: Any])["productData"] as! [String: Any]
    for (key, value) in products {
        let v = value as! [String: Any]
        let product = ProductData(category: key, items: v["items"] as! [String], type: v["type"] as! String)
        arrayProducts.append(product)
    }
    let brandId = (dic["options"] as! [String: Any])["brandId"] as? String ?? ""
    return Options(brandId: brandId, productData: arrayProducts)
}
