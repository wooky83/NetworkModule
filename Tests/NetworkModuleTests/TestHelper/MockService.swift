import Foundation
import Combine
import PromiseKit
import RxAlamofire
import RxSwift
@testable import AlamofireNetwork
@testable import URLSessionNetwork
@testable import RxNetwork

struct MockService {

    public static func jsonplaceholderUser(_ param: [String: String]? = nil) -> AnyPublisher<PostModel, Error> {
        URLSessionNetwork.Remote<PostModel>(url: "http://localhost:1234/api/v2/users", parameter: param)
            .asPublisher()
    }

    public static func jsonplaceholderUserFail() -> AnyPublisher<FailModel, Error> {
        URLSessionNetwork.Remote<FailModel>(url: "http://localhost:1234/api/v2/users")
            .asPublisher()
    }

    public static func jsonplaceholderUser(_ param: [String: String]? = nil) -> Promise<PostModel> {
        NetworkTask<PostModel>(parameter: param).requestNetworkConnection("http://localhost:1234/api/v2/users")
    }

    public static func rxAlamofireSuccess() -> Observable<PostModel> {
        RxNetwork.Remote<PostModel>(url: "http://localhost:1234/api/v2/users").asObservable()
    }

}

struct PostModel: Codable {
    let hello: String
}

struct FailModel: Codable {
    let world: String
}
