//
//  WidgetPointSummaryBean.swift
//  NetTest
//
//  Created by wooky83 on 2016. 10. 19..
//  Copyright © 2016년 wooky83. All rights reserved.
//

import Foundation

struct UserInfoBean: Codable {
    let total_count: Int
    let incomplete_results: Bool
    let items: [ItemsBean]
}

struct ItemsBean: Codable {
    let login: String
    let id: Int
    let url: String
    let repos_url: String
}

struct PersonBean: Codable {
    let name: String
    let age: Int
}

struct CommonBean: Codable {
    let message: String?
}
