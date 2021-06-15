import Foundation
import UIKit

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
