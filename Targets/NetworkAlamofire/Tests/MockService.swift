import Foundation
import PromiseKit
@testable import NetworkAlamofire

struct MockService {
    public static func jsonplaceholderUser(_ param: [String: String]? = nil) -> Promise<PostModel> {
        NetworkTask<PostModel>(parameter: param).requestNetworkConnection("http://localhost:1234/api/v2/users")
    }
}

struct PostModel: Codable {
    let hello: String
}

