import Foundation
import Combine

public struct NetRequest<T: Decodable> {

    // jsonplaceholder Test API 제공
    //
    // @url /posts
    // @method GET
    public static func jsonplaceholderUser(_ param: [String: String]? = nil) -> AnyPublisher<T?, Error> {
        NetworkTask<T>(url: "https://jsonplaceholder.typicode.com/posts/1", parameter: param)
            .asPublisher()
    }
    
}
