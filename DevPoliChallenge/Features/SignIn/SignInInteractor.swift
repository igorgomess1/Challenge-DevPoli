import AuthenticationServices

protocol SignInInteracting {
    func login()
    func openSignUp()
    func facebookLogin()
    func handleAuthorization(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    )
    func getEmailPassword(identifier: TextFieldIdentifier, text: String?)
}

final class SignInInteractor {
    private let presenter: SignInPresenting
    private let service: SignInServicing
    private var bistmaskResult = 0
    
    private var emailAccount: String?
    private var passwordAccount: String?
    
    init(presenter: SignInPresenting, service: SignInServicing) {
        self.presenter = presenter
        self.service = service
    }
}

extension SignInInteractor: SignInInteracting {
    func login() {
        guard let emailAccount = emailAccount, let passwordAccount = passwordAccount else { return }
        service.login(email: emailAccount, password: passwordAccount) { [weak self] result in
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
    
    func getEmailPassword(identifier: TextFieldIdentifier, text: String?) {
        if identifier == .email {
            self.emailAccount = text ?? " "
        } else {
            self.passwordAccount = text ?? " "
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
