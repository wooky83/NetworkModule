import Foundation
import Combine

public class Remote<T: Decodable> {

    public enum HTTPMethod: String {
        case GET, POST
    }

    private var urlRequest: URLRequest

    var isAuthorization = NetworkUtil.Authorization.dontCare {
        didSet {
            if isAuthorization == .required {
                urlRequest.allHTTPHeaderFields?.updateValue(NetworkUtil.basicAuth, forKey: NetworkUtil.AUTHORIZATION)
            }
        }
    }

    public init(url: String, method: HTTPMethod = .GET, parameter: [String: String]? = nil, header: [String: String]? = nil) {
        self.urlRequest = Self.configureURLRequest(url: url, method: method, parameter: parameter, header: header)
    }

    private static func configureURLRequest(url: String, method: HTTPMethod, parameter: [String: String]?, header: [String: String]?) -> URLRequest {
        var destUrl = url
        if case .GET = method, let parameter {
            destUrl.append(contentsOf: "?\(parameter.map { "\($0.key)=\($0.value)" }.joined(separator: "&"))")
        }
        var urlRequest = URLRequest(url: URL(string: destUrl)!)
        urlRequest.httpMethod = method.rawValue
        if let header {
            urlRequest.allHTTPHeaderFields?.merge(header) { _, rhs in rhs }
        }
        return urlRequest
    }

    func request() -> AnyPublisher<T, Error> {
        URLSession.shared
            .dataTaskPublisher(for: urlRequest)
            .tryMap { (data, response) -> Data in
                guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else { throw NetworkError.httpError }
                Log.network("""
                [😝😜🤪] JsonResult
                \(NetworkUtil.convertToPrettyString(from: data))
                """)
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                if case is DecodingError = error {
                    return NetworkError.jsonDecodingError
                }
                return error
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    deinit {
        Log.network("🥱 Remote Dealloc!!")
    }
    
}

