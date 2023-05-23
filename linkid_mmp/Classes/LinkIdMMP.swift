import Foundation

@objcMembers
public class LinkIdMMP {

    static public func logEvent(name: String, data: [String: Any]?) {
        TrackingEvent.trackEvent(name: name, data: data)
    }

    static public func intSDK(partnerCode: String, appSecret: String) {
        //http://178.128.221.107:3001/public/partner/auth
        if partnerCode != "" {
            StorageHelper.shared.savePartnerCode(partnerCode)
            StorageHelper.shared.saveAppSecret(appSecret)
            SessionManager.auth(partnerCode: partnerCode, appSecret: appSecret)
        }
        Crashlytics.setup()
    }
    
    static public func intSDKWithBaseUrl(partnerCode: String, appSecret: String, baseUrl: String) {
        //http://178.128.221.107:3001/public/partner/auth
        if partnerCode != "" {
            StorageHelper.shared.savePartnerCode(partnerCode)
            StorageHelper.shared.saveAppSecret(appSecret)
            StorageHelper.shared.saveBaseUrl(baseUrl)
            SessionManager.authWithBaseUrl(partnerCode: partnerCode, appSecret: appSecret, baseUrl: baseUrl)
        }
        Crashlytics.setup()
    }
    
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
        print("user info")
        print(userInfo.toDictionary())
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
}
