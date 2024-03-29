import Foundation
import Alamofire
import PromiseKit

public class NetworkTask<T: Decodable>: NSObject {

    private var cHttpMethod = HTTPMethod.get
    private var cHttpHeader: HTTPHeaders?
    private var cParameter: [String: String]?
    var isAuthorization = NetworkUtil.Authorization.dontCare {
        didSet {
            if isAuthorization == .required {
                cHttpHeader?[NetworkUtil.AUTHORIZATION] = NetworkUtil.basicAuth
            }
        }
    }
    
    // MARK: - NetworkTask Init
    
    /// Creates a `NetworkTask` using the default `SessionManager` to retrieve the contents of the specified `url`,
    /// `method`, `parameters`, `encoding` and `headers`.
    ///
    /// - parameter method:     The HTTP method. `.get` by default.
    /// - parameter parameters: The parameters. `nil` by default.
    /// - parameter headers:    The HTTP headers. `nil` by default.
    ///
    /// - returns: Void.
    public init(method: HTTPMethod = .get, parameter: [String: String]? = nil, header: [String: String]? = nil) {
        self.cHttpMethod = method
        let mHeader = header ?? NetworkUtil.getHttpheader()
        self.cHttpHeader = HTTPHeaders(mHeader)
        self.cParameter = parameter
    }
    
    private func configureKey() {
        //TODO
    }

    // MARK: - Data Request
    
    /// Creates a `DataRequest` using the default `Alamofire` to retrieve the contents of the specified `url`,
    ///
    /// - parameter url:        The URL.
    ///
    /// - returns: The created `Promise<T>`.
    public func requestNetworkConnection(_ url: String) -> Promise<T> {
    
        print("requestNetworkConnection url is \(url)\nheader is \(String(describing: self.cHttpHeader))")
        
        return Promise { seal in
            AF.request(url, method: self.cHttpMethod, parameters: self.cParameter, headers: self.cHttpHeader)
                .validate()
                .response { res in
                    guard let response = res.response, let responseData = res.data else {
                        return seal.reject(NetworkError.networkError)
                    }
                    print("[🍎🍊]response:\(response)")
                    if 200 ..< 300 ~= response.statusCode {
                        let resultData = responseData
                        print("""
                        [😝😜🤪] JsonResult
                        \(NetworkUtil.convertToPrettyString(from: resultData))
                        """)
                        do {
                            let decodedJson = try JSONDecoder().decode(T.self, from: resultData)
                            seal.fulfill(decodedJson)
                        } catch let error as NSError {
                            print("ParsingError : \(error)")
                            seal.reject(NetworkError.jsonDecodingError)
                        }
                    } else if let myServerError = try? JSONDecoder().decode(MYServerError.self, from: responseData) {
                        if myServerError.code == NetworkUtil.RETRY {
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(3 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
                                self.requestNetworkConnection(url)
                                    .pipe(to: {
                                        seal.resolve($0)
                                    })
                            }
                        } else {
                            seal.reject(NetworkError.serverError(myServerError))
                        }
                    } else {
                        seal.reject(NetworkError.unKnownHttpError(status: response.statusCode))
                    }
                    
                }
        }
    }
    
    deinit {
        print("networkTask Dealloc")
    }
    
}

