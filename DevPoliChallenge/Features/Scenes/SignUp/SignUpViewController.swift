import UIKit
import SnapKit

protocol SignUpDisplaying: AnyObject {
    func setupAlert(title: String, message: String?)
    func updateButtonState(isEnabled: Bool)
    func displayTextFieldError(identifier: TextFieldIdentifier, text: String)
    func shouldTextFieldError(identifier: TextFieldIdentifier)
}

final class SignUpViewController: UIViewController {
    private let interactor: SignUpInteractor
    
    private lazy var titleText: UILabel = {
        let label = UILabel()
        label.text = "Cria sua conta e comece a gerenciar sua vida financeira"
        label.textColor = DesignSystem.Colors.silver
        label.numberOfLines = .zero
        label.textAlignment = .center
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
        
        let uiTapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        view.addGestureRecognizer(uiTapGesture)
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
        interactor.createAccount()
    }
    
    @objc
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func setupFirstNameTextField() -> UIView {
        let textFieldComponentView = TextFieldComponentView(identifier: .name)
        textFieldComponentView.placeholder = "Primeiro nome"
        textFieldComponentView.bitmask = IdentifierTextField.firstName.rawValue
        textFieldComponentView.delegate = self
        
        return textFieldComponentView
    }
    
    func setupLastNameTextField() -> UIView {
        let textFieldComponentView = TextFieldComponentView(identifier: .lastName)
        textFieldComponentView.placeholder = "Útimo nome"
        textFieldComponentView.bitmask = IdentifierTextField.lastName.rawValue
        textFieldComponentView.delegate = self
        
        return textFieldComponentView
    }
    
    func setupEmailTextField() -> UIView {
        let textFieldComponentView = TextFieldComponentView(identifier: .email)
        textFieldComponentView.placeholder = "Email"
        textFieldComponentView.bitmask = IdentifierTextField.email.rawValue
        textFieldComponentView.delegate = self
        
        return textFieldComponentView
    }
    
    func setupPasswordTextField() -> UIView {
        let textFieldComponentView = TextFieldComponentView(identifier: .password)
        textFieldComponentView.placeholder = "Senha"
        textFieldComponentView.isPassword = true
        textFieldComponentView.bitmask = IdentifierTextField.password.rawValue
        textFieldComponentView.delegate = self
        
        return textFieldComponentView
    }
    
    func setupValidationPassword() -> UIView {
        let textFieldComponentView = TextFieldComponentView(identifier: .confirmPassword)
        textFieldComponentView.placeholder = "Confirmar senha"
        textFieldComponentView.isPassword = true
        textFieldComponentView.delegate = self
        textFieldComponentView.bitmask = IdentifierTextField.validationPassword.rawValue
        
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
    
    func displayTextFieldError(identifier: TextFieldIdentifier, text: String) {
        for view in containerStackView.arrangedSubviews {
            if let textFieldView = view as? TextFieldComponentView, textFieldView.identifier == identifier {
                textFieldView.setErrorText(text: text)
                break
            }
        }
    }
    
    func shouldTextFieldError(identifier: TextFieldIdentifier) {
        for view in containerStackView.arrangedSubviews {
            if let textFieldView = view as? TextFieldComponentView, textFieldView.identifier == identifier {
                textFieldView.removeErrorText()
                break
            }
        }
    }
}

extension SignUpViewController: TextFieldComponentDelegate {
    func textFieldDidChanged(text: String?, identifier: TextFieldIdentifier, bitmask: Int) {
        interactor.textFieldDidChanged(text: text, identifier: identifier, bitmask: bitmask)
    }
}
