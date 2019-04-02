//
//  ServerUtil.swift
//  NetTest
//
//  Created by wooky83 on 2016. 9. 30..
//  Copyright © 2016년 wooky83. All rights reserved.
//

import Foundation


enum STNetworkUtil {
    
    enum Authorization: Equatable {
        case notRequired, required, dontCare
    }
    
    //Define URL Path
    static let URL_SEARCH_USERS = "search/users"
    
    //Define Header Name
    static let ACCEPT_LANGUAGE = "Accept-Language"
    static let CONTENT_TYPE = "Content-Type"
    static let AUTHORIZATION = "Authorization"
    
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
