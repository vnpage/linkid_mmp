//
//  DeeplinkBuilder.swift
//  linkid_mmp
//
//  Created by Tuan Dinh on 28/09/2023.
//

import Foundation

public class DeepLinkBuilder {
    public var iOSParameters: DeepLinkIOSParameters?
    public var androidParameters: DeepLinkAndroidParameters?
    public var airflexParameters: DeepLinkAirflexParameters?
    
    public init() {
    }
    
    func buildParams() -> [String: Any] {
        var params: [String: Any] = [:]
        var fields: [String: Any] = [:]
        if(iOSParameters != nil) {
//            fields += iOSParameters!.buildParams()
            fields.merged(with: iOSParameters!.buildParams())
        }
        if(androidParameters != nil) {
//            fields += androidParameters!.buildParams()
            fields.merged(with: androidParameters!.buildParams())
        }
        if(airflexParameters != nil) {
//            fields += airflexParameters!.buildParams()
            fields.merged(with: airflexParameters!.buildParams())
        }
        
        var _fields: [[String:Any]] = []
        fields.forEach({ (key: String, value: Any) in
            _fields.append(["key": key, "value": value])
        })
        
        params["fields"] = _fields
        
        return params
    }
    
    public func createLink( with params: [String: Any], completion: @escaping (DeepLinkBuilderResult?, DeepLinkBuilderError?) -> Void) {
        HttpClient.shared.post(with: "/partner/deeplink/create", params: params) { _data, _error in
            if let data = _data {
                do {
                    let dataStr = String(data: data, encoding: .utf8)
                    let result = try JSONDecoder().decode(ResultData.self, from: data)
                    if result.responseCode >= 200 && result.responseCode < 299 {
                        let deeplinkResult = try JSONDecoder().decode(DeepLinkResultData.self, from: data)
                        if let deeplink = deeplinkResult.data {
                            completion(DeepLinkBuilderResult(shortLink: deeplink.short_link, longLink: deeplink.long_link, qrLink: deeplink.qr_link), nil)
                        } else {
                            completion(nil, DeepLinkBuilderError(code: "0", message: "data is null"))
                        }
                    } else {
                        completion(nil, DeepLinkBuilderError(code: "\(result.responseCode)", message: "\(result.responseText)"))
                        
                    }
                } catch {
                    completion(nil, DeepLinkBuilderError(code: "0", message: "\(error.localizedDescription)"))
                }
            } else {
                completion(nil, DeepLinkBuilderError(code: "0", message: "\(String(describing: _error?.localizedDescription))"))
            }
        }
    }
    
    public func createLink(completion: @escaping (DeepLinkBuilderResult?, DeepLinkBuilderError?) -> Void) {
        let params = buildParams()
        createLink(with: params, completion: completion)
    }
    
    public func createShortLink(longLink: String, name: String = "", shortLinkId: String = "", completion: @escaping (DeepLinkBuilderResult?, DeepLinkBuilderError?) -> Void) {
        let params = [
            "name" : name,
            "short_link_id" : shortLinkId,
            "redirect_url" : longLink
        ]
        HttpClient.shared.post(with: "/partner/deeplink/shorten-link", params: params) { _data, _error in
            if let data = _data {
                do {
                    let result = try JSONDecoder().decode(ResultData.self, from: data)
                    if result.responseCode >= 200 && result.responseCode < 299 {
                        let deeplinkResult = try JSONDecoder().decode(DeepLinkResultData.self, from: data)
                        if let deeplink = deeplinkResult.data {
                            completion(DeepLinkBuilderResult(shortLink: deeplink.short_link, longLink: deeplink.long_link, qrLink: deeplink.qr_link), nil)
                        } else {
                            completion(nil, DeepLinkBuilderError(code: "0", message: "data is null"))
                        }
                    } else {
                        completion(nil, DeepLinkBuilderError(code: "\(result.responseCode)", message: "\(result.responseText)"))
                        
                    }
                } catch {
                    completion(nil, DeepLinkBuilderError(code: "0", message: "\(error.localizedDescription)"))
                }
            } else {
                completion(nil, DeepLinkBuilderError(code: "0", message: "\(String(describing: _error?.localizedDescription))"))
            }
        }
    }
}
