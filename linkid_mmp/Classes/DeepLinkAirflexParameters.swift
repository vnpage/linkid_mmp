//
//  DeepLinkAirflexParameters.swift
//  linkid_mmp
//
//  Created by Tuan Dinh on 28/09/2023.
//

import Foundation

public class DeepLinkAirflexParameters {
    public var shortLinkId: String?
    public var name: String
    public var source: String?
    public var code: String?
    public var medium: String?
    public var campaign: String?
    public var term: String?
    public var content: String?
    public var redirectUrl: String?
    public var customParams: [String: Any] = [:]
    
    public init(name: String, source: String? = nil, code: String? = nil, medium: String? = nil, campaign: String? = nil, redirectUrl: String? = nil) {
        self.name = name
        self.source = source
        self.code = code
        self.medium = medium
        self.campaign = campaign
        self.redirectUrl = redirectUrl
    }
    
    public func addCustomParam(key: String, value: Any) {
        customParams[key] = value
    }
    
    public func addCustomParams(params: [String: Any]) {
        customParams.merged(with: params)
    }
    
    public func buildParams()-> [String: Any] {
        var params: [String: Any] = [:]
        params.merged(with: customParams)
        
        if shortLinkId != nil {
            params["short_link_id"] = shortLinkId
        }
        params["name"] = name
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
        if redirectUrl != nil {
            params["redirect_url"] = redirectUrl
        }
        return params
    }
}
