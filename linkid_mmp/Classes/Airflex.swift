import Foundation

@objcMembers
public class Airflex {

    static public func logEvent(name: String, data: [String: Any]?) {
        TrackingEvent.trackEvent(name: name, data: data)
    }
    
//    static public func setDevMode(_ devMode: Bool) {
//        Logger.setDevMode(devMode)
//    }

    static public func intSDK(partnerCode: String, appSecret: String, options: AirflexOptions?) {
        if partnerCode != "" {
            if options != nil {
                Logger.setDevMode(options!.showLog)
                if options!.autoTrackingScreen {
                    ScreenChangeObserver().startObserving()
                }
            }
            StorageHelper.shared.savePartnerCode(partnerCode)
            StorageHelper.shared.saveAppSecret(appSecret)
            SessionManager.auth(partnerCode: partnerCode, appSecret: appSecret)
        }
        Crashlytics.setup()
    }
    
    static public func intSDK(partnerCode: String, appSecret: String) {
        intSDK(partnerCode: partnerCode, appSecret: appSecret, options: AirflexOptions())
    }
    
//    static public func intSDKWithBaseUrl(partnerCode: String, appSecret: String, baseUrl: String) {
//        if partnerCode != "" {
//            StorageHelper.shared.savePartnerCode(partnerCode)
//            StorageHelper.shared.saveAppSecret(appSecret)
//            StorageHelper.shared.saveBaseUrl(baseUrl)
//            SessionManager.authWithBaseUrl(partnerCode: partnerCode, appSecret: appSecret, baseUrl: baseUrl)
//        }
//        Crashlytics.setup()
//    }
    
    static public func setCurrentScreen(_ name: String) {
        TrackingEvent.trackEvent(name: "lid_mmp_screen_view", data: ["screen_name": name])
    }
    
    static public func recordError(name: String, stackTrace: String) {
        Crashlytics.recordError(name: name, stackTrace: stackTrace)
    }
    
    static public func logBeginCheckout(value: Double, currency: String, items: [PurchaseItem]?) {
        TrackingEvent.trackEvent(name: "lid_mmp_begin_checkout", data: [
            "value": value,
            "currency": currency,
            "items": items != nil ? PurchaseItem.convertToArray(items!) : [:]
        ])
    }

    static public func setUserInfo(userInfo: UserInfo) {
        var data: [String: Any] = [:]
        Logger.log("user info")
        Logger.log(userInfo.toDictionary())
        data += DeviceInfo.getDeviceInfo()
        data += userInfo.toDictionary()
        StorageHelper.shared.save(userInfo.userId, forKey: "LinkID_MMP_UserID")
        SessionManager.updateInfo(data: data)
    }
    
    static public func setRevenue(orderId: String, amount: Double, currency: String, data: [String: Any]?) {
        var _data: [String: Any] = [:]
        if (data != nil) {
            _data += data!
        }
        _data += [
            "orderId": orderId,
            "amount": amount,
            "currency": currency
        ]
        TrackingEvent.trackEvent(name: "lid_mmp_revenue", data: _data)
    }
    
    public static func handleDeeplink(_ handleDeeplink: @escaping (String) -> Void) {
        DeepLinkHandler.handleDeeplink = handleDeeplink
    }
}
