import Foundation
import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get }
    func add(_ coordinator: Coordinator)
    func remove(_ coordinator: Coordinator)
    func removeAll()
    func start()
    func start(with options: Options)
}

class BaseCoordinator:  Coordinator{
    private var _childCoordinators: [Coordinator] = []
    
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
