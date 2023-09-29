//
//  DeepLinkAirflexParameters.swift
//  linkid_mmp
//
//  Created by Tuan Dinh on 28/09/2023.
//

import Foundation

public class DeepLinkAirflexParameters {
    public var name: String?
    public var source: String?
    public var code: String?
    public var medium: String?
    public var campaign: String?
    public var term: String?
    public var content: String?
    
    public init(source: String? = nil, code: String? = nil, medium: String? = nil, campaign: String? = nil) {
        self.source = source
        self.code = code
        self.medium = medium
        self.campaign = campaign
    }
    
    public func buildParams()-> [String: Any] {
        var params: [String: Any] = [:]
        if name != nil {
            params["name"] = name
        }
        if source != nil {
            params["utm_source"] = source
        }
        if medium != nil {
            params["utm_medium"] = medium
        }
        if campaign != nil {
            params["utm_campaign"] = campaign
        }
        if content != nil {
            params["utm_content"] = content
        }
        if term != nil {
            params["utm_term"] = term
        }
        if code != nil {
            params["code"] = code
        }
        return params
    }
}
