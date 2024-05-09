import UIKit
import SnapKit

protocol SignUpDisplaying: AnyObject {
    func setupAlert(title: String, message: String?)
    func updateButtonState(isEnabled: Bool)
}

final class SignUpViewController: UIViewController {
    private let interactor: SignUpInteractor
    
    private lazy var emailText: String? = " "
    private var passwordText: String?
    
    private lazy var titleText: UILabel = {
        let label = UILabel()
        label.text = "Cria sua conta e comece a gerenciar sua vida financeira"
        label.textColor = DesignSystem.Colors.silver
        label.numberOfLines = .zero
        return label
    }()
    
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 8
        stackView.axis = .vertical
        return stackView
    }()

    
    private lazy var firstNameTextField = setupFirstNameTextField()
    
    private lazy var lastNameTextField = setupLastNameTextField()
    
    private lazy var emailTextField = setupEmailTextField()
    
    private lazy var passwordTextField = setupPasswordTextField()
    
    private lazy var validationPasswordTextField = setupValidationPassword()
    
    private lazy var containerBottomView = UIView()
    
    private lazy var termsAndConditionsText: UILabel = {
        let label = UILabel()
        label.text = "Ao criar conta, você concorda com nosso termos e condições de uso"
        label.numberOfLines = .zero
        label.textAlignment = .center
        label.attributedText = AddColorInPartText(
            "Ao criar conta, você concorda com nosso termos e condições de uso",
            textToColor: "termos e condições de uso"
        )
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapTermsAndConditions))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tap)
        return label
    }()
    
    private lazy var createAccountButton: UIButton = {
        let button = UIButton()
        button.setTitle("CRIAR CONTA", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10.0
        button.backgroundColor = UIColor.gray
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
        button.isEnabled = false
        
        button.addTarget(self, action: #selector(createAccount), for: .touchUpInside)
        return button
    }()
    
    init(interactor: SignUpInteractor) {
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
        setupNavigationBar()
    }
}

private extension SignUpViewController {
    func AddColorInPartText(_ text: String, textToColor: String) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: text)

        let range = (text as NSString).range(of: textToColor)
        let font = UIFont.boldSystemFont(ofSize: 16)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: DesignSystem.Colors.primary
        ]
        attributedString.addAttributes(attributes, range: range)
        
        return attributedString
    }
        
    func setupNavigationBar() {
        navigationItem.title = "Criar Conta"
    }
    
    @objc
    func dismissScreen() {
        dismiss(animated: true)
    }
    
    @objc
    func didTapTermsAndConditions() {
        interactor.openTermsAndConditionsWebView()
    }
    
    @objc
    func createAccount() {
        guard let email = emailText, let password = passwordText else { return }
        interactor.createAccount(email: email, password: password)
    }
    
    func setupFirstNameTextField() -> UIView {
        let textFieldComponentView = TextFieldComponentView()
        textFieldComponentView.placeholder = "Primeiro nome"
        textFieldComponentView.errorMessage = "Necessário preenchimento"
        textFieldComponentView.bitmask = IdentifierTextField.firstName.rawValue
        textFieldComponentView.delegate = self
        
        textFieldComponentView.validationRule = { inputText in
            guard let text = inputText else { return false}
            return text.isEmpty
        }
        
        return textFieldComponentView
    }
    
    func setupLastNameTextField() -> UIView {
        let textFieldComponentView = TextFieldComponentView()
        textFieldComponentView.placeholder = "Útimo nome"
        textFieldComponentView.errorMessage = "Necessário preenchimento"
        textFieldComponentView.bitmask = IdentifierTextField.lastName.rawValue
        textFieldComponentView.delegate = self
        
        textFieldComponentView.validationRule = { inputText in
            guard let text = inputText else { return false}
            return text.isEmpty
        }
        
        return textFieldComponentView
    }
    
    func setupEmailTextField() -> UIView {
        let textFieldComponentView = TextFieldComponentView()
        textFieldComponentView.placeholder = "Email"
        textFieldComponentView.errorMessage = "Email inválido"
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
        textFieldComponentView.errorMessage = "A senha deve ter 5 caracteres ou mais"
        textFieldComponentView.isPassword = true
        textFieldComponentView.bitmask = IdentifierTextField.password.rawValue
        textFieldComponentView.delegate = self
        
        textFieldComponentView.validationRule = { inputText in
            guard let text = inputText else { return false}
            self.passwordText = text
            return text.count < 5 && !text.isEmpty
        }
        
        return textFieldComponentView
    }
    
    func setupValidationPassword() -> UIView {
        let textFieldComponentView = TextFieldComponentView()
        textFieldComponentView.placeholder = "Confirmar senha"
        textFieldComponentView.errorMessage = "A senha não confere"
        textFieldComponentView.isPassword = true
        textFieldComponentView.delegate = self
        textFieldComponentView.bitmask = IdentifierTextField.validationPassword.rawValue
        
        textFieldComponentView.validationRule = { inputText in
            guard let text = inputText else { return false}
            return self.passwordText != text && !text.isEmpty
        }
        
        return textFieldComponentView
    }
}

extension SignUpViewController {
    func setupViewHierarchy() {
        view.addSubview(titleText)
        view.addSubview(containerStackView)
        
        containerStackView.addArrangedSubview(firstNameTextField)
        containerStackView.addArrangedSubview(lastNameTextField)
        containerStackView.addArrangedSubview(emailTextField)
        containerStackView.addArrangedSubview(passwordTextField)
        containerStackView.addArrangedSubview(validationPasswordTextField)
        
        view.addSubview(containerBottomView)
        containerBottomView.addSubview(termsAndConditionsText)
        containerBottomView.addSubview(createAccountButton)
    }
    
    func setupConstraints() {
        titleText.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(32)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        
        containerStackView.snp.makeConstraints {
            $0.top.equalTo(titleText.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        
        containerBottomView.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(containerStackView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        termsAndConditionsText.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        
        createAccountButton.snp.makeConstraints {
            $0.top.equalTo(termsAndConditionsText.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(16)
            $0.height.equalTo(50)
        }
    }
}

extension SignUpViewController: SignUpDisplaying {
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
        createAccountButton.isEnabled = isEnabled
        createAccountButton.backgroundColor = isEnabled ? DesignSystem.Colors.accent : UIColor.gray
    }
}

extension SignUpViewController: TextFieldComponentDelegate {
    func textFieldDidChanged(isValid: Bool, bitmask: Int) {
        interactor.checkErrosTexField(isValid: isValid, bitmask: bitmask)
    }
}
