//
//  WidgetSessionBean.swift
//  NetTest
//
//  Created by wooky83 on 2016. 10. 19..
//  Copyright © 2016년 wooky83. All rights reserved.
//

import Foundation

struct UsersBean: Codable {
    let id: Int
    let name: String
    let email: String?
    let address: AddressBean
    let phone: String?
    let website: String?
    let company: CompanyBean?
}

struct AddressBean: Codable {
    let street: String
    let suite: String
    let city: String?
    let zipcode: String
    let geo: GeoBean
}

struct GeoBean: Codable {
    let lat: String
    let lng: String
}

struct CompanyBean: Codable {
    let name: String
    let catchPhrase: String?
    let bs: String?
}
