import Foundation
import RxAlamofire
import RxSwift

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

    private func request() -> Observable<T> {
        RxAlamofire
            .request(urlRequest)
            .validate(statusCode: 200 ..< 300)
            .responseData()
            .map(\.1)
            .decode(type: T.self, decoder: JSONDecoder())
            .observe(on: MainScheduler.instance)
            .asObservable()
    }
    
    deinit {
        print("🥱 Rx Remote Dealloc!!")
    }
    
}

public extension Remote {
    func asObservable() -> Observable<T> {
        request()
    }
}
