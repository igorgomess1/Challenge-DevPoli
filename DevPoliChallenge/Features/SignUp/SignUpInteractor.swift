protocol SignUpInteracting {
    func createAccount(email: String, password: String)
    func checkErrosTexField(isValid: Bool, bitmask: Int)
}

final class SignUpInteractor {
    private let presenter: SignUpPresenting
    private let service: SignUpServicing
    
    private var bistmaskResult = 0
    
    init(presenter: SignUpPresenting, service: SignUpServicing) {
        self.presenter = presenter
        self.service = service
    }
}

extension SignUpInteractor: SignUpInteracting {
    func createAccount(email: String, password: String) {
        service.createAccount(email: email, password: password) { [weak self] result in
            switch result {
            case .success(_):
                self?.handledSuccess()
            case .failure(let error):
                self?.handledFailure(error: error)
            }
        }
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
}
