//
//  AirflexDeepLinkDelegate.swift
//  linkid_mmp
//
//  Created by Tuan Dinh on 02/10/2023.
//

import Foundation

public class AirflexDeepLinkDelegate: UIResponder, UIApplicationDelegate {
    
    public static let shared = AirflexDeepLinkDelegate()
    
    var deeplink = ""
    
    func checkDeepLink() {
        if(deeplink != "") {
            DeepLinkHandler.setDeepLink(url: deeplink)
            DeepLinkHandler.handleDeeplink?(deeplink)
        }
    }
    
    private func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if let url = launchOptions?[UIApplication.LaunchOptionsKey.url] as? URL {
            handleDeeplink(url: url.absoluteString)
        }
        return true
    }

    public func application(_ application: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        handleDeeplink(url: url.absoluteString)
        return true
    }
    
    private func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb, let url = userActivity.webpageURL {
            handleDeeplink(url: url.absoluteString)
        }
        return true
    }

    private func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb, let url = userActivity.webpageURL {
            handleDeeplink(url: url.absoluteString)
        }
        return true
    }
    
    public func handleDeeplink(url: String) {
        if(url != "" && deeplink != url) {
            deeplink = url
            checkDeepLink()
        }
    }
}
