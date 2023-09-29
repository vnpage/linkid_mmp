//
//  DeepLinkIOSParameters.swift
//  linkid_mmp
//
//  Created by Tuan Dinh on 28/09/2023.
//

import Foundation

public class DeepLinkIOSParameters {
    public var bundleID: String?
    public var appStoreID: String?
    public var customSchema: String?
    public var appStoreURL: String?
    
    public init(bundleID: String? = nil, appStoreID: String? = nil) {
        self.bundleID = bundleID
        self.appStoreID = appStoreID
    }
    
    public func buildParams()-> [String: Any] {
        var params: [String: Any] = [:]
        if bundleID != nil {
            params["bundle_id"] = bundleID
        }
        if appStoreID != nil {
            params["appstore_id"] = appStoreID
            params["ios_store"] = "https://apps.apple.com/app/id\(appStoreID!)?mt=8"
        }
        if appStoreURL != nil && appStoreURL?.hasPrefix("http") == true && appStoreURL?.contains("apps.apple.com") == true {
            params["ios_store"] = appStoreURL
        }
        if customSchema != nil {
            params["ios_custom_protocol"] = customSchema
        }
        return params
    }
}
