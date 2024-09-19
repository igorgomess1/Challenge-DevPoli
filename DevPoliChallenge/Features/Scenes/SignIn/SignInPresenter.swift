protocol SignInPresenting {
    func openSignUp()
    func presentAlert(title: String, message: String?)
    func displayError(identifier: TextFieldIdentifier, text: String)
    func openVoiceRecording()
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
    
    func displayError(identifier: TextFieldIdentifier, text: String) {
        viewController?.displayTextFieldError(identifier: identifier, text: text)
    }
    
    func openVoiceRecording() {
        coordinator.openVoiceRecording()
    }
}

