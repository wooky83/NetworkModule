//
//  NetRequest.swift
//  OCB5
//
//  Created by wooky83 on 2018. 9. 29..
//  Copyright © 2016년 skplanet. All rights reserved.
//

import Foundation
import PromiseKit
import Alamofire

struct NetRequest {
    
    // UserInfo를 가져오는 Test
    //
    // @url /todos/1
    // @method GET
    // @param (required) tmp1 testParameter
    // @param (required) tmp2 testParameter
    static func userInfo(_ param: [String: String]? = nil) -> Promise<UserInfoBean> {
        let task = NetworkTask<UserInfoBean>(method: .get, header: STNetworkUtil.getHttpheader(nil), parameter: param)
        return task.requestNetworkConnection(STNetworkUtil.serverURL() + STNetworkUtil.URL_SEARCH_USERS)
    }
    
    // iOS용 포인트 조회 API 제공
    //
    // @url /users
    // @method Get
    // @param(required) device_id 사용자 디바이스 ID
    // @param(required) widget_session 위젯 세션 ID
    static func testJson(_ param: [String: String]?) -> Promise<PersonBean> {
        let task = NetworkTask<PersonBean>(parameter: param)
        return task.requestNetworkConnection("http://localhost:8080/test")
    }
    
    // iOS용 포인트 조회 API 제공
    //
    // @url /users
    // @method Post
    // @param(required) device_id 사용자 디바이스 ID
    // @param(required) widget_session 위젯 세션 ID
    static func testPostJson(_ param: [String: String]?) -> Promise<PersonBean> {
        let task = NetworkTask<PersonBean>(method: .post, parameter: param)
        return task.requestNetworkConnection("http://localhost:8080/test")
    }
    
}
