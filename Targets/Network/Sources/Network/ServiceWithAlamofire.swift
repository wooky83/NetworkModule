import Foundation
import NetworkAlamofire
import PromiseKit


public struct HomeService {

    // jsonplaceholder Test API 제공
    //
    // @url /posts
    // @method GET
    public static func jsonplaceholderUser(_ param: [String: String]? = nil) -> Promise<PostModel> {
        NetworkTask<PostModel>(parameter: param).requestNetworkConnection("https://jsonplaceholder.typicode.com/posts/1")
    }

}
