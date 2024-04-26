protocol SignInPresenting {
    func openSignUp()
    func presentAlert(title: String, message: String?)
    func updateButtonState(isEnabled: Bool)
}
final class SignInPresenter {
    private let coordinator: SignInCoordinating
    weak var viewController: SignInDisplaying?
    
    init(coordinator: SignInCoordinating) {
        self.coordinator = coordinator
    }
}

extension SignInPresenter: SignInPresenting {
    func openSignUp() {
        coordinator.openSignUp()
    }
    
    func presentAlert(title: String, message: String?) {
        viewController?.setupAlert(title: title, message: message)
    }
    
    func updateButtonState(isEnabled: Bool) {
        viewController?.updateButtonState(isEnabled: isEnabled)
    }
}

