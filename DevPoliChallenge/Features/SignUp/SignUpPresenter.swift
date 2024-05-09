import UIKit

protocol SignUpPresenting {
    func presentAlert(title: String, message: String?)
    func updateButtonState(isEnabled: Bool)
    func openWebView(url: URL)
}

final class SignUpPresenter {
    private let coordinator: SignUpCoordinating
    weak var viewController: SignUpDisplaying?
    
    init(coordinator: SignUpCoordinating) {
        self.coordinator = coordinator
    }
}

extension SignUpPresenter: SignUpPresenting {
    func presentAlert(title: String, message: String?) {
        viewController?.setupAlert(title: title, message: message)
    }
    
    func updateButtonState(isEnabled: Bool) {
        viewController?.updateButtonState(isEnabled: isEnabled)
    }
    
    func openWebView(url: URL) {
        coordinator.openWebView(url: url)
    }
}
