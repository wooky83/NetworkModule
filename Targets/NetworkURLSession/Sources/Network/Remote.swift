import Foundation
import Combine

class Remote<T: Decodable>: NSObject {

    private var cUrl: String
    private var cHttpMethod: String
    private var cHttpHeader: [String: String]?
    private var cParameter: [String: String]?
    var isAuthorization = NetworkUtil.Authorization.dontCare {
        didSet {
            if isAuthorization == .required {
                cHttpHeader?[NetworkUtil.AUTHORIZATION] = NetworkUtil.basicAuth
            }
        }
    }

    init(url: String, method: String = "GET", parameter: [String: String]? = nil, header: [String: String]? = nil) {
        self.cUrl = url
        self.cHttpMethod = method
        self.cHttpHeader = header
        self.cParameter = parameter
    }

    func requestNetworkConnection() async throws -> T {

        print("requestNetworkConnection url is \(cUrl)\nheader is \(String(describing: self.cHttpHeader))")
        var urlRequest = URLRequest(url: URL(string: self.cUrl)!)
        urlRequest.httpMethod = self.cHttpMethod

        let (resultData, response) = try await URLSession.shared.data(for: urlRequest)
        guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else { throw NetworkError.networkError }
        print("[😝😜🤪] JsonResult : \(String(describing: String(data: resultData, encoding: .utf8)))")

        do {
            let decodedResponse = try JSONDecoder().decode(T.self, from: resultData)
            return decodedResponse
        } catch {
            throw NetworkError.jsonDecodingError
        }
    }
    
    deinit {
        print("🥱 Remote Dealloc")
    }
    
}
