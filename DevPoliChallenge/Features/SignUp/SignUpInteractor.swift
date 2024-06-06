import UIKit

protocol SignUpInteracting {
    func createAccount()
    func openTermsAndConditionsWebView()
    func textFieldDidChanged(text: String?, identifier: TextFieldIdentifier, bitmask: Int)
}

final class SignUpInteractor {
    private let presenter: SignUpPresenting
    private let service: SignUpServicing
    
    private var emailAccount: String?
    private var passwordAccount: String?
    
    private var bistmaskResult = 0
    
    init(presenter: SignUpPresenting, service: SignUpServicing) {
        self.presenter = presenter
        self.service = service
    }
}

extension SignUpInteractor: SignUpInteracting {
    func createAccount() {
        guard let emailAccount = emailAccount,
              let passwordAccount = passwordAccount else { return }
        service.createAccount(email: emailAccount, password: passwordAccount) { [weak self] result in
            switch result {
            case .success(_):
                self?.handledSuccess()
            case .failure(let error):
                self?.handledFailure(error: error)
            }
        }
    }
    
    func openTermsAndConditionsWebView() {
        guard let url = URL(string: "https://devpoli.com") else { return }
        presenter.openWebView(url: url)
    }
    
    func textFieldDidChanged(text: String?, identifier: TextFieldIdentifier, bitmask: Int) {
        if let errorText = validateInput(identifier: identifier, text: text) {
            presenter.displayError(identifier: identifier, text: errorText)
            checkErrosTexField(isValid: false, bitmask: bitmask)
        } else {
            presenter.removeError(identifier: identifier)
            checkErrosTexField(isValid: true, bitmask: bitmask)
        }
    }

}

private extension SignUpInteractor {
    func handledSuccess() {
        presenter.presentAlert(title: "Cadastro Realizado com Sucesso", message: nil)
    }
    
    func handledFailure(error: Error) {
        print(error.localizedDescription)
        presenter.presentAlert(
            title: "Erro ao Realizar cadastro",
            message: "Ocorreu um erro ao realizar o cadastro, tente novamente mais tarde"
        )
    }
    
    func validateInput(identifier: TextFieldIdentifier, text: String?) -> String? {
        switch identifier {
        case .name, .lastName:
            return validateNameAndLastName(text: text)
        case .email:
            return validateEmail(text: text)
        case .password:
            return validatePassword(text: text)
        case .confirmPassword:
            return validateConfirmPassword(text: text)
        }
    }

    func validateNameAndLastName(text: String?) -> String? {
        guard let text = text, !text.isEmpty else {
            return "Necessário o preenchimento"
        }
        return nil
    }

    func validateEmail(text: String?) -> String? {
        guard let text = text else {
            return "Email inválido"
        }
        self.emailAccount = text
        return text.isValidEmail() ? nil : "Email inválido"
    }

    func validatePassword(text: String?) -> String? {
        guard let text = text else {
            return "A senha deve ter 6 caracteres ou mais"
        }
        self.passwordAccount = text
        return text.count >= 6 ? nil : "A senha deve ter 6 caracteres ou mais"
    }

    func validateConfirmPassword(text: String?) -> String? {
        guard let text = text else {
            return "A senha não confere"
        }
        return self.passwordAccount == text ? nil : "A senha não confere"
    }
    
    func checkErrosTexField(isValid: Bool, bitmask: Int) {
        if isValid {
            self.bistmaskResult = self.bistmaskResult | bitmask
        } else {
            self.bistmaskResult = self.bistmaskResult & ~bitmask
        }
        
        presenter.updateButtonState(isEnabled:
        (IdentifierTextField.firstName.rawValue & self.bistmaskResult != 0) &&
        (IdentifierTextField.lastName.rawValue & self.bistmaskResult != 0) &&
        (IdentifierTextField.email.rawValue & self.bistmaskResult != 0) &&
        (IdentifierTextField.password.rawValue & self.bistmaskResult != 0) &&
        (IdentifierTextField.validationPassword.rawValue & self.bistmaskResult != 0)
        )
    }
}
