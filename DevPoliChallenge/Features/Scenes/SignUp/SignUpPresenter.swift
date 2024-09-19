import UIKit

protocol SignUpPresenting {
    func presentAlert(title: String, message: String?)
    func updateButtonState(isEnabled: Bool)
    func openWebView(url: URL)
    func displayError(identifier: TextFieldIdentifier, text: String)
    func removeError(identifier: TextFieldIdentifier)
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
    
    func displayError(identifier: TextFieldIdentifier, text: String) {
        viewController?.displayTextFieldError(identifier: identifier, text: text)
    }
    
    func removeError(identifier: TextFieldIdentifier) {
        viewController?.shouldTextFieldError(identifier: identifier)
    }
}
