import Foundation
import Combine
@testable import NetworkURLSession

struct MockService {
    public static func jsonplaceholderUser(_ param: [String: String]? = nil) -> AnyPublisher<PostModel, Error> {
        Remote<PostModel>(url: "http://localhost:1234/api/v2/users", parameter: param)
            .asUnwrapPublisher()
    }
}

struct PostModel: Codable {
    let hello: String
}
