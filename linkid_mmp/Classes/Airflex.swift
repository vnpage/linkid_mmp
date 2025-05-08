import Foundation
//import airflex_dfp

@objcMembers
public class Airflex {
    
    static var globalOptions :AirflexOptions?

    static public func logEvent(name: String, data: [String: Any]?) {
        TrackingEvent.trackEvent(name: name, data: data)
    }
    
    static public func setDevMode(_ devMode: Bool) {
        Logger.setDevMode(devMode)
    }
    
    static public func initSDK(partnerCode: String, appSecret: String, options: AirflexOptions) {
        if partnerCode != "" {
            globalOptions = options
            Logger.setDevMode(options.showLog)
            if options.autoTrackingScreen {
                ScreenChangeObserver().startObserving()
            }
            StorageHelper.shared.savePartnerCode(partnerCode)
            StorageHelper.shared.saveAppSecret(appSecret)
            SessionManager.auth(partnerCode: partnerCode, appSecret: appSecret)
        }
        Crashlytics.setup()
//        DigitalFootprint.initSevice(tenantId: "2", apiKey: "1233", url: "")
    }
    
    static public func initSDK(partnerCode: String, appSecret: String) {
        let options = AirflexOptions()
        options.showLog = Logger.isDevMode()
        options.extraCode = ""
        initSDK(partnerCode: partnerCode, appSecret: appSecret, options: options)
    }
    
    static public func initSDK(partnerCode: String, appSecret: String, extra: String) {
        let options = AirflexOptions()
        options.showLog = Logger.isDevMode()
        options.extraCode = extra
        initSDK(partnerCode: partnerCode, appSecret: appSecret, options: options)
    }

//    static public func addAppDelegate(_ delegate : UIApplicationDelegate) {
//        UIApplication.shared.delegate = delegate
//    }
    
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

    
    static public func setUserInfo(userInfo: UserInfo) {
        if(SessionManager.currentUserInfo != nil && userInfo.isEqual(user: SessionManager.currentUserInfo!)) {
            return
        }
        var data: [String: Any] = [:]
        Logger.log("user info")
        Logger.log(userInfo.toDictionary())
//        data += DeviceInfo.getDeviceInfo()
//        data += userInfo.toDictionary()
        data.merged(with: DeviceInfo.getDeviceInfo())
        data.merged(with: userInfo.toDictionary())
        if(userInfo.userId != "") {
            StorageHelper.shared.save(userInfo.userId, forKey: "LinkID_MMP_UserID")
        }
        SessionManager.updateInfo(data: data)
    }
    
    static public func setRevenue(orderId: String, amount: Double, currency: String, data: [String: Any]?) {
        var _data: [String: Any] = [:]
        if (data != nil) {
//            _data += data!
            _data.merged(with: data!)
        }
//        _data += [
//            "orderId": orderId,
//            "amount": amount,
//            "currency": currency
//        ]
        _data.merged(with: [
            "orderId": orderId,
            "amount": amount,
            "currency": currency
        ])
        TrackingEvent.trackEvent(name: "lid_mmp_revenue", data: _data)
    }
    
    public static func handleDeeplink(_ handleDeeplink: @escaping (String) -> Void) {
        DeepLinkHandler.handleDeeplink = handleDeeplink
    }
    
    public static func setProductList(listName: String, products: [ProductItem]) {
        let jsonString: String = ProductItem.convertToJsonString(listName: listName, products: products)
        let data = [
            "products": jsonString
        ]
        TrackingEvent.trackEvent(name: "lid_mmp_products", data: data)
    }
    
    public static func removeUserToken() {
        SessionManager.removeUserToken()
    }
    
    public static func clear() {
        SessionManager.clear()
    }
    
    public static func setFlag(flagKey: String, flagValue: String, description: String = "", completion: @escaping (FlagData) -> Void) {
        FlagHelper.setFlag(flagKey: flagKey, flagValue: flagValue, description: description, source: "ios_sdk", completion: completion)
    }
    
    public static func getFlags(flagKey: String, limit: Int, offset: Int, completion: @escaping (FlagData) -> Void) {
        FlagHelper.getFlags(flagKey: flagKey, limit: limit, offset: offset, completion: completion)
    }
    
    public static func getFlags(limit: Int, offset: Int, completion: @escaping (FlagData) -> Void) {
        FlagHelper.getFlags(limit: limit, offset: offset, completion: completion)
    }
}
