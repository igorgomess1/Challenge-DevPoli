import AuthenticationServices
import FBSDKCoreKit
import FBSDKLoginKit
import FirebaseAuth

protocol SignInServicing {
    func login(email: String, password: String, completion: @escaping (Result<AuthDataResult?, Error>) -> Void)
    func loginWithFacebook(completion: @escaping (Result<(String, String), Error>) -> Void)
    func handleAuthorization(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization,
        completion: @escaping (Result<Void, Error>) -> Void
    )
}

final class SignInService { }

extension SignInService: SignInServicing {
    func login(email: String, password: String, completion: @escaping (Result<AuthDataResult?, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let result = result {
                completion(.success(result))
            } else if let error = error {
                completion(.failure(error))
            } else {
                let unknownError = NSError(domain: "", code: 0, userInfo: nil)
                completion(.failure(unknownError))
            }
        }
    }
    
    func loginWithFacebook(completion: @escaping (Result<(String, String), Error>) -> Void) {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["public_profile"], from: nil) { (result, error) in
            if let error = error {
                completion(.failure(error))
            } else if let result = result, !result.isCancelled {
                self.fetchFacebookUserData(completion: completion)
            } else {
                let cancelError = NSError(
                    domain: "FacebookLogin",
                    code: 0,
                    userInfo: [NSLocalizedDescriptionKey: "Login was cancelled."]
                )
                completion(.failure(cancelError))
            }
        }
    }
    
    private func fetchFacebookUserData(completion: @escaping (Result<(String, String), Error>) -> Void) {
        if AccessToken.current != nil {
            GraphRequest(graphPath: "me", parameters: ["fields": "id, name"]).start { (connection, result, error) in
                if let error = error {
                    completion(.failure(error))
                } else if let userData = result as? [String: Any] {
                    guard let userID = userData["id"] as? String, let name = userData["name"] as? String else {
                        let missingDataError = NSError(
                            domain: "FacebookLogin",
                            code: 1,
                            userInfo: [NSLocalizedDescriptionKey: "Missing name or ID data."]
                        )
                        completion(.failure(missingDataError))
                        return
                    }
                    completion(.success((userID, name)))
                }
            }
        } else {
            let noTokenError = NSError(
                domain: "FacebookLogin",
                code: 2,
                userInfo: [NSLocalizedDescriptionKey: "No active Facebook access token."]
            )
            completion(.failure(noTokenError))
        }
    }
    
    func handleAuthorization(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        switch authorization.credential {
        case let credential as ASAuthorizationAppleIDCredential:
            if let _ = credential.email, let _ = credential.fullName {
                signInRegisterNewAccount(credential: credential, completion: completion)
            }
            
        case is ASPasswordCredential:
            // ASPasswordCredential is not handled in this example, add implementation if needed
            break
            
        default:
            break
        }
    }
    
    private func signInRegisterNewAccount(
        credential: ASAuthorizationAppleIDCredential,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        let userIdentifier = credential.user
        guard let userEmail = credential.email else {
            let emailError = NSError(
                domain: "AuthService",
                code: 0,
                userInfo: [NSLocalizedDescriptionKey: "User email not found."]
            )
            completion(.failure(emailError))
            return
        }
        guard let userName = credential.fullName else {
            let nameError = NSError(
                domain: "AuthService",
                code: 1,
                userInfo: [NSLocalizedDescriptionKey: "User name not found."]
            )
            completion(.failure(nameError))
            return
        }
        completion(.success(()))
    }
}
