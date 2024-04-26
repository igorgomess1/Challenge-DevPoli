import SnapKit
import UIKit

protocol TextFieldComponentDelegate {
    func textFieldDidChanged(isValid: Bool, bitmask: Int)
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
        return label
    }()
    
    var errorMessage: String? {
        get {
            return errorLabel.text
        }
        set {
            errorLabel.text = newValue
        }
    }
    
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
    
    var bitmask: Int = 0
    
    var validationRule: ((String?) -> Bool)?
    
    var delegate: TextFieldComponentDelegate?
    
    init() {
        super.init(frame: CGRect.zero)
        setupViewHierarchy()
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { nil}
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
    
    func validateInput() -> Bool {
        guard let rule = validationRule else {
            return true
        }
        
        if isTextFieldEmpty(textField: textField) {
            return true
        } else {
            let isValid = rule(textField.text)
            return isValid
        }
    }
    
    func isTextFieldEmpty(textField: UITextField) -> Bool {
        if let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !text.isEmpty {
            return false
        } else {
            return true
        }
    }
    
    @objc
    func textFieldDidChanged(_ textField: UITextField) {
        if validateInput() {
            self.containerStackView.addArrangedSubview(self.errorLabel)
            self.errorLabel.isHidden = false

            delegate?.textFieldDidChanged(isValid: false, bitmask: bitmask)
        } else {
            self.containerStackView.removeArrangedSubview(self.errorLabel)
            self.errorLabel.isHidden = true

            delegate?.textFieldDidChanged(isValid: true, bitmask: bitmask)
        }

    }
}

