//
//  AirflexAdHelper.swift
//  linkid_mmp
//
//  Created by Tuan Dinh on 13/3/25.
//

import Foundation

public class AirflexAdHelper {
    public static func showAd() {
        // Show ad
    }

    private static func parseAdItem(_ jsonString: String) -> AdItem? {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: Data(jsonString.utf8), options: []) as! [String: Any]

            // Parse adData
            guard let adDataArray = jsonObject["adData"] as? [String] else { return nil }
            let adData = adDataArray

            // Parse size
            guard let sizeObject = jsonObject["size"] as? [String: Int],
                  let width = sizeObject["width"],
                  let height = sizeObject["height"] else { return nil }
            let size = AdItem.AdSize(width: width, height: height)

            // Create and return AdItem
            return AdItem(adData: adData, size: size)
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }

    // Get ad data
    public static func getAd(adId: String, adType: String, callback: @escaping (AdItem?) -> Void) {
        // Get ad data using HttpClient request with params adId and adType
        HttpClient.shared.post(with: "/retail-media/sdk/a/list", params: ["ad_id": adId, "ad_type": adType]) { data, error in
            if error == nil, let _data = data, let response = String(data: _data, encoding: .utf8) {
                callback(parseAdItem(response))
            } else {
                callback(nil)
            }
        }
    }

    private static func trackingAd(adId: String, actionType: String, productId: String) {
        // Tracking ad
        HttpClient.shared.post(with: "/retail-media/sdk/a/tracking-action", params: ["ad_id": adId, "action": actionType, "product_id": productId]) { data, error in
            
        }
    }

    // Track ad impression
    public static func trackImpression(adId: String, productId: String = "") {
        // Track impression
        trackingAd(adId: adId, actionType: "IMPRESSION", productId: productId)
    }

    // Track ad click
    public static func trackClick(adId: String, productId: String = "") {
        // Track click
        trackingAd(adId: adId, actionType: "CLICK", productId: productId)
    }
}
