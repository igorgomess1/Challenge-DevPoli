import UIKit

protocol SignInCoordinating {
    func openSignUp()
}

final class SignInCoordinator {
    weak var viewController: UIViewController?
}
extension SignInCoordinator: SignInCoordinating {
    func openSignUp() {
        let controller = SignUpFactory.make()
        viewController?.navigationController?.pushViewController(controller, animated: true)
    }
}

