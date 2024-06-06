import SnapKit
import UIKit

enum TextFieldIdentifier: String, Equatable {
    case name
    case lastName
    case email
    case password
    case confirmPassword
}

protocol TextFieldComponentDelegate: AnyObject {
    func textFieldDidChanged(text: String?, identifier: TextFieldIdentifier, bitmask: Int)
}

final class TextFieldComponentView: UIView {
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        textField.backgroundColor = DesignSystem.Colors.lightWhite
        textField.addTarget(self, action: #selector(textFieldDidChanged), for: .editingChanged)
        return textField
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 12)
        label.isHidden = true
        return label
    }()
    
    var placeholder: String? {
        get {
            return textField.placeholder
        }
        set {
            textField.placeholder = newValue
        }
    }
    
    var isPassword: Bool {
        get {
            return textField.isSecureTextEntry
        }
        set {
            textField.isSecureTextEntry = newValue
        }
    }
    
    private(set) var identifier: TextFieldIdentifier
    
    var bitmask: Int = 0
    
    var validationRule: ((String?) -> Bool)?
    
    weak var delegate: TextFieldComponentDelegate?
    
    init(identifier: TextFieldIdentifier) {
        self.identifier = identifier
        super.init(frame: CGRect.zero)
        setupViewHierarchy()
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }
    
    func setErrorText(text: String) {
        errorLabel.text = text
        containerStackView.addArrangedSubview(errorLabel)
        errorLabel.isHidden = false
    }
    
    func removeErrorText() {
        containerStackView.removeArrangedSubview(errorLabel)
        errorLabel.isHidden = true
    }
    
    func focusTextField() {
        textField.becomeFirstResponder()
    }
}

private extension TextFieldComponentView {
    func setupViewHierarchy() {
        addSubview(containerStackView)
        containerStackView.addArrangedSubview(textField)
    }
    
    func setupConstraints() {
        containerStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        textField.snp.makeConstraints {
            $0.height.equalTo(50)
        }
    }
    
    @objc
    func textFieldDidChanged(_ textField: UITextField) {
        delegate?.textFieldDidChanged(text: textField.text, identifier: identifier, bitmask: bitmask)
    }
}
