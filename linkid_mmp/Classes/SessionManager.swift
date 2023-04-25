//
//  AuthManager.swift
//  linkid_mmp
//
//  Created by Tuan Dinh on 22/02/2023.
//

import Foundation

class SessionManager {
    
    class func retry() {
        let partnerCode = StorageHelper.shared.getPartnerCode()
        if partnerCode != "" {
            auth(partnerCode: partnerCode)
        }
    }
    
    public class func auth(partnerCode: String) {
        let deviceId = DeviceInfo.getDeviceId()
        let appId = DeviceInfo.getAppId()
        let data = ["partnerCode": partnerCode, "appId": appId, "deviceId": deviceId]
        HttpClient.shared.post(with: "http://178.128.221.107:3001/public/partner/auth", params: data) { data, error in
            if let data = data {
                do {
                    let dataStr = String(data: data, encoding: .utf8)
                    print(dataStr ?? "Khong lay duoc du lieu")
                    let authData = try JSONDecoder().decode(AuthData.self, from: data)
                    if authData.responseCode == 200 {
                        print(authData.data?.token ?? "")
                        StorageHelper.shared.saveAuthData(data)
                        updateInfo(data: DeviceInfo.getDeviceInfo())
                    } else {
                        StorageHelper.shared.removeAuthData()
                    }
                } catch let error {
                    print(error)
                }
            }
        }
    }
    
    public class func updateInfo(data: [String: Any]?) {
        HttpClient.shared.post(with: "http://178.128.221.107:3001/partner/device-info/update", params: data) { _data, _error in
            if let _data = _data {
                do {
                    let dataStr = String(data: _data, encoding: .utf8)
                    print(dataStr ?? "Khong lay duoc du lieu")
//                    let authData = try JSONDecoder().decode(AuthData.self, from: _data)
//                    if authData.responseCode == 200 {
//                        print(authData.data?.token ?? "")
//                        StorageHelper.shared.saveAuthData(_data)
//                    } else {
//                        StorageHelper.shared.removeAuthData()
//                    }
                } catch let error {
                    print(error)
                }
            }
        }
    }
}
