//
//  DeepLinkHandler.swift
//  linkid_mmp
//
//  Created by Tuan Dinh on 17/04/2023.
//

import Foundation

public typealias HandleDeeplink = (String) -> Void

@objcMembers
public class DeepLinkHandler {
    private static var lastDeepLink: String = ""
    private static var currentDeepLink: String = ""
    public static var handleDeeplink: HandleDeeplink?
    
    internal static var deviceIdentifier: String? {
        get {
            let device = UIDevice.current.model
            return "\(device)".lowercased()
        }
    }
    
    internal static var osVersion: String? {
        get {
            let osVersion = UIDevice.current.systemVersion
            return "\(osVersion)".lowercased()
        }
    }
    
    internal static var osName: String? {
        get {
            let osName = UIDevice.current.systemName
            return "\(osName)".lowercased()
        }
    }
    
    internal static var ipAddress: String? {
        get {
            return DeviceInfo.getIPAddress(for: Network.wifi) ?? DeviceInfo.getIPAddress(for: Network.cellular)
        }
    }
    
    public static func initDeeplink() {
        let currentTime = Int64(Date().timeIntervalSince1970)
        if(lastDeepLink == "" && StorageHelper.shared.getDeeplinkExpireTime() - currentTime > 0) {
            lastDeepLink = StorageHelper.shared.getDeeplink()
        } else {
            StorageHelper.shared.saveDeeplinkExpireTime(0)
            StorageHelper.shared.saveDeeplink("")
        }
    }
    
    public static func saveDeeplink(deeplinkCountDate: Int64) {
        let savedDeeplink = StorageHelper.shared.getDeeplink()
        let currentTime = Int64(Date().timeIntervalSince1970)

        if(deeplinkCountDate > 0 && (StorageHelper.shared.getDeeplinkExpireTime()==0 || savedDeeplink != lastDeepLink)) {
            StorageHelper.shared.saveDeeplink(lastDeepLink)
            StorageHelper.shared.saveDeeplinkExpireTime(Int64(deeplinkCountDate*24*60*60)+currentTime)
        }
    }
    
    public static func setDeepLink(url: String) {
        lastDeepLink = url
        currentDeepLink = url
        if(lastDeepLink != "") {
            StorageHelper.shared.saveDeeplink(lastDeepLink)
//            Airflex.logEvent(name: "lid_mmp_deeplink", data: ["deeplink": lastDeepLink])
//            SessionManager.retry()
        }
    }
    
    public static func getLastDeepLink() -> String {
        return lastDeepLink
    }
    
    public static func getCurrentDeepLink() -> String {
        return currentDeepLink
    }
    
//    private func application(_ application: UIApplication,
//                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        if let url = launchOptions?[UIApplication.LaunchOptionsKey.url] as? URL {
//            DeepLinkHandler.lastDeepLink = url.absoluteString
//            DeepLinkHandler.currentDeepLink = url.absoluteString
//        }
//        return true
//    }
//
//    public func application(_ application: UIApplication,
//                     open url: URL,
//                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
//        DeepLinkHandler.lastDeepLink = url.absoluteString
//        DeepLinkHandler.currentDeepLink = url.absoluteString
//        return true
//    }
//
//    private func application(_ application: UIApplication,
//                     continue userActivity: NSUserActivity,
//                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
//        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
//            if let url = userActivity.webpageURL, let deepLinkString = url.absoluteString.removingPercentEncoding {
//                // Navigate to the appropriate content within your app based on the deep link
//                DeepLinkHandler.lastDeepLink = deepLinkString
//                DeepLinkHandler.currentDeepLink = url.absoluteString
//                return true
//            }
//        }
//        return false
//    }
    
    
    public static func getUDL() {
        var data: [String: Any] = [:]
        data["platform"] = deviceIdentifier
        data["ip_address"] = ipAddress
        data["version"] = osVersion
        data["os"] = osName
        
        HttpClient.shared.post(with: "/partner/unified-deeplink/verify", params: data as [String : Any]) { _data, _error in
            if let _data = _data {
                do {
                    let str = String(data: _data, encoding: .utf8)
                    Logger.log("/partner/unified-deeplink/verify: \(str ?? "No data")")
                    if let jsonDictionary = try JSONSerialization.jsonObject(with: _data, options: []) as? [String: Any], let linkData = jsonDictionary["data"] as? [String:Any] {
                        if let link = linkData["deeplink"] as? String {
                            lastDeepLink = link
                            currentDeepLink = link
                        }
                    } else {
                        Logger.log("/partner/unified-deeplink/verify: Failed to convert JSON data to dictionary.")
                    }
                    if(handleDeeplink != nil && currentDeepLink != "") {
                        handleDeeplink!(currentDeepLink)
                        SessionManager.sendSessionDeeplink()
                    }
                } catch {
                    Logger.log("/partner/unified-deeplink/verify: \(error)")
                }
            }
        }
    }
}
