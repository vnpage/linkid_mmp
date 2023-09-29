//
//  AuthManager.swift
//  linkid_mmp
//
//  Created by Tuan Dinh on 22/02/2023.
//

import Foundation

class SessionManager {
    
    static var baseUrl: String = ""
    
    class func retry() {
        let partnerCode = StorageHelper.shared.getPartnerCode()
        let appSecret = StorageHelper.shared.getAppSecret()
        if(baseUrl == "") {
            baseUrl = StorageHelper.shared.getBaseUrl()
        }
        if partnerCode != "" && appSecret != "" {
            if(baseUrl == "" || !baseUrl.startWiths("http")) {
                auth(partnerCode: partnerCode, appSecret: appSecret)
            } else {
                authWithBaseUrl(partnerCode: partnerCode, appSecret: appSecret, baseUrl: baseUrl)
            }
        }
    }
    
    public class func sendSessionDeeplink() {
        DeepLinkHandler.initDeeplink()
        if(DeepLinkHandler.getLastDeepLink() != "" && !DeepLinkHandler.getLastDeepLink().isEmpty) {
            let data = ["deeplink": DeepLinkHandler.getLastDeepLink()]
            HttpClient.shared.post(with: "/partner/session-deeplink", params: data) { data, error in
                if let data = data {
                    do {
                        let dataStr = String(data: data, encoding: .utf8)
                        Logger.log(dataStr ?? "No data")
                    } catch let error {
                        Logger.log(error)
                    }
                }
            }
        }
    }
    
    public class func authWithBaseUrl(partnerCode: String, appSecret: String, baseUrl: String) {
        SessionManager.baseUrl = baseUrl
        let deviceId = DeviceInfo.getDeviceId()
        let appId = DeviceInfo.getAppId()
        let data = ["partnerCode": partnerCode, "appId": appId, "deviceId": deviceId, "deeplink": DeepLinkHandler.getLastDeepLink()]
        HttpClient.shared.post(with: "/public/partner/auth", params: data) { data, error in
            if let data = data {
                do {
                    let dataStr = String(data: data, encoding: .utf8)
                    Logger.log(dataStr ?? "Khong lay duoc du lieu")
                    let authData = try JSONDecoder().decode(AuthData.self, from: data)
                    if authData.responseCode == 200 {
                        Logger.log(authData.data?.token ?? "")
                        StorageHelper.shared.saveAuthData(data)
                        updateInfo(data: DeviceInfo.getDeviceInfo())
                        let is_first = StorageHelper.shared.getValue(forKey: "___first_open") ?? "0"
                        if is_first == "0" {
                            StorageHelper.shared.save("1", forKey: "___first_open")
                            TrackingEvent.trackEvent(name: "lid_mmp_first_open", data: [
                                "deeplink": DeepLinkHandler.getLastDeepLink(),
                            ])
                            DeepLinkHandler.getUDL()
                        } else {
                            sendSessionDeeplink()
                        }
                        TrackingEvent.trackEvent(name: "lid_mmp_start_session", data: [
                            "deeplink": DeepLinkHandler.getLastDeepLink(),
                        ])
                        DeepLinkHandler.saveDeeplink(deeplinkCountDate: authData.data?.deeplinkExpired ?? 0)
                        Crashlytics.check()
                    } else {
                        StorageHelper.shared.removeAuthData()
                    }
                } catch let error {
                    Logger.log(error)
                }
            }
        }
    }
    
    public class func auth(partnerCode: String, appSecret: String) {
        baseUrl = Common.decrypt(encrypted: appSecret, key: partnerCode)
        Logger.log("baseUrl \(baseUrl)")
        authWithBaseUrl(partnerCode: partnerCode, appSecret: appSecret, baseUrl: baseUrl)
        
    }
    
    public class func updateInfo(data: [String: Any]?) {
        HttpClient.shared.post(with: "/partner/device-info/update", params: data) { _data, _error in
            if let _data = _data {
//                do {
                    let dataStr = String(data: _data, encoding: .utf8)
                Logger.log(dataStr ?? "Khong lay duoc du lieu")
//                    let authData = try JSONDecoder().decode(AuthData.self, from: _data)
//                    if authData.responseCode == 200 {
//                        print(authData.data?.token ?? "")
//                        StorageHelper.shared.saveAuthData(_data)
//                    } else {
//                        StorageHelper.shared.removeAuthData()
//                    }
//                } catch {
//                    print(error)
//                }
            }
        }
    }
}
