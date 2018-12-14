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
    
    init(method: HTTPMethod = .get, header: [String: String]? = nil, parameter: [String: String]? = nil) {
        self.cHttpMethod = method
        self.cHttpHeader = header
        self.cParameter = parameter
    }
    
    private func configureKey() {
        //TODO
    }

    func requestNetworkConnection(_ url: String) -> Promise<T> {
    
        print("requestNetworkConnection")
        return Promise { seal in
            
            Alamofire.request(STNetworkUtil.serverURL() + url, method: self.cHttpMethod, parameters: self.cParameter, headers: self.cHttpHeader)
                .validate()
                .response { res in
                    guard let response = res.response, let responseData = res.data else { return seal.reject(NetworkError.networkError) }
                    print("[🍎🍊]response:\(response)")
                    guard 200 ..< 300 ~= response.statusCode else { return seal.reject(NetworkError.httpError(status: response.statusCode))}
                  
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
                        seal.reject(NetworkError.networkError)
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
