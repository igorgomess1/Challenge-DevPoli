import AuthenticationServices

protocol SignInInteracting {
    func login(email: String, password: String)
    func openSignUp()
    func checkErrosTexField(isValid: Bool, bitmask: Int)
    func facebookLogin()
    func handleAuthorization(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    )
}
final class SignInInteractor {
    private let presenter: SignInPresenting
    private let service: SignInServicing
    private var bistmaskResult = 0
    
    init(presenter: SignInPresenting, service: SignInServicing) {
        self.presenter = presenter
        self.service = service
    }
}

extension SignInInteractor: SignInInteracting {
    func login(email: String, password: String) {
        service.login(email: email, password: password) { [weak self] result in
            switch result {
            case .success(_):
                self?.handledSuccess()
            case .failure(let error):
                self?.handledFailure(error: error)
            }
        }
    }
    
    func openSignUp() {
        presenter.openSignUp()
    }
    
    func checkErrosTexField(isValid: Bool, bitmask: Int) {
        if isValid {
            self.bistmaskResult = self.bistmaskResult | bitmask
        } else {
            self.bistmaskResult = self.bistmaskResult & ~bitmask
        }
        
        presenter.updateButtonState(isEnabled:
        (IdentifierTextField.email.rawValue & self.bistmaskResult != 0) &&
        (IdentifierTextField.password.rawValue & self.bistmaskResult != 0)
        )
    }
    
    func facebookLogin() {
        service.loginWithFacebook { [weak self] result in
            switch result {
            case .success(let success):
                let email = success.0
                print(email)
                self?.handledSuccess()
            case .failure(let failure):
                self?.handledFailure(error: failure)
            }
        }
    }
    
    func handleAuthorization(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        service.handleAuthorization(
            controller: controller,
            didCompleteWithAuthorization: authorization
        ) { [weak self] result in
            switch result {
            case .success:
                self?.handledSuccess()
            case .failure(let error):
                self?.handledFailure(error: error)
            }
        }
    }
}

private extension SignInInteractor {
    func handledSuccess() {
        presenter.presentAlert(title: "Login Realizado com Sucesso", message: nil)
    }
    
    func handledFailure(error: Error) {
        print(error.localizedDescription)
        presenter.presentAlert(
            title: "Email ou Senha incorretos",
            message: "Ocorreu um erro ao realizar o login, tente novamente mais tarde"
        )
    }
}
