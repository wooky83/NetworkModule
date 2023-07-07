import Foundation
import NetworkURLSession
import Combine

struct MainService {
    public static func jsonplaceholderUser(_ param: [String: String]? = nil) -> AnyPublisher<PostModel, Error> {
        Remote<PostModel>(url: "https://jsonplaceholder.typicode.com/posts/1", parameter: param)
            .asUnwrapPublisher()
    }
}

