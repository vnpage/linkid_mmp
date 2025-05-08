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
    
    private func handleDeeplink(url: String) {
        if(url != "" && deeplink != url) {
            deeplink = url
            checkDeepLink()
        }
    }
    
    public func handleUniversalLink(incomingURL: String, completion: @escaping (_ redirectUrl: String?, _ longLink: String?, _ error: String?) -> Void) {
        if(incomingURL != "" && deeplink != incomingURL && incomingURL.startsWith("http")    ) {
            let parameters: [String: Any] = [
                "short_link" : incomingURL
            ]
            HttpClient.shared.post(with: "/partner/deeplink/get-full-link-from-short-link", params: parameters) { data, error in
                if error != nil {
                    completion(incomingURL, incomingURL, nil)
                    self.handleDeeplink(url: incomingURL)
                    return
                } else {
                    if let data = data {
                        do {
                            let json = try JSONSerialization.jsonObject(with: data, options: [])
                            guard let result = json as? [String: Any], let dictionary = result["data"] as? [String: Any] else {
                                completion(incomingURL, incomingURL, nil)
                                self.handleDeeplink(url: incomingURL)
                                return
                            }
                            let longLink: String? = dictionary["longLink"] as? String
                            let redirectUrl: String? = dictionary["redirectUrl"] as? String
                            if(longLink != "") {
                                self.handleDeeplink(url: longLink ?? incomingURL)
                                completion(redirectUrl, longLink, nil)
                            } else {
                                self.handleDeeplink(url: incomingURL)
                                completion(incomingURL, incomingURL, nil)
                            }
                        } catch {
                            self.handleDeeplink(url: incomingURL)
                            completion(incomingURL, incomingURL, nil)
                        }
                    }
                }
            }
        } else {
            self.handleDeeplink(url: incomingURL)
            completion(incomingURL, incomingURL, nil)
        }
    }
}
