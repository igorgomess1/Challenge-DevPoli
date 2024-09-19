import UIKit

enum SignInFactory {
    static func make() -> UIViewController {
        let coordinator = SignInCoordinator()
        let presenter = SignInPresenter(coordinator: coordinator)
        let service = SignInService()
        let interactor = SignInInteractor(presenter: presenter, service: service)
        let viewController = SignInViewController(interactor: interactor)
        
        coordinator.viewController = viewController
        presenter.viewController = viewController
        
        return viewController
    }
}
