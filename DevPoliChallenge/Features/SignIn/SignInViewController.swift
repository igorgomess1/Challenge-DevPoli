import UIKit
import SnapKit
import AuthenticationServices

protocol SignInDisplaying: AnyObject {
    func setupAlert(title: String, message: String?)
    func updateButtonState(isEnabled: Bool)
}

final class SignInViewController: UIViewController {
    private let interactor: SignInInteracting
    private lazy var emailText: String? = " "
    private var passwordText: String?
    
    private lazy var headerContainerView = UIView()
    
    private lazy var headerTitle: UILabel = {
        let title = UILabel()
        title.text = "Olá \nQuer melhorar sua vida finaceira?"
        title.textColor = .black
        title.font = UIFont.boldSystemFont(ofSize: 20.0)
        title.numberOfLines = 2
        
        return title
    }()
    
    private lazy var descriptionTitle: UILabel = {
        let description = UILabel()
        description.text = "Identifique-se e fique por dentro de todas as novidades!"
        description.textColor = DesignSystem.Colors.silver
        description.numberOfLines = .zero
        return description
    }()
    
    private lazy var informationsContainerView = UIView()
    
    private lazy var emailTextField = setupEmailTextField()
    
    private lazy var passwordTextField = setupPasswordTextField()
    
    private lazy var forgotPasswordText: UILabel = {
        let label = UILabel()
        label.text = "Esqueci a senha"
        label.textColor = DesignSystem.Colors.primary
        label.font = UIFont.boldSystemFont(ofSize: 14.0)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(openForgotPassword))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tap)
        return label
    }()
    
    private lazy var enterButton: UIButton = {
        let button = UIButton()
        button.setTitle("Entrar", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.gray
        button.layer.cornerRadius = 10.0
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
        button.isEnabled = true
        
        button.addTarget(self, action: #selector(loginAccount), for: .touchUpInside)
        return button
    }()
    
    private lazy var linesContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var lineLeftView: UIView = {
        let view = UIView()
        view.backgroundColor = DesignSystem.Colors.gainsboro
        return view
    }()
    
    private lazy var enterWithText: UILabel = {
        let label = UILabel()
        label.text = "Entre com"
        label.textAlignment = .center
        label.textColor = .lightGray
        return label
    }()
    
    private lazy var lineRightView: UIView = {
        let view = UIView()
        view.backgroundColor = DesignSystem.Colors.gainsboro
        return view
    }()
    
    private lazy var otherLoginOptionsContainerView = UIView()
    
    private lazy var loginsContainerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 14
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var loginFacebookView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderColor = DesignSystem.Colors.gainsboro.cgColor
        view.layer.borderWidth = 0.5
        view.layer.cornerRadius = 10.0
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(openLoginWithFacebook))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tap)
        
        return view
    }()
    
    private lazy var loginFacebookImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icon-facebook")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var loginFacebookText: UILabel = {
        let label = UILabel()
        label.text = "Facebook"
        label.textColor = .black
        return label
    }()
    
    private lazy var loginAppleView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderColor = DesignSystem.Colors.gainsboro.cgColor
        view.layer.borderWidth = 0.5
        view.layer.cornerRadius = 10.0
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(openLoginWithApple))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tap)
        return view
    }()
    
    private lazy var loginAppleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icon-apple")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var loginAppleText: UILabel = {
        let label = UILabel()
        label.text = "Apple"
        label.textColor = .black
        return label
    }()
    
    private lazy var createAccountStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = .zero
        return stackView
    }()
        
    private lazy var noAccountText: UILabel = {
        let label = UILabel()
        label.text = "Não tem conta? Criar Conta"
        label.textColor = .black
        label.textAlignment = .center
        label.attributedText = AddColorInPartText(
            "Não tem conta? Criar Conta",
            textToColor: "Criar Conta"
        )
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(openSignUp))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tap)
        return label
    }()
    
    init(interactor: SignInInteracting) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { nil }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewHierarchy()
        setupConstraints()
        view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavigatioBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc
    func dismissKeyboard(_ view: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
}

private extension SignInViewController {
    func AddColorInPartText(_ text: String, textToColor: String) -> NSMutableAttributedString {
        guard let range = text.range(of: textToColor) else { return .init()}
        
        let attributedSubstring = NSMutableAttributedString(string: String(text))
        
        attributedSubstring.addAttribute(
            .foregroundColor, value: DesignSystem.Colors.primary,
            range: NSRange(range, in: text)
        )
        
        return attributedSubstring
    }
    
    @objc
    func loginAccount() {
        guard let email = emailText, let password = passwordText else { return }
        interactor.login(email: email, password: password)
    }
    
    @objc
    func openForgotPassword() {
        setupAlert(title: "Esqueceu a senha", message: nil)
    }
    
    @objc
    func openLoginWithFacebook() {
        interactor.facebookLogin()
    }
    
    @objc
    func openLoginWithApple() {
        let authorizationController = ASAuthorizationController(
            authorizationRequests: [createAppleIDAuthorizationRequest()]
        )
        authorizationController.delegate = self
        
        authorizationController.performRequests()
    }
    
    @objc
    func openSignUp() {
        interactor.openSignUp()
    }
    
    func setupNavigatioBar() {
        let backButtonImage = UIImage(named: "left")

        navigationItem.backBarButtonItem = .init(title: "", style: .plain, target: nil, action: nil)
        
        navigationController?.navigationBar.backIndicatorImage = backButtonImage
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = backButtonImage
    }
    
    func setupEmailTextField() -> UIView {
        let textFieldComponentView = TextFieldComponentView()
        textFieldComponentView.placeholder = "Email"
        textFieldComponentView.errorMessage = "Informe o e-mail para continuar"
        textFieldComponentView.bitmask = IdentifierTextField.email.rawValue
        textFieldComponentView.delegate = self
        
        textFieldComponentView.validationRule = { inputText in
            guard let text = inputText else { return false}
            self.emailText = text
            return !text.isValidEmail() && !text.isEmpty
        }
        
        return textFieldComponentView
    }
    
    func setupPasswordTextField() -> UIView {
        let textFieldComponentView = TextFieldComponentView()
        textFieldComponentView.placeholder = "Senha"
        textFieldComponentView.errorMessage = "A senha deve ter 6 caracteres ou mais"
        textFieldComponentView.isPassword = true
        textFieldComponentView.bitmask = IdentifierTextField.password.rawValue
        textFieldComponentView.delegate = self
        
        textFieldComponentView.validationRule = { inputText in
            guard let text = inputText else { return false}
            self.passwordText = text
            return text.count <= 5 && !text.isEmpty
        }
        
        return textFieldComponentView
    }
    
    func createAppleIDAuthorizationRequest() -> ASAuthorizationAppleIDRequest {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        return request
    }
}

extension SignInViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let window = view.window else { return .init()}
        
        return window
    }
}

extension SignInViewController {
    func setupViewHierarchy() {
        view.addSubview(headerContainerView)
        headerContainerView.addSubview(headerTitle)
        headerContainerView.addSubview(descriptionTitle)
        
        view.addSubview(informationsContainerView)
        informationsContainerView.addSubview(emailTextField)
        informationsContainerView.addSubview(passwordTextField)
        informationsContainerView.addSubview(forgotPasswordText)
        informationsContainerView.addSubview(enterButton)
        
        view.addSubview(otherLoginOptionsContainerView)
        otherLoginOptionsContainerView.addSubview(linesContainerView)
        linesContainerView.addSubview(lineLeftView)
        linesContainerView.addSubview(enterWithText)
        linesContainerView.addSubview(lineRightView)
        otherLoginOptionsContainerView.addSubview(loginsContainerStackView)
        loginsContainerStackView.addArrangedSubview(loginFacebookView)
        loginFacebookView.addSubview(loginFacebookImageView)
        loginFacebookView.addSubview(loginFacebookText)
        loginsContainerStackView.addArrangedSubview(loginAppleView)
        loginAppleView.addSubview(loginAppleImageView)
        loginAppleView.addSubview(loginAppleText)
        otherLoginOptionsContainerView.addSubview(createAccountStackView)
        createAccountStackView.addArrangedSubview(noAccountText)
    }
    
    func setupConstraints() {
        headerContainerView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(50)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        
        headerTitle.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        
        descriptionTitle.snp.makeConstraints {
            $0.top.equalTo(headerTitle.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        informationsContainerView.snp.makeConstraints {
            $0.top.equalTo(headerContainerView.snp.bottom).offset(100)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        
        emailTextField.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview()
        }
        
        forgotPasswordText.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(10)
            $0.leading.greaterThanOrEqualToSuperview()
            $0.trailing.equalToSuperview()
        }
        
        enterButton.snp.makeConstraints {
            $0.top.equalTo(forgotPasswordText.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(8)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(50)
        }
        
        otherLoginOptionsContainerView.snp.makeConstraints {
            $0.top.equalTo(informationsContainerView.snp.bottom).offset(70)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview()
        }
        
        loginFacebookImageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(14)
            $0.leading.equalToSuperview().inset(20)
            $0.size.equalTo(25)
        }
        
        loginFacebookText.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(14)
            $0.leading.equalTo(loginFacebookImageView.snp.trailing).offset(6)
            $0.trailing.equalToSuperview()
        }
        
        loginAppleImageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(14)
            $0.leading.equalToSuperview().inset(20)
            $0.size.equalTo(25)
        }
        
        loginAppleText.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(14)
            $0.leading.equalTo(loginAppleImageView.snp.trailing).offset(3)
            $0.trailing.equalToSuperview()
        }
        
        linesContainerView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        lineLeftView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.height.equalTo(3)
            $0.width.equalTo(100)
        }
        
        enterWithText.snp.makeConstraints {
            $0.center.equalTo(linesContainerView.snp.center)
            $0.leading.lessThanOrEqualTo(lineLeftView.snp.trailing)
        }
        
        lineRightView.snp.makeConstraints {
            $0.top.bottom.trailing.equalToSuperview()
            $0.leading.lessThanOrEqualTo(enterWithText.snp.trailing)
            $0.width.equalTo(100)
        }
        
        loginsContainerStackView.snp.makeConstraints {
            $0.top.equalTo(linesContainerView.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview()
        }
        
        createAccountStackView.snp.makeConstraints {
            $0.top.equalTo(loginsContainerStackView.snp.bottom).offset(46)
            $0.trailing.leading.equalToSuperview().inset(24)
            $0.bottom.lessThanOrEqualTo(view.safeAreaLayoutGuide)
        }
    }
}

extension SignInViewController: SignInDisplaying {
    func setupAlert(title: String, message: String?) {
        let alertMessagePopUpBox = UIAlertController(
            title: title,
            message: message, preferredStyle: .alert
        )
        
        let okButton = UIAlertAction(title: "Ok", style: .default) {  action in
            self.navigationController?.popViewController(animated: true)
        }
        
        alertMessagePopUpBox.addAction(okButton)
        self.present(alertMessagePopUpBox, animated: true)
    }
    
    func updateButtonState(isEnabled: Bool) {
        enterButton.isEnabled = isEnabled
        enterButton.backgroundColor = isEnabled ? DesignSystem.Colors.accent : UIColor.gray
    }
}

extension SignInViewController: TextFieldComponentDelegate {
    func textFieldDidChanged(isValid: Bool, bitmask: Int) {
        interactor.checkErrosTexField(isValid: isValid, bitmask: bitmask)
    }
}

extension SignInViewController: ASAuthorizationControllerDelegate {
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        handleAuthorization(controller: controller, didCompleteWithAuthorization: authorization)
    }
    
    private func handleAuthorization(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        interactor.handleAuthorization(
            controller: controller,
            didCompleteWithAuthorization: authorization
        )
    }
}
