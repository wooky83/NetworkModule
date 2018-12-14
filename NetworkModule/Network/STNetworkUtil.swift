//
//  ServerUtil.swift
//  NetTest
//
//  Created by wooky83 on 2016. 9. 30..
//  Copyright © 2016년 wooky83. All rights reserved.
//

import Foundation

enum STNetworkUtil {
    
    //Define URL Path
    static let URL_TODO1 = "todos/1"
    static let URL_USERS = "users/1"
    
    //Define Header Name
    static let ACCEPT_LANGUAGE = "Accept-Language"
    static let CONTENT_TYPE = "Content-Type"
    
    static func serverURL() -> String {
        return "https://jsonplaceholder.typicode.com/"
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
}
