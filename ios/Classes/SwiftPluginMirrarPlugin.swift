import Flutter
import UIKit
import Foundation

fileprivate var channel: FlutterMethodChannel!
fileprivate var flutterVC: UIViewController?

public class SwiftPluginMirrarPlugin: NSObject, FlutterPlugin {
    
  private var mainCoordinator: AppCoordinator?
  public static func register(with registrar: FlutterPluginRegistrar) {
    channel = FlutterMethodChannel(name: "plugin_mirrar", binaryMessenger: registrar.messenger())
    let instance = SwiftPluginMirrarPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        flutterVC = (UIApplication.shared.windows.filter {$0.isKeyWindow}.first!.rootViewController)
        guard call.method == "launchTyrOn" else {
            result(FlutterMethodNotImplemented)
            return
        }
        if let args = call.arguments as? Dictionary<String, Any> {
            let options = getModelFrom(args)
            let vc = TryOnViewController(screenTitle: "Virtual Try-On", //Optional
                                         screenTitleColor: .black,    //Optional
                                         navigationBarColor: .white,  //Optional
                                         dismissTitle: "Dismiss",    //Optional
                                         dismissTitleColor: .black,    //Optional
                                         dismissBackgroundColor: .white, // Optional
                                         options: options //Required
            )
            let nav = UINavigationController(rootViewController: vc)
            UIApplication.shared.windows.filter {$0.isKeyWindow}.first!.rootViewController = nav
        } else {
            result(FlutterMethodNotImplemented)
            return
        }
  }

  func getModelFrom(_ dic: Dictionary<String, Any>) -> Options {
      var arrayProducts = [ProductData]()
       let products = dic["productData"] as! [String: Any]

//       let products = (dic["options"] as! [String: Any])["productData"] as! [String: Any]
      for (key, value) in products {
          let v = value as! [String: Any]
          let product = ProductData(category: key, items: v["items"] as! [String], type: v["type"] as! String)
          arrayProducts.append(product)
      }
      let brandId = dic["brandId"] as? String ?? ""
      return Options(brandId: brandId, productData: arrayProducts)
  }
}


import SafariServices

fileprivate let SCREEN_HEIGHT = UIScreen.main.bounds.height
fileprivate let SCREEN_WIDTH  = UIScreen.main.bounds.width

fileprivate let BASE_URL = "https://cdn.styledotme.com/general/mirrar.html"

public final class TryOnViewController: UIViewController {
//    var coordinatorDelegate: TryOnCoordinatorDelegate?
    var navController: UINavigationController!

    var safari: SFSafariViewController!
    var labelTitle: UILabel!
    var buttonDismissView: UIView!
    var buttonDismiss: UIButton!

    var yOffSet: CGFloat = 44.0
    
    var screenTitle = "Virtual Try-on"
    var screenTitleColor = UIColor.black
    var navigationBarColor = UIColor.white

    var dismissButtonTitle = " ᐸ Dismiss"
    var dismissButtonTitleColor = UIColor.black
    var dismissBackgroundColor = UIColor.black

    var options: Options!
    
    public convenience init(screenTitle: String = "Virtual Try-on",
                            screenTitleColor: UIColor = UIColor.black,
                            navigationBarColor: UIColor = UIColor.white,
                            dismissTitle: String = "  ᐸ Dismiss",
                            dismissTitleColor: UIColor = UIColor.black,
                            dismissBackgroundColor: UIColor = UIColor.white,
                            options: Options) {
        
        self.init(nibName:nil, bundle:nil)
        self.screenTitle = screenTitle
        self.screenTitleColor = screenTitleColor
        self.navigationBarColor = navigationBarColor
        self.dismissButtonTitle = "  ᐸ \(dismissTitle)"
        self.dismissButtonTitleColor = dismissTitleColor
        self.dismissBackgroundColor = dismissBackgroundColor
        self.options = options
    }
    
    private override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    internal required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let urlStr = "\(BASE_URL)?brand_id=\(options.brandId)\(getUrlStrFromData())&sku=\(getSKU())&platform=ios-sdk";
        print(urlStr)
        let url = URL(string: urlStr)
        safari = SFSafariViewController(url: url!)
        DispatchQueue.main.async {
            self.present(self.safari, animated: false) {
                self.addSubViewsToSafari()
            }
        }
    }

    func addSubViewsToSafari() {
        safari.view.frame = CGRect(x:safari.view.frame.origin.x, y:safari.view.frame.origin.y, width: safari.view.frame.size.width, height: safari.view.frame.size.height);
        addTitle()
        addDismissButton()
    }
    
    func addTitle() {
        labelTitle = UILabel(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: safeAreaTop))
        labelTitle.numberOfLines = 2
        labelTitle.text = safeAreaTop > yOffSet ? "\n\(screenTitle)" : screenTitle
        labelTitle.backgroundColor = navigationBarColor
        labelTitle.textColor = screenTitleColor
        labelTitle.textAlignment = .center
        labelTitle.font = UIFont(name: "Avenir-Heavy", size: 20.0)
        safari.view.window?.addSubview(labelTitle)
    }
    
    func addDismissButton() {
        if UIDevice.current.userInterfaceIdiom == .pad {
            addDismissButtonForIPad()
        } else {
            addDismissButtonForIPhone()
        }
    }
    
    func addDismissButtonForIPhone() {
        buttonDismissView = UIView(frame: CGRect(x: 0, y: SCREEN_HEIGHT-safeAreaBottom, width: SCREEN_WIDTH, height: safeAreaTop))
        buttonDismissView.backgroundColor = dismissBackgroundColor
        
        buttonDismiss = UIButton(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 44))
        buttonDismiss.backgroundColor = .white
        buttonDismiss.setTitleColor(dismissButtonTitleColor, for: .normal)
        buttonDismiss.setTitle(dismissButtonTitle, for: .normal)
        buttonDismiss.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 16.0)
        buttonDismiss.contentHorizontalAlignment = .left
        buttonDismiss.addTarget(self, action: #selector(dismissButtonAction), for: .touchUpInside)
        buttonDismissView.addSubview(buttonDismiss)
        safari.view.window?.addSubview(buttonDismissView)
    }
    
    func addDismissButtonForIPad() {
        buttonDismiss = UIButton(frame: CGRect(x: 0, y: 0, width: 150, height: safeAreaTop))
        buttonDismiss.backgroundColor = .clear
        buttonDismiss.setTitleColor(screenTitleColor, for: .normal)
        buttonDismiss.titleLabel?.numberOfLines = 2
        buttonDismiss.setTitle("\n    \(dismissButtonTitle)", for: .normal)
        buttonDismiss.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 16.0)
        buttonDismiss.contentHorizontalAlignment = .left
        buttonDismiss.addTarget(self, action: #selector(dismissButtonAction), for: .touchUpInside)
        safari.view.window?.addSubview(buttonDismiss)
    }
    
    @objc func dismissButtonAction() {
        labelTitle.removeFromSuperview()
        buttonDismiss.removeFromSuperview()

        if UIDevice.current.userInterfaceIdiom == .phone {
            buttonDismissView.removeFromSuperview()
        }

        self.dismiss(animated: false) {
            self.dismissTryOnController()
        }
    }
    
    func dismissTryOnController() {
        UIApplication.shared.windows.filter {$0.isKeyWindow}.first!.rootViewController = flutterVC as! UIViewController
    }
    
    func isModel() -> Bool {
        if (self.presentingViewController != nil) {
            return true
        }
        if self.navigationController?.presentingViewController?.presentedViewController == self.navigationController {
            return true
        }
        if ((self.tabBarController?.presentingViewController?.isKind(of: UITabBarController.self)) != nil) {
            return true
        }
        return false
    }
    
    var safeAreaTop: CGFloat {
        if #available(iOS 11.0, tvOS 11.0, *) {
            return yOffSet + (safari.view.window?.safeAreaInsets.top ?? 20)
        }
        return yOffSet
    }

    var safeAreaBottom: CGFloat {
        if #available(iOS 11.0, tvOS 11.0, *) {
            return yOffSet + (safari.view.window?.safeAreaInsets.bottom ?? 0)
        }
        return yOffSet
    }
}

extension TryOnViewController {
    func getUrlStrFromData() -> String {
        var stringData = ""
        for product in options.productData {
            stringData.append("&")
            stringData.append("\(product.category)=")
            stringData.append(product.items.joined(separator: ","))
        }
        return stringData
    }
    
    func getSKU() -> String {
        let product = options.productData.first
        return product?.items.first ?? ""
    }
}

extension TryOnViewController {
    

}



final class TryOnCoordinator: BaseCoordinator{
    weak var navigationController: UINavigationController!
    weak var delegate: TryOnToAppCoordinatorDelegate?
    var options: Options!
    
    override func start() {
        super.start()
//        let vc = TryOnViewController(screenTitle: "Custom Try-On Title", //Optional
//                                     screenTitleColor: .white,    //Optional
//                                     navigationBarColor: .systemPink,  //Optional
//                                     dismissTitle: "Go Back",    //Optional
//                                     dismissTitleColor: .white,    //Optional
//                                     dismissBackgroundColor: .systemPink, // Optional
//                                     options: options //Required
//        )
        
        let vc = TryOnViewController()
//        vc.coordinatorDelegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    init(navigationController: UINavigationController?) {
        super.init()
        self.navigationController = navigationController
    }
}

protocol TryOnCoordinatorDelegate {
    func navigateToFlutter()
}

extension TryOnCoordinator: TryOnCoordinatorDelegate{
    func navigateToFlutter(){
        self.delegate?.navigateToFlutterViewController()
    }
}

public struct Options {
    let brandId: String //Brand ID
    let productData: [ProductData] //Array of Products
    
    public init(brandId: String, productData: [ProductData]) {
        self.brandId = brandId
        self.productData = productData
    }
}

public struct ProductData {
    let category: String // Bracelets, Earrings, Necklaces etc.
    let items: [String] // array of product code
    let type: String // wrist, neck, finger etc.
    
    public init(category: String, items: [String], type: String) {
        self.category = category
        self.items = items
        self.type = type
    }
}


final class FlutterCoordinator: BaseCoordinator {
    weak var navigationController: UINavigationController?
    weak var delegate: FlutterToAppCoordinatorDelegate?
    
    override func start() {
        super.start()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.navigationController?.popToRootViewController(animated: true)
//        }
    }
    
    init(navigationController: UINavigationController?) {
        super.init()
        self.navigationController = navigationController
    }
    
}


protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get }
    func add(_ coordinator: Coordinator)
    func remove(_ coordinator: Coordinator)
    func removeAll()
    func start()
    func start(with options: Options)
}

class BaseCoordinator:  Coordinator{
    var _childCoordinators: [Coordinator] = []
    
    var childCoordinators: [Coordinator] {
        return self._childCoordinators
    }
    
    init() {
        guard type(of: self) != BaseCoordinator.self else {
            fatalError(
                "BaseCoordinator cannot be instantiated"
            )
        }
    }
    
    func add(_ coordinator: Coordinator) {
        self._childCoordinators.append(coordinator)
    }
    
    func remove(_ coordinator: Coordinator) {
        self._childCoordinators = self.childCoordinators.filter { $0 !== coordinator }
    }
    
    func removeAll() {
        self._childCoordinators.removeAll()
    }
    
    func start() {}
    
    func start(with options: Options) {}
}

class AppCoordinator: BaseCoordinator {
    weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController) {
        super.init()
        self.navigationController = navigationController
    }
    
    override func start() {
        super.start()
        navigateToTryOnViewController()
    }
    
    override func start(with options: Options) {
        super.start(with: options)
        navigateToTryOnViewController(with: options)
    }

    
}

protocol TryOnToAppCoordinatorDelegate: AnyObject {
    func navigateToFlutterViewController()
}

protocol FlutterToAppCoordinatorDelegate: AnyObject {
    func navigateToTryOnViewController()
    func navigateToTryOnViewController(with options:Options)
}

extension AppCoordinator: TryOnToAppCoordinatorDelegate{
    func navigateToFlutterViewController(){
        let coordinator = FlutterCoordinator(navigationController: self.navigationController)
        coordinator.delegate = self
        self.add(coordinator)
        coordinator.start()
    }
}

extension AppCoordinator: FlutterToAppCoordinatorDelegate{
    func navigateToTryOnViewController() {
        let coordinator = TryOnCoordinator(navigationController: self.navigationController)
        coordinator.delegate = self
        self.add(coordinator)
        coordinator.start()
    }
    
    func navigateToTryOnViewController(with options:Options) {
        let coordinator = TryOnCoordinator(navigationController: self.navigationController)
        coordinator.delegate = self
        coordinator.options = options
        self.add(coordinator)
        coordinator.start()
    }
}
