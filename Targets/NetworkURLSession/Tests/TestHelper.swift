import Foundation
import Combine
@testable import NetworkURLSession

struct MockService {
    public static func jsonplaceholderUser(_ param: [String: String]? = nil) -> AnyPublisher<PostModel, Error> {
        Remote<PostModel>(url: "https://jsonplaceholder.typicode.com/posts/1", parameter: param)
            .asUnwrapPublisher()
    }
}

struct PostModel: Codable {
    let userId: Int
}
