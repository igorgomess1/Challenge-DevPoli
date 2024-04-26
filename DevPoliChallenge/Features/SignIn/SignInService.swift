import FirebaseAuth

import FirebaseAuth

protocol SignInServicing {
    func login(email: String, password: String, completion: @escaping (Result<AuthDataResult?, Error>) -> Void)
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
}
