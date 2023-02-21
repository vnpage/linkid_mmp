//
//  StorageHelper.swift
//  linkid_mmp
//
//  Created by Tuan Dinh on 31/01/2023.
//

import Foundation
import KeychainSwift

class StorageHelper {
    
    static let shared = StorageHelper()
    
    private let keychain = KeychainSwift()

    func save(_ value: String, forKey key: String) {
        keychain.set(value, forKey: key)
    }
    
    func getValue(forKey key: String) -> String? {
        return keychain.get(key)
    }
    
    func deleteValue(forKey key: String) {
        keychain.delete(key)
    }
    
    func saveLastEventTime(_ time: Int64) {
        save("\(time)", forKey: "MMP_LastEventTime")
    }
    
    func getLastEventTime() -> Int64 {
        var time = getValue(forKey: "MMP_LastEventTime")
        return Int64(time ?? "0") ?? 0
    }
    
    func saveExpireTime(_ expireTime: Int64) {
        save("\(expireTime)", forKey: "MMP_SessionExpireTimeInSeconds")
    }
    
    func getExpireTime() -> Int64 {
        var expireTime = getValue(forKey: "MMP_SessionExpireTimeInSeconds")
        return Int64(expireTime ?? "0") ?? 0
    }
    
    func saveAppId(_ appId: String) {
        save(appId, forKey: "MMP_AppId")
    }
    
    func getAppId() -> String {
        var appId = getValue(forKey: "MMP_AppId")
        return appId ?? ""
    }
    
    func savePartnerCode(_ code: String) {
        save(code, forKey: "MMP_PartnerCode")
    }
    
    func getPartnerCode() -> String {
        var code = getValue(forKey: "MMP_PartnerCode")
        return code ?? ""
    }
    
    func getDeviceId() -> String {
        var deviceId = StorageHelper.shared.getValue(forKey: "MMP_DeviceId")
        if deviceId == nil || deviceId == "" {
            deviceId = generateDeviceID()
            StorageHelper.shared.save(deviceId!, forKey: "MMP_DeviceId")
        }
        return deviceId!
    }
    
    private func generateDeviceID() -> String {
        let deviceID = UIDevice.current.identifierForVendor?.uuidString ?? ""
        return deviceID
    }
    
    func saveAuthData(_ data: Data) {
        keychain.set(data, forKey: "MMP_AuthData")
    }
    
    func removeAuthData() {
        deleteValue(forKey: "MMP_AuthData")
    }
    
    func getAuthData() -> AuthData? {
        if let data = keychain.getData("MMP_AuthData") {
            do {
                let authData = try JSONDecoder().decode(AuthData.self, from: data)
                return authData
            } catch {
                
            }
        }
        return nil
    }
}
