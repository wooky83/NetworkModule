import Foundation
import Combine
import PromiseKit
@testable import NetworkModule

struct MockService {

    public static func jsonplaceholderUser(_ param: [String: String]? = nil) -> AnyPublisher<PostModel, Error> {
        Remote<PostModel>(url: "http://localhost:1234/api/v2/users", parameter: param)
            .asUnwrapPublisher()
    }

    public static func jsonplaceholderUser(_ param: [String: String]? = nil) -> Promise<PostModel> {
        NetworkTask<PostModel>(parameter: param).requestNetworkConnection("http://localhost:1234/api/v2/users")
    }
}

struct PostModel: Codable {
    let hello: String
}
