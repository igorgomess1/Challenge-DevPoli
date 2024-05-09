import UIKit

protocol SignUpCoordinating {
    func openWebView(url: URL)
}

final class SignUpCoordinator {
    weak var viewController: UIViewController?
}

extension SignUpCoordinator: SignUpCoordinating {
    func openWebView(url: URL) {
        let webViewViewController = WebViewViewController(url: url)
        viewController?.present(webViewViewController, animated: true)
    }
}
