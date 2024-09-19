//import Foundation
//
//public enum ApiError: Error {
//    case notFound
//    case badRequest
//    case connectionFailure
//    case decodingError(Error)
//}
//
//public enum HTTPMethod: String {
//    case get = "GET"
//    case post = "POST"
//}
//
//open class ApiCompletion {
//    public typealias Success<E: Decodable> = (model: E, data: Data?)
//    public typealias ApiResult<E: Decodable> = Result<Success<E>, ApiError>
//    public typealias Completion<E: Decodable> = (ApiResult<E>) -> Void
//    
//    private var completion: Any
//    
//    public required init<E: Decodable>(_ completion: @escaping Completion<E>) {
//        self.completion = completion
//    }
//}
//
//public protocol ApiEndpointExposable {
//    var baseURL: URL { get }
//    var path: String { get }
//    var method: HTTPMethod { get }
//}
//
//public class Api<E: Decodable> {
//    public typealias Completion = ApiCompletion.Completion<E>
//    public typealias Success = ApiCompletion.Success<E>
//    public typealias Result = ApiCompletion.ApiResult<E>
//    public typealias FullCompletion = ((URLRequest?, Data?, URLResponse?, Error?, Result) -> Void)
//    
//    private let enpoint: ApiEndpointExposable
//    
//    public init(enpoint: ApiEndpointExposable) {
//        self.enpoint = enpoint
//    }
//    
//    public func execute(
//        session: URLSession = URLSession.shared,
//        jsonDecoder: JSONDecoder = JSONDecoder(),
//        _ completion: @escaping Completion,
//        file: String = #file,
//        callingFunctionName: String = #function
//    ) -> URLSessionTask? {
//        
//    }
//}
