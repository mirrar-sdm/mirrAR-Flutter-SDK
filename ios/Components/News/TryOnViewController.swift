//
//  TryOnViewController.swift
//  mirrAR
//
//  Created by Krishna Datt Shukla on 01/06/21.
//

import UIKit
import SafariServices

fileprivate let SCREEN_HEIGHT = UIScreen.main.bounds.height
fileprivate let SCREEN_WIDTH  = UIScreen.main.bounds.width

fileprivate let BASE_URL = "https://cdn.styledotme.com/general/mirrar.html"

public final class TryOnViewController: UIViewController {
    var coordinatorDelegate: TryOnCoordinatorDelegate?
    var navController: UINavigationController!

    private var safari: SFSafariViewController!
    private var labelTitle: UILabel!
    private var buttonDismissView: UIView!
    private var buttonDismiss: UIButton!

    private var yOffSet: CGFloat = 44.0
    
    private var screenTitle = "Virtual Try-on"
    private var screenTitleColor = UIColor.black
    private var navigationBarColor = UIColor.white

    private var dismissButtonTitle = " ᐸ Dismiss"
    private var dismissButtonTitleColor = UIColor.black
    private var dismissBackgroundColor = UIColor.black

    private var options: Options!
    
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

    private func addSubViewsToSafari() {
        safari.view.frame = CGRect(x:safari.view.frame.origin.x, y:safari.view.frame.origin.y, width: safari.view.frame.size.width, height: safari.view.frame.size.height);
        addTitle()
        addDismissButton()
    }
    
    private func addTitle() {
        labelTitle = UILabel(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: safeAreaTop))
        labelTitle.numberOfLines = 2
        labelTitle.text = safeAreaTop > yOffSet ? "\n\(screenTitle)" : screenTitle
        labelTitle.backgroundColor = navigationBarColor
        labelTitle.textColor = screenTitleColor
        labelTitle.textAlignment = .center
        labelTitle.font = UIFont(name: "Avenir-Heavy", size: 20.0)
        safari.view.window?.addSubview(labelTitle)
    }
    
    private func addDismissButton() {
        if UIDevice.current.userInterfaceIdiom == .pad {
            addDismissButtonForIPad()
        } else {
            addDismissButtonForIPhone()
        }
    }
    
    private func addDismissButtonForIPhone() {
        buttonDismissView = UIView(frame: CGRect(x: 0, y: SCREEN_HEIGHT-safeAreaBottom, width: SCREEN_WIDTH, height: safeAreaTop))
        buttonDismissView.backgroundColor = dismissBackgroundColor
        
        buttonDismiss = UIButton(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 44))
        buttonDismiss.backgroundColor = .clear
        buttonDismiss.setTitleColor(dismissButtonTitleColor, for: .normal)
        buttonDismiss.setTitle(dismissButtonTitle, for: .normal)
        buttonDismiss.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 16.0)
        buttonDismiss.contentHorizontalAlignment = .left
        buttonDismiss.addTarget(self, action: #selector(dismissButtonAction), for: .touchUpInside)
        buttonDismissView.addSubview(buttonDismiss)
        safari.view.window?.addSubview(buttonDismissView)
    }
    
    private func addDismissButtonForIPad() {
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
    
    @objc private func dismissButtonAction() {
        labelTitle.removeFromSuperview()
        buttonDismiss.removeFromSuperview()

        if UIDevice.current.userInterfaceIdiom == .phone {
            buttonDismissView.removeFromSuperview()
        }

        self.dismiss(animated: false) {
            self.dismissTryOnController()
        }
    }
    
    private func dismissTryOnController() {
        coordinatorDelegate?.navigateToFlutter()
    }
    
    private func isModel() -> Bool {
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
    
    private var safeAreaTop: CGFloat {
        if #available(iOS 11.0, tvOS 11.0, *) {
            return yOffSet + (safari.view.window?.safeAreaInsets.top ?? 20)
        }
        return yOffSet
    }

    private var safeAreaBottom: CGFloat {
        if #available(iOS 11.0, tvOS 11.0, *) {
            return yOffSet + (safari.view.window?.safeAreaInsets.bottom ?? 0)
        }
        return yOffSet
    }
}
