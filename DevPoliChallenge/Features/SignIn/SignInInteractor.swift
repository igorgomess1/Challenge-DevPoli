import AuthenticationServices

protocol SignInInteracting {
    func login(email: String?, password: String?)
    func openSignUp()
    func facebookLogin()
    func handleAuthorization(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    )
}

final class SignInInteractor {
    private let presenter: SignInPresenting
    private let service: SignInServicing
    private var bitmaskResult = 0
        
    init(presenter: SignInPresenting, service: SignInServicing) {
        self.presenter = presenter
        self.service = service
    }
}

extension SignInInteractor: SignInInteracting {
    func login(email: String?, password: String?) {
        if let email = email, !email.isEmpty, let password = password {
            login(email: email, password: password)
        } else if email == nil || email?.isEmpty == true {
            presenter.presentAlert(title: "Informe o e-mail para continuar", message: nil)
        }
    }
    
    func openSignUp() {
        presenter.openSignUp()
    }
    
    func facebookLogin() {
        service.loginWithFacebook { [weak self] result in
            switch result {
            case .success(_):
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
    
    func handledSuccess() {
        presenter.presentAlert(title: "Login Realizado com Sucesso", message: nil)
    }
    
    func handledFailure(error: Error) {
        print(error.localizedDescription)
        presenter.presentAlert(
            title: "Erro ao realizar login",
            message: "Ocorreu um erro ao realizar o login, tente novamente mais tarde."
        )
    }
}
