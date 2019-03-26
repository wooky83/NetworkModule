//
//  NetworkTask.swift
//  OCB5
//
//  Created by wooky83 on 2016. 9. 29..
//  Copyright © 2016년 skplanet. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit

class NetworkTask<T: Decodable>: NSObject {

    private var cHttpMethod = HTTPMethod.get
    private var cHttpHeader: [String: String]?
    private var cParameter: [String: String]?
    
    // MARK: - NetworkTask Init
    
    /// Creates a `NetworkTask` using the default `SessionManager` to retrieve the contents of the specified `url`,
    /// `method`, `parameters`, `encoding` and `headers`.
    ///
    /// - parameter method:     The HTTP method. `.get` by default.
    /// - parameter parameters: The parameters. `nil` by default.
    /// - parameter headers:    The HTTP headers. `nil` by default.
    ///
    /// - returns: Void.
    init(method: HTTPMethod = .get, header: [String: String]? = nil, parameter: [String: String]? = nil) {
        self.cHttpMethod = method
        self.cHttpHeader = header ?? STNetworkUtil.getHttpheader(nil)
        self.cParameter = parameter
    }
    
    private func configureKey() {
        //TODO
    }

    // MARK: - Data Request
    
    /// Creates a `DataRequest` using the default `Alamofire` to retrieve the contents of the specified `url`,
    ///
    /// - parameter url:        The URL.
    ///
    /// - returns: The created `Promise<T>`.
    func requestNetworkConnection(_ url: String) -> Promise<T> {
    
        print("requestNetworkConnection")
        
        return Promise { seal in
            
            Alamofire.request(url, method: self.cHttpMethod, parameters: self.cParameter, headers: self.cHttpHeader)
                .validate()
                .response { res in
                    guard let response = res.response, let responseData = res.data else { return seal.reject(NetworkError.networkError) }
                    print("[🍎🍊]response:\(response)")
                    guard 200 ..< 300 ~= response.statusCode else { return seal.reject(NetworkError.httpError(status: response.statusCode)) }
                  
                    let resultData = responseData
                    
                    print("[😝😜🤪] JsonResult : \(String(describing: String(data: resultData, encoding: .utf8)))")
                    do {
                        let decodingHelper = try JSONDecoder().decode(DecodingHelper.self, from: resultData)
                        let decodedJson = try decodingHelper.decode(to: T.self)
                        if let json = decodedJson as? T {
                            seal.fulfill(json)
                        } else {
                            seal.reject(NetworkError.networkError)
                        }
                    } catch let error as NSError {
                        print("ParsingError : \(error)")
                        seal.reject(NetworkError.jsonDecodingError)
                    }
            }
        }
    }
    
    deinit {
        print("networkTask Dealloc")
    }
    
}

enum NetworkError: Error {
    case networkError
    case jsonDecodingError
    case httpError(status: Int)
}

struct DecodingHelper: Decodable {
    private let decoder: Decoder
    
    init(from decoder: Decoder) throws {
        self.decoder = decoder
    }
    
    func decode(to type: Decodable.Type) throws -> Decodable {
        let decodable = try type.init(from: decoder)
        return decodable
    }
}
