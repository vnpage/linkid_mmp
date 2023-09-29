//
//  AuthData.swift
//  linkid_mmp
//
//  Created by Tuan Dinh on 31/01/2023.
//

import Foundation

struct AuthData: Decodable {
    let responseCode: Int
    let responseText: String
    let data: SessionData?
}

struct SessionData: Decodable {
    let sessionId: String
    let token: String
    let sessionExpireTimeInSeconds: Int64
    let deeplinkExpired: Int64?
    let deferredDeeplinkExpired: Int64?
}

struct ResultData: Decodable {
    let responseCode: Int
    let responseText: String
}

struct DeepLinkResultData: Decodable {
    let responseCode: Int
    let responseText: String
    let data: DeepLinkData?
}

struct DeepLinkData: Decodable {
    let short_link: String
    let long_link: String
}
