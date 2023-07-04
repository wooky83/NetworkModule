import Foundation
import Combine

class NetworkTask<T: Decodable>: NSObject {

    private var cUrl: String
    private var cHttpMethod: String
    private var cHttpHeader: [AnyHashable : Any]?
    private var cParameter: [String: String]?
    var isAuthorization = NetworkUtil.Authorization.dontCare {
        didSet {
            if isAuthorization == .required {
                cHttpHeader?[NetworkUtil.AUTHORIZATION] = NetworkUtil.basicAuth
            }
        }
    }

    init(url: String, method: String = "GET", parameter: [String: String]? = nil, header: [AnyHashable: Any]? = nil) {
        self.cUrl = url
        self.cHttpMethod = method
        self.cHttpHeader = header
        self.cParameter = parameter
    }
    
    private func configureKey() {
        //TODO
    }

    func asPublisher() -> AnyPublisher<T?, Error> {
        Deferred { () -> PassthroughSubject<T?, Error> in
            let subject = PassthroughSubject<T?, Error>()
            Task {
                do {
                    let value = try await self.requestNetworkConnection()
                    subject.send(value)
                    subject.send(completion: .finished)
                } catch {
                    subject.send(completion: .failure(error))
                }
            }
            return subject
        }.eraseToAnyPublisher()
    }

    func requestNetworkConnection() async throws -> T {

        print("requestNetworkConnection url is \(cUrl)\nheader is \(String(describing: self.cHttpHeader))")

        let (resultData, response) = try await URLSession.shared.data(from: URL(string: self.cUrl)!)
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
