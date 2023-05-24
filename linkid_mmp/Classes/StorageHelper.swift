//
//  StorageHelper.swift
//  linkid_mmp
//
//  Created by Tuan Dinh on 31/01/2023.
//

import Foundation
//import KeychainSwift

@objcMembers
class StorageHelper {
    
    static let shared = StorageHelper()
    
//    private let keychain = KeychainSwift()

    func save(_ value: String, forKey key: String) {
//            keychain.set(value, forKey: key)
        UserDefaults.standard.set(value, forKey: key)
    }
    
    func getValue(forKey key: String) -> String? {
//        return keychain.get(key)
        return UserDefaults.standard.string(forKey: key)
    }
    
    func deleteValue(forKey key: String) {
//        keychain.delete(key)
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    func saveLastEventTime(_ time: Int64) {
        save("\(time)", forKey: "MMP_LastEventTime")
    }
    
    func getLastEventTime() -> Int64 {
        let time = getValue(forKey: "MMP_LastEventTime")
        return Int64(time ?? "0") ?? 0
    }
    
    func saveExpireTime(_ expireTime: Int64) {
        save("\(expireTime)", forKey: "MMP_SessionExpireTimeInSeconds")
    }
    
    func getExpireTime() -> Int64 {
        let expireTime = getValue(forKey: "MMP_SessionExpireTimeInSeconds")
        return Int64(expireTime ?? "0") ?? 0
    }
    
    func saveDeeplinkExpireTime(_ expireTime: Int64) {
        save("\(expireTime)", forKey: "MMP_SessionExpireTimeInSeconds_Deeplink")
    }
    
    func getDeeplinkExpireTime() -> Int64 {
        let expireTime = getValue(forKey: "MMP_SessionExpireTimeInSeconds_Deeplink")
        return Int64(expireTime ?? "0") ?? 0
    }
    
    func saveDefferredDeeplinkExpireTime(_ expireTime: Int64) {
        save("\(expireTime)", forKey: "MMP_SessionExpireTimeInSeconds_DefferredDeeplink")
    }
    
    func getDefferredDeeplinkExpireTime() -> Int64 {
        let expireTime = getValue(forKey: "MMP_SessionExpireTimeInSeconds_DefferredDeeplink")
        return Int64(expireTime ?? "0") ?? 0
    }
    
    func saveDeeplink(_ data: String) {
        save(data, forKey: "MMP_Deeplink")
    }
    
    func getDeeplink() -> String {
        let data = getValue(forKey: "MMP_Deeplink")
        return data ?? ""
    }
    
    func saveDeferredDeeplink(_ data: String) {
        save(data, forKey: "MMP_DeferredDeeplink")
    }
    
    func getDeferredDeeplink() -> String {
        let data = getValue(forKey: "MMP_DeferredDeeplink")
        return data ?? ""
    }
    
    func saveBaseUrl(_ data: String) {
        save(data, forKey: "MMP_BaseUrl")
    }
    
    func getBaseUrl() -> String {
        let data = getValue(forKey: "MMP_BaseUrl")
        return data ?? ""
    }
    
    func savePartnerCode(_ code: String) {
        save(code, forKey: "MMP_PartnerCode")
    }
    
    func getPartnerCode() -> String {
        let code = getValue(forKey: "MMP_PartnerCode")
        return code ?? ""
    }
    
    func saveAppSecret(_ code: String) {
        save(code, forKey: "MMP_AppSecret")
    }
    
    func getAppSecret() -> String {
        let code = getValue(forKey: "MMP_AppSecret")
        return code ?? ""
    }
    
    func getDeviceId() -> String {
        var deviceId = getValue(forKey: "MMP_DeviceId")
        if deviceId == nil || deviceId == "" {
            deviceId = generateDeviceID()
            save(deviceId!, forKey: "MMP_DeviceId")
        }
        return deviceId!
    }
    
    private func generateDeviceID() -> String {
        let deviceID = UIDevice.current.identifierForVendor?.uuidString ?? ""
        return deviceID
    }
    
    func saveAuthData(_ data: Data) {
//        keychain.set(data, forKey: "MMP_AuthData")
        UserDefaults.standard.set(data, forKey: "MMP_AuthData")
    }
    
    func removeAuthData() {
        deleteValue(forKey: "MMP_AuthData")
    }
    
    func getAuthData() -> AuthData? {
//        if let data = keychain.getData("MMP_AuthData") {
//            do {
//                let authData = try JSONDecoder().decode(AuthData.self, from: data)
//                return authData
//            } catch {
//
//            }
//        }
        if let data = UserDefaults.standard.data(forKey: "MMP_AuthData") {
            do {
                let authData = try JSONDecoder().decode(AuthData.self, from: data)
                return authData
            } catch {
                
            }
        }
        return nil
    }
}
