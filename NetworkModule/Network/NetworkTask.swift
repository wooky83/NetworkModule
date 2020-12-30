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
    private var cHttpHeader: HTTPHeaders?
    private var cParameter: [String: String]?
    var isAuthorization = NetworkUtil.Authorization.dontCare {
        didSet {
            if isAuthorization == .required {
                cHttpHeader?[NetworkUtil.AUTHORIZATION] = NetworkUtil.basicAuth
            }
        }
    }
    
    // MARK: - NetworkTask Init
    
    /// Creates a `NetworkTask` using the default `SessionManager` to retrieve the contents of the specified `url`,
    /// `method`, `parameters`, `encoding` and `headers`.
    ///
    /// - parameter method:     The HTTP method. `.get` by default.
    /// - parameter parameters: The parameters. `nil` by default.
    /// - parameter headers:    The HTTP headers. `nil` by default.
    ///
    /// - returns: Void.
    init(method: HTTPMethod = .get, parameter: [String: String]? = nil, header: [String: String]? = nil) {
        self.cHttpMethod = method
        let mHeader = header ?? NetworkUtil.getHttpheader()
        self.cHttpHeader = HTTPHeaders(mHeader)
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
    
        print("requestNetworkConnection url is \(url)\nheader is \(String(describing: self.cHttpHeader))")
        
        return Promise { seal in
            AF.request(url, method: self.cHttpMethod, parameters: self.cParameter, headers: self.cHttpHeader)
                .validate()
                .response { res in
                    guard let response = res.response, let responseData = res.data else {
                        return seal.reject(NetworkError.networkError)
                    }
                    print("[🍎🍊]response:\(response)")
                    if 200 ..< 300 ~= response.statusCode {
                        let resultData = responseData
                        print("[😝😜🤪] JsonResult : \(String(describing: String(data: resultData, encoding: .utf8)))")
                        do {
                            let decodingHelper = try JSONDecoder().decode(DecodingHelper.self, from: resultData)
                            let decodedJson = try decodingHelper.decode(to: T.self)
                            if let json = decodedJson as? T {
                                seal.fulfill(json)
                            } else {
                                seal.reject(NetworkError.typeCastingError)
                            }
                        } catch let error as NSError {
                            print("ParsingError : \(error)")
                            seal.reject(NetworkError.jsonDecodingError)
                        }
                    } else if let myServerError = try? JSONDecoder().decode(MYServerError.self, from: responseData) {
                        if myServerError.code == NetworkUtil.RETRY {
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(3 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
                                self.requestNetworkConnection(url)
                                    .pipe(to: {
                                        seal.resolve($0)
                                    })
                            }
                        } else {
                            seal.reject(NetworkError.serverError(myServerError))
                        }
                    } else {
                        seal.reject(NetworkError.unKnownHttpError(status: response.statusCode))
                    }
                    
                }
        }
    }
    
    deinit {
        print("networkTask Dealloc")
    }
    
}
