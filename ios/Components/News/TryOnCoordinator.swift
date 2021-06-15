import Foundation
import UIKit

final class TryOnCoordinator: BaseCoordinator{
    weak var navigationController: UINavigationController!
    weak var delegate: TryOnToAppCoordinatorDelegate?
    var options: Options!
    
    override func start() {
        super.start()
        let vc = TryOnViewController(screenTitle: "Custom Try-On Title", //Optional
                                     screenTitleColor: .white,    //Optional
                                     navigationBarColor: .systemPink,  //Optional
                                     dismissTitle: "Go Back",    //Optional
                                     dismissTitleColor: .white,    //Optional
                                     dismissBackgroundColor: .systemPink, // Optional
                                     options: options //Required
        )
        
//        let vc = TryOnViewController()
        vc.coordinatorDelegate = self
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
