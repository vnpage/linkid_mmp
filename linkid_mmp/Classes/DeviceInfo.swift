//
//  DeviceInfo.swift
//  linkid_mmp
//
//  Created by Tuan Dinh on 22/02/2023.
//

import Foundation
import DeviceCheck
import CoreTelephony

class DeviceInfo {
    
    private static let shared = DeviceInfo()
    
    private var identifier = ""
    private var systemInfo = utsname()
    
    init() {
        uname(&systemInfo)
    }
    
    private static let deviceNames = [
        "i386": "iPhone Simulator",
        "x86_64": "iPhone Simulator",
        "arm64": "iPhone Simulator",
        "iPod1,1": "iPod Touch", // (Original)
        "iPod2,1": "iPod Touch", // (Second Generation)
        "iPod3,1": "iPod Touch", // (Third Generation)
        "iPod4,1": "iPod Touch", // (Fourth Generation)
        "iPod5,1": "iPod Touch", // (Fifth Generation)
        "iPod7,1": "iPod Touch", // (Sixth Generation)
        "iPod9,1": "iPod Touch", // (Seventh Generation)
        "iPhone1,1": "iPhone", // (Original)
        "iPhone1,2": "iPhone 3G", // (3G)
        "iPhone2,1": "iPhone 3GS", // (3GS)
        "iPad1,1": "iPad", // (Original)
        "iPad2,1": "iPad 2", //
        "iPad2,2": "iPad 2", //
        "iPad2,3": "iPad 2", //
        "iPad2,4": "iPad 2", //
        "iPad3,1": "iPad", // (3rd Generation)
        "iPad3,2": "iPad", // (3rd Generation)
        "iPad3,3": "iPad", // (3rd Generation)
        "iPhone3,1": "iPhone 4", // (GSM)
        "iPhone3,2": "iPhone 4", // iPhone 4
        "iPhone3,3": "iPhone 4", // (CDMA/Verizon/Sprint)
        "iPhone4,1": "iPhone 4S", //
        "iPhone5,1": "iPhone 5", // (model A1428, AT&T/Canada)
        "iPhone5,2": "iPhone 5", // (model A1429, everything else)
        "iPad3,4": "iPad", // (4th Generation)
        "iPad3,5": "iPad", // (4th Generation)
        "iPad3,6": "iPad", // (4th Generation)
        "iPad2,5": "iPad Mini", // (Original)
        "iPad2,6": "iPad Mini", // (Original)
        "iPad2,7": "iPad Mini", // (Original)
        "iPhone5,3": "iPhone 5c", // (model A1456, A1532 | GSM)
        "iPhone5,4": "iPhone 5c", // (model A1507, A1516, A1526 (China), A1529 | Global)
        "iPhone6,1": "iPhone 5s", // (model A1433, A1533 | GSM)
        "iPhone6,2": "iPhone 5s", // (model A1457, A1518, A1528 (China), A1530 | Global)
        "iPhone7,1": "iPhone 6 Plus", //
        "iPhone7,2": "iPhone 6", //
        "iPhone8,1": "iPhone 6s", //
        "iPhone8,2": "iPhone 6s Plus", //
        "iPhone8,4": "iPhone SE", //
        "iPhone9,1": "iPhone 7", // (model A1660 | CDMA)
        "iPhone9,3": "iPhone 7", // (model A1778 | Global)
        "iPhone9,2": "iPhone 7 Plus", // (model A1661 | CDMA)
        "iPhone9,4": "iPhone 7 Plus", // (model A1784 | Global)
        "iPhone10,3": "iPhone X", // (model A1865, A1902)
        "iPhone10,6": "iPhone X", // (model A1901)
        "iPhone10,1": "iPhone 8", // (model A1863, A1906, A1907)
        "iPhone10,4": "iPhone 8", // (model A1905)
        "iPhone10,2": "iPhone 8 Plus", // (model A1864, A1898, A1899)
        "iPhone10,5": "iPhone 8 Plus", // (model A1897)
        "iPhone11,2": "iPhone XS", // (model A2097, A2098)
        "iPhone11,4": "iPhone XS Max", // (model A1921, A2103)
        "iPhone11,6": "iPhone XS Max", // (model A2104)
        "iPhone11,8": "iPhone XR", // (model A1882, A1719, A2105)
        "iPhone12,1": "iPhone 11",
        "iPhone12,3": "iPhone 11 Pro",
        "iPhone12,5": "iPhone 11 Pro Max",
        "iPhone12,8": "iPhone SE", // (2nd Generation iPhone SE),
        "iPhone13,1": "iPhone 12 mini",
        "iPhone13,2": "iPhone 12",
        "iPhone13,3": "iPhone 12 Pro",
        "iPhone13,4": "iPhone 12 Pro Max",
        "iPhone14,4": "iPhone 13 mini",
        "iPhone14,5": "iPhone 13",
        "iPhone14,2": "iPhone 13 Pro",
        "iPhone14,3": "iPhone 13 Pro Max",
        "iPhone14,6": "iPhone SE", // (3nd Generation iPhone SE),
        "iPhone14,7": "iPhone 14",
        "iPhone14,8": "iPhone 14 Plus",
        "iPhone15,2": "iPhone 14 Pro",
        "iPhone15,3": "iPhone 14 Pro Max",
        "iPad4,1": "iPad Air", // 5th Generation iPad (iPad Air) - Wifi
        "iPad4,2": "iPad Air", // 5th Generation iPad (iPad Air) - Cellular
        "iPad4,3": "iPad Air", // 5th Generation iPad (iPad Air)
        "iPad4,4": "iPad Mini 2", // (2nd Generation iPad Mini - Wifi)
        "iPad4,5": "iPad Mini 2", // (2nd Generation iPad Mini - Cellular)
        "iPad4,6": "iPad Mini 2", // (2nd Generation iPad Mini)
        "iPad4,7": "iPad Mini 3", // (3rd Generation iPad Mini)
        "iPad4,8": "iPad Mini 3", // (3rd Generation iPad Mini)
        "iPad4,9": "iPad Mini 3", // (3rd Generation iPad Mini)
        "iPad5,1": "iPad Mini 4", // (4th Generation iPad Mini)
        "iPad5,2": "iPad Mini 4", // (4th Generation iPad Mini)
        "iPad5,3": "iPad Air 2", // 6th Generation iPad (iPad Air 2)
        "iPad5,4": "iPad Air 2", // 6th Generation iPad (iPad Air 2)
        "iPad6,3": "iPad Pro 9.7-inch", // iPad Pro 9.7-inch
        "iPad6,4": "iPad Pro 9.7-inch", // iPad Pro 9.7-inch
        "iPad6,7": "iPad Pro 12.9-inch", // iPad Pro 12.9-inch
        "iPad6,8": "iPad Pro 12.9-inch", // iPad Pro 12.9-inch
        "iPad6,11": "iPad (5th generation)", // Apple iPad 9.7 inch (5th generation) - WiFi
        "iPad6,12": "iPad (5th generation)", // Apple iPad 9.7 inch (5th generation) - WiFi + cellular
        "iPad7,1": "iPad Pro 12.9-inch", // 2nd Generation iPad Pro 12.5-inch - Wifi
        "iPad7,2": "iPad Pro 12.9-inch", // 2nd Generation iPad Pro 12.5-inch - Cellular
        "iPad7,3": "iPad Pro 10.5-inch", // iPad Pro 10.5-inch - Wifi
        "iPad7,4": "iPad Pro 10.5-inch", // iPad Pro 10.5-inch - Cellular
        "iPad7,5": "iPad (6th generation)", // iPad (6th generation) - Wifi
        "iPad7,6": "iPad (6th generation)", // iPad (6th generation) - Cellular
        "iPad7,11": "iPad (7th generation)", // iPad 10.2 inch (7th generation) - Wifi
        "iPad7,12": "iPad (7th generation)", // iPad 10.2 inch (7th generation) - Wifi + cellular
        "iPad8,1": "iPad Pro 11-inch (3rd generation)", // iPad Pro 11 inch (3rd generation) - Wifi
        "iPad8,2": "iPad Pro 11-inch (3rd generation)", // iPad Pro 11 inch (3rd generation) - 1TB - Wifi
        "iPad8,3": "iPad Pro 11-inch (3rd generation)", // iPad Pro 11 inch (3rd generation) - Wifi + cellular
        "iPad8,4": "iPad Pro 11-inch (3rd generation)", // iPad Pro 11 inch (3rd generation) - 1TB - Wifi + cellular
        "iPad8,5": "iPad Pro 12.9-inch (3rd generation)", // iPad Pro 12.9 inch (3rd generation) - Wifi
        "iPad8,6": "iPad Pro 12.9-inch (3rd generation)", // iPad Pro 12.9 inch (3rd generation) - 1TB - Wifi
        "iPad8,7": "iPad Pro 12.9-inch (3rd generation)", // iPad Pro 12.9 inch (3rd generation) - Wifi + cellular
        "iPad8,8": "iPad Pro 12.9-inch (3rd generation)", // iPad Pro 12.9 inch (3rd generation) - 1TB - Wifi + cellular
        "iPad11,1": "iPad Mini 5", // (5th Generation iPad Mini)
        "iPad11,2": "iPad Mini 5", // (5th Generation iPad Mini)
        "iPad11,3": "iPad Air (3rd generation)",
        "iPad11,4": "iPad Air (3rd generation)",
        "iPad13,1": "iPad Air (4th generation)",
        "iPad13,2": "iPad Air (4th generation)",
        "AppleTV2,1": "Apple TV", // Apple TV (2nd Generation)
        "AppleTV3,1": "Apple TV", // Apple TV (3rd Generation)
        "AppleTV3,2": "Apple TV", // Apple TV (3rd Generation - Rev A)
        "AppleTV5,3": "Apple TV", // Apple TV (4th Generation)
        "AppleTV6,2": "Apple TV 4K" // Apple TV 4K
    ];
    
    public static func getDeviceIdentifier() -> String {
        if(DeviceInfo.shared.identifier != "") {
            return DeviceInfo.shared.identifier
        }
        let machineMirror = Mirror(reflecting: DeviceInfo.shared.systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        DeviceInfo.shared.identifier = identifier
        return identifier
    }
    
    public static func getDeviceName() -> String {
        var deviceName = UIDevice.current.name
        if deviceName == "" || deviceName == "iPhone" || deviceName == "iphone" {
            let identifier = getDeviceIdentifier()
            if let name = deviceNames[identifier] {
                deviceName = name
            } else {
                deviceName = "unknown"
            }
        }
        return deviceName
    }
    
    public static func isSimulator() -> Bool {
        return TARGET_OS_SIMULATOR != 0
    }
    
    public static func isJailBroken() -> Bool {
        if isSimulator() { return false }
        if JailBrokenHelper.hasCydiaInstalled() { return true }
        if JailBrokenHelper.isContainsSuspiciousApps() { return true }
        if JailBrokenHelper.isSuspiciousSystemPathsExists() { return true }
        return JailBrokenHelper.canEditSystemFiles()
    }
    
    public static func getDeviceId() -> String {
        return StorageHelper.shared.getDeviceId()
    }
    
    public static func getAppId() -> String {
        return Bundle.main.bundleIdentifier ?? ""
    }
    
    public static func getSystemName() -> String {
        return UIDevice.current.systemName
    }
    
    public static func getSystemVersion() -> String {
        return UIDevice.current.systemVersion
    }
    
    public static func getAppVersionName() -> String {
        return (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")
    }
    
    public static func getAppVersionCode() -> String {
        return (Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "")
    }
    
    public static func getModel() -> String {
        return UIDevice.current.model
    }
    
    public static func isDeviceCharging() -> Bool {
        return UIDevice.current.batteryState == UIDeviceBatteryState.charging
    }
    
    public static func getDeviceBatteryStatus() -> String {
        if(UIDevice.current.batteryState == UIDeviceBatteryState.charging) {
            return "CHAGRING"
        } else if(UIDevice.current.batteryState == UIDeviceBatteryState.full) {
            return "FULL"
        } else if(UIDevice.current.batteryState == UIDeviceBatteryState.unplugged) {
            return "UNPLUGGED"
        } else {
            return "UNKNOWN"
        }
    }
    
    public static func getDeviceType() -> String {
        let deviceName = getDeviceName().lowercased()
        if deviceName.contains("iphone") {
            return "iphone"
        } else if deviceName.contains("ipod") {
            return "ipod"
        } else if deviceName.contains("ipad") {
            return "ipad"
        }
        return "ios_device"
    }
    
    public static func getDeviceInfo() -> [String: Any] {
        let networkInfo = CTTelephonyNetworkInfo()
        let carrier = networkInfo.subscriberCellularProvider
        let userId = StorageHelper.shared.getValue(forKey: "LinkID_MMP_UserID") ?? ""
        
        let deviceInfo = [
           "sdkDeviceId": DeviceInfo.getDeviceId(),
           "userId": userId,
           "bundleId": DeviceInfo.getAppId(),
           "appVersion": DeviceInfo.getAppVersionName(),
           "os": DeviceInfo.getSystemName(),
           "osVersion": DeviceInfo.getSystemVersion(),
           "deviceModel": DeviceInfo.getDeviceIdentifier(),
           "deviceBrand": "Apple",
           "deviceType": DeviceInfo.getDeviceType(),
           "deviceName": DeviceInfo.getDeviceName(),
           "deviceIsEmulator": DeviceInfo.isSimulator(),
           "deviceIsJailBroken": DeviceInfo.isJailBroken(),
           "deviceLanguage": Locale.preferredLanguages[0],
           "deviceCountry": Locale.current.regionCode ?? "",
           "deviceTimeZone": TimeZone.current.identifier,
           "deviceIsTablet": UIDevice.current.userInterfaceIdiom == .pad,
           "deviceBatteryLevel": UIDevice.current.batteryLevel,
           "deviceBatteryStatus": getDeviceBatteryStatus(),
           "deviceIsCharging": isDeviceCharging(),
           "deviceCarrier": carrier?.carrierName ?? "",
           
        ] as [String : Any]
        print(deviceInfo)
        return deviceInfo
    }
    
}
    
private struct JailBrokenHelper {
    static func hasCydiaInstalled() -> Bool {
        return UIApplication.shared.canOpenURL(URL(string: "cydia://")!)
    }
    
    static func isContainsSuspiciousApps() -> Bool {
        for path in suspiciousAppsPathToCheck {
            if FileManager.default.fileExists(atPath: path) {
                return true
            }
        }
        return false
    }
    
    static func isSuspiciousSystemPathsExists() -> Bool {
        for path in suspiciousSystemPathsToCheck {
            if FileManager.default.fileExists(atPath: path) {
                return true
            }
        }
        return false
    }
    
    static func canEditSystemFiles() -> Bool {
        let jailBreakText = "Developer Insider"
        do {
            try jailBreakText.write(toFile: jailBreakText, atomically: true, encoding: .utf8)
            return true
        } catch {
            return false
        }
    }
    
    /**
     Add more paths here to check for jail break
     */
    static var suspiciousAppsPathToCheck: [String] {
        return ["/Applications/Cydia.app",
                "/Applications/blackra1n.app",
                "/Applications/FakeCarrier.app",
                "/Applications/Icy.app",
                "/Applications/IntelliScreen.app",
                "/Applications/MxTube.app",
                "/Applications/RockApp.app",
                "/Applications/SBSettings.app",
                "/Applications/WinterBoard.app"
        ]
    }
    
    static var suspiciousSystemPathsToCheck: [String] {
        return ["/Library/MobileSubstrate/DynamicLibraries/LiveClock.plist",
                "/Library/MobileSubstrate/DynamicLibraries/Veency.plist",
                "/private/var/lib/apt",
                "/private/var/lib/apt/",
                "/private/var/lib/cydia",
                "/private/var/mobile/Library/SBSettings/Themes",
                "/private/var/stash",
                "/private/var/tmp/cydia.log",
                "/System/Library/LaunchDaemons/com.ikey.bbot.plist",
                "/System/Library/LaunchDaemons/com.saurik.Cydia.Startup.plist",
                "/usr/bin/sshd",
                "/usr/libexec/sftp-server",
                "/usr/sbin/sshd",
                "/etc/apt",
                "/bin/bash",
                "/Library/MobileSubstrate/MobileSubstrate.dylib"
        ]
    }
}
