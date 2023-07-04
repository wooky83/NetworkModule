import Foundation
import PromiseKit
import Alamofire

public struct NetRequest<T: Decodable> {

    // jsonplaceholder Test API 제공
    //
    // @url /posts
    // @method GET
    public static func jsonplaceholderUser(_ param: [String: String]? = nil) -> Promise<T> {
        let task = NetworkTask<T>(parameter: param)
        return task.requestNetworkConnection("https://jsonplaceholder.typicode.com/posts/1")
    }
    
}
