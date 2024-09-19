import UIKit

protocol SignInCoordinating {
    func openSignUp()
    func openVoiceRecording()
}

final class SignInCoordinator {
    weak var viewController: UIViewController?
}
extension SignInCoordinator: SignInCoordinating {
    func openSignUp() {
        let controller = SignUpFactory.make()
        viewController?.navigationController?.pushViewController(controller, animated: true)
    }
    
    func openVoiceRecording() {
        let controller = VoiceRecordingFactory.make()
        viewController?.navigationController?.present(controller, animated: true)
    }
}

