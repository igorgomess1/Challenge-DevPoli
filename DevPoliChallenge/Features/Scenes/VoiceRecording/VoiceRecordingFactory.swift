import UIKit

enum VoiceRecordingFactory {
    static func make() -> UIViewController {
        let interactor = VoiceRecordingInteractor()
        let viewController = VoiceRecordingViewController(interactor: interactor)
        
        return viewController
    }
}
