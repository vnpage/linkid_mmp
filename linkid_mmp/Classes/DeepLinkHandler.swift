//
//  DeepLinkHandler.swift
//  linkid_mmp
//
//  Created by Tuan Dinh on 17/04/2023.
//

import Foundation

public class DeepLinkHandler {
    private static var deepLink: String = ""
    private static var referalLink: String = ""
    
    public static func initDeeplink() {
        let currentTime = Int64(Date().timeIntervalSince1970)
        if(deepLink == "" && StorageHelper.shared.getDeeplinkExpireTime() - currentTime > 0) {
            deepLink = StorageHelper.shared.getDeeplink()
        } else {
            StorageHelper.shared.saveDeeplinkExpireTime(0)
            StorageHelper.shared.saveDeeplink("")
        }
        if(referalLink == "" && StorageHelper.shared.getDefferredDeeplinkExpireTime() - currentTime > 0) {
            referalLink =  StorageHelper.shared.getDeferredDeeplink()
        } else {
            StorageHelper.shared.saveDefferredDeeplinkExpireTime(0)
            StorageHelper.shared.saveDeferredDeeplink("")
        }
    }
    
    public static func saveDeeplink(deeplinkCountDate: Int64, deferredDeeplinkCountDate: Int64) {
        let savedDefferedDeeplink = StorageHelper.shared.getDeferredDeeplink()
        let savedDeeplink = StorageHelper.shared.getDeeplink()
        
        let currentTime = Int64(Date().timeIntervalSince1970)
        
        if(deeplinkCountDate > 0 && (StorageHelper.shared.getDeeplinkExpireTime()==0 || savedDeeplink != deepLink)) {
            StorageHelper.shared.saveDeeplink(deepLink)
            StorageHelper.shared.saveDeeplinkExpireTime(Int64(deeplinkCountDate*24*60*60)+currentTime)
        }
        if(deferredDeeplinkCountDate > 0 && (StorageHelper.shared.getDefferredDeeplinkExpireTime()==0 || savedDefferedDeeplink != referalLink)) {
            StorageHelper.shared.saveDeferredDeeplink(referalLink)
        }
    }
    
    public static func setDeepLink(url: String) {
        deepLink = url
        if(deepLink != "") {
            StorageHelper.shared.saveDeeplink(deepLink)
            LinkIdMMP.logEvent(name: "lid_mmp_deeplink", data: ["deeplink": deepLink])
            SessionManager.retry()
        }
    }
    
    public static func setDeferredDeepLink(url: String) {
        referalLink = url
        if(referalLink != "") {
            StorageHelper.shared.saveDeferredDeeplink(referalLink)
            LinkIdMMP.logEvent(name: "lid_mmp_deeplink", data: ["deferred_deeplink": referalLink])
            SessionManager.retry()
        }
    }
    
    public static func getDeepLink() -> String {
        return deepLink
    }
    
    public static func getDeferredDeepLink() -> String {
        return referalLink
    }
    
    private func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if let url = launchOptions?[UIApplication.LaunchOptionsKey.url] as? URL {
            DeepLinkHandler.deepLink = url.absoluteString
        }
        return true
    }

    public func application(_ application: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        DeepLinkHandler.deepLink = url.absoluteString
        return true
    }

    private func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
            if let url = userActivity.webpageURL, let deepLinkString = url.absoluteString.removingPercentEncoding {
                // Navigate to the appropriate content within your app based on the deep link
                DeepLinkHandler.referalLink = deepLinkString
                return true
            }
        }
        return false
    }
}
