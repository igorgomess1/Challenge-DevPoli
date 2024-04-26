import FirebaseAuth

protocol SignUpServicing {
    func createAccount(email: String, password: String, completion: @escaping (Result<AuthDataResult?, Error>) -> Void)
}

final class SignUpService { }

extension SignUpService: SignUpServicing {
    func createAccount(email: String, password: String, completion: @escaping (Result<AuthDataResult?, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
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
