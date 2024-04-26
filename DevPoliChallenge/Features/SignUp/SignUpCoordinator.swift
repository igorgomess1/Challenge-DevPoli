import UIKit

protocol SignUpCoordinating {}

final class SignUpCoordinator {
    weak var viewController: UIViewController?
}

extension SignUpCoordinator: SignUpCoordinating { }
