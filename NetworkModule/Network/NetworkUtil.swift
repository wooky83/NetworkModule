//
//  ServerUtil.swift
//  NetTest
//
//  Created by wooky83 on 2016. 9. 30..
//  Copyright © 2016년 wooky83. All rights reserved.
//

import Foundation


enum NetworkUtil {
    
    enum Authorization: Equatable {
        case notRequired, required, dontCare
    }
    
    //Define URL Path
    static let URL_SEARCH_USERS = "search/users"
    
    //Define Header Name
    static let ACCEPT_LANGUAGE = "Accept-Language"
    static let CONTENT_TYPE = "Content-Type"
    static let AUTHORIZATION = "Authorization"
    static let RETRY = "retry"
    
    static func serverURL() -> String {
        return "https://api.github.com/"
    }
    
    static func getHttpheader(_ option: String? = nil) -> [String : String] {
        var header = [String : String]()
        header[ACCEPT_LANGUAGE] = "ko-KR;q=1, en-KR;q=0.9"
        header[CONTENT_TYPE] = "application/x-www-form-urlencoded; charset=utf-8"
        return header
    }
    
    static func getURLEncodeCharacterSet() -> CharacterSet {
        return CharacterSet(charactersIn: "!*'();:@&=+$,/?%#[] ").inverted
    }
    
    static var basicAuth: String {
        let username = "wooky"
        let password = "1234"
        let credentialData = "\(username):\(password)".data(using: .utf8)
        let base64Credentials = credentialData?.base64EncodedString(options: []) ?? ""
        return "Basic \(base64Credentials)"
    }
}

enum NetworkError: Error {
    case networkError
    case jsonDecodingError
    case typeCastingError
    case unKnownHttpError(status: Int)
    case serverError(MYServerError)
}

struct MYServerError: Decodable {
    let code: String
    let message: String
    let detailMessage: String
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

extension Encodable {
    func toJSONData() -> Data? {
        try? JSONEncoder().encode(self)
    }
}
