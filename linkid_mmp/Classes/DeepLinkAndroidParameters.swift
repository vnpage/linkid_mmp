//
//  DeepLinkAndroidParameters.swift
//  linkid_mmp
//
//  Created by Tuan Dinh on 28/09/2023.
//

import Foundation

public class DeepLinkAndroidParameters {
    public var packageName: String?
    public var playStoreURL: String?
    public var customSchema: String?
    
    public init(packageName: String? = nil) {
        self.packageName = packageName
    }
    
    public func buildParams()-> [String: Any] {
        var params: [String: Any] = [:]
        if packageName != nil {
            params["package_name"] = packageName
            params["android_store"] = "https://play.google.com/store/apps/details?id=\(packageName!)"
        }
        if playStoreURL != nil && playStoreURL?.hasPrefix("http") == true && playStoreURL?.contains("play.google.com") == true {
            params["android_store"] = playStoreURL
        }
        if customSchema != nil {
            params["android_custom_protocol"] = customSchema
        }
        return params
    }
}
