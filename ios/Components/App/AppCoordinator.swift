import Foundation
import UIKit

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
