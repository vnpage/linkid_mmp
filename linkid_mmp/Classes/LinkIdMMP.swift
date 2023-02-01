import Foundation

public class LinkIdMMP {
    static public func event(name: String, data: [String: Any]?) {
        TrackingEvent.trackEvent(name: "\(name)_\(TrackingEvent.getTotalCount()+1)", data: data)
    }
    
    static public func intSDK(partnerCode: String, appId: String) {
        //http://178.128.221.107:3001/public/partner/auth
        let deviceId = StorageHelper.shared.getDeviceId()
        StorageHelper.shared.savePartnerCode(partnerCode)
        StorageHelper.shared.saveAppId(appId)
        
        let data = ["partnerCode": partnerCode, "appId": appId, "deviceId": deviceId]
        HttpClient.shared.post(with: "http://178.128.221.107:3001/public/partner/auth", params: data) { data, error in
            if let data = data {
                do {
                    let authData = try JSONDecoder().decode(AuthData.self, from: data)
                    if authData.responseCode == 200 {
                        StorageHelper.shared.saveAuthData(data)
                    } else {
                        StorageHelper.shared.removeAuthData()
                    }
                } catch let error {
                    print(error)
                }
            }
        }
    }
}
