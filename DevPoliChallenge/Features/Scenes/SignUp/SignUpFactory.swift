import UIKit

enum SignUpFactory {
    static func make() -> UIViewController {
        let coordinator = SignUpCoordinator()
        let presenter = SignUpPresenter(coordinator: coordinator)
        let service = SignUpService()
        let interactor = SignUpInteractor(presenter: presenter, service: service)
        let viewController = SignUpViewController(interactor: interactor)
        
        coordinator.viewController = viewController
        presenter.viewController = viewController
        
        return viewController
    }
}
