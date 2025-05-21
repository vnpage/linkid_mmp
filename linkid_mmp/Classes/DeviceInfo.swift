//
//  DeviceInfo.swift
//  linkid_mmp
//
//  Created by Tuan Dinh on 22/02/2023.
//

import Foundation
import DeviceCheck
import CoreTelephony

public enum Network: String {
    case wifi = "en0"
    case cellular = "pdp_ip0"
}

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
        "iPhone1,1": "iPhone",
        "iPhone1,2": "iPhone 3G",
        "iPhone2,1": "iPhone 3GS",
        "iPhone3,1": "iPhone 4",
        "iPhone3,2": "iPhone 4 GSM Rev A",
        "iPhone3,3": "iPhone 4 CDMA",
        "iPhone4,1": "iPhone 4S",
        "iPhone5,1": "iPhone 5 (GSM)",
        "iPhone5,2": "iPhone 5 (GSM+CDMA)",
        "iPhone5,3": "iPhone 5C (GSM)",
        "iPhone5,4": "iPhone 5C (Global)",
        "iPhone6,1": "iPhone 5S (GSM)",
        "iPhone6,2": "iPhone 5S (Global)",
        "iPhone7,1": "iPhone 6 Plus",
        "iPhone7,2": "iPhone 6",
        "iPhone8,1": "iPhone 6s",
        "iPhone8,2": "iPhone 6s Plus",
        "iPhone8,4": "iPhone SE (GSM)",
        "iPhone9,1": "iPhone 7",
        "iPhone9,2": "iPhone 7 Plus",
        "iPhone9,3": "iPhone 7",
        "iPhone9,4": "iPhone 7 Plus",
        "iPhone10,1": "iPhone 8",
        "iPhone10,2": "iPhone 8 Plus",
        "iPhone10,3": "iPhone X Global",
        "iPhone10,4": "iPhone 8",
        "iPhone10,5": "iPhone 8 Plus",
        "iPhone10,6": "iPhone X GSM",
        "iPhone11,2": "iPhone XS",
        "iPhone11,4": "iPhone XS Max",
        "iPhone11,6": "iPhone XS Max Global",
        "iPhone11,8": "iPhone XR",
        "iPhone12,1": "iPhone 11",
        "iPhone12,3": "iPhone 11 Pro",
        "iPhone12,5": "iPhone 11 Pro Max",
        "iPhone12,8": "iPhone SE 2nd Gen",
        "iPhone13,1": "iPhone 12 Mini",
        "iPhone13,2": "iPhone 12",
        "iPhone13,3": "iPhone 12 Pro",
        "iPhone13,4": "iPhone 12 Pro Max",
        "iPhone14,2": "iPhone 13 Pro",
        "iPhone14,3": "iPhone 13 Pro Max",
        "iPhone14,4": "iPhone 13 Mini",
        "iPhone14,5": "iPhone 13",
        "iPhone14,6": "iPhone SE 3rd Gen",
        "iPhone14,7": "iPhone 14",
        "iPhone14,8": "iPhone 14 Plus",
        "iPhone15,2": "iPhone 14 Pro",
        "iPhone15,3": "iPhone 14 Pro Max",
        "iPhone15,4": "iPhone 15",
        "iPhone15,5": "iPhone 15 Plus",
        "iPhone16,1": "iPhone 15 Pro",
        "iPhone16,2": "iPhone 15 Pro Max",
        "iPod1,1": "1st Gen iPod",
        "iPod2,1": "2nd Gen iPod",
        "iPod3,1": "3rd Gen iPod",
        "iPod4,1": "4th Gen iPod",
        "iPod5,1": "5th Gen iPod",
        "iPod7,1": "6th Gen iPod",
        "iPod9,1": "7th Gen iPod",
        "iPad1,1": "iPad",
        "iPad1,2": "iPad 3G",
        "iPad2,1": "2nd Gen iPad",
        "iPad2,2": "2nd Gen iPad GSM",
        "iPad2,3": "2nd Gen iPad CDMA",
        "iPad2,4": "2nd Gen iPad New Revision",
        "iPad3,1": "3rd Gen iPad",
        "iPad3,2": "3rd Gen iPad CDMA",
        "iPad3,3": "3rd Gen iPad GSM",
        "iPad2,5": "iPad mini",
        "iPad2,6": "iPad mini GSM+LTE",
        "iPad2,7": "iPad mini CDMA+LTE",
        "iPad3,4": "4th Gen iPad",
        "iPad3,5": "4th Gen iPad GSM+LTE",
        "iPad3,6": "4th Gen iPad CDMA+LTE",
        "iPad4,1": "iPad Air (WiFi)",
        "iPad4,2": "iPad Air (GSM+CDMA)",
        "iPad4,3": "1st Gen iPad Air (China)",
        "iPad4,4": "iPad mini Retina (WiFi)",
        "iPad4,5": "iPad mini Retina (GSM+CDMA)",
        "iPad4,6": "iPad mini Retina (China)",
        "iPad4,7": "iPad mini 3 (WiFi)",
        "iPad4,8": "iPad mini 3 (GSM+CDMA)",
        "iPad4,9": "iPad Mini 3 (China)",
        "iPad5,1": "iPad mini 4 (WiFi)",
        "iPad5,2": "4th Gen iPad mini (WiFi+Cellular)",
        "iPad5,3": "iPad Air 2 (WiFi)",
        "iPad5,4": "iPad Air 2 (Cellular)",
        "iPad6,3": "iPad Pro (9.7 inch, WiFi)",
        "iPad6,4": "iPad Pro (9.7 inch, WiFi+LTE)",
        "iPad6,7": "iPad Pro (12.9 inch, WiFi)",
        "iPad6,8": "iPad Pro (12.9 inch, WiFi+LTE)",
        "iPad6,11": "iPad (2017)",
        "iPad6,12": "iPad (2017)",
        "iPad7,1": "iPad Pro 2nd Gen (WiFi)",
        "iPad7,2": "iPad Pro 2nd Gen (WiFi+Cellular)",
        "iPad7,3": "iPad Pro 10.5-inch 2nd Gen",
        "iPad7,4": "iPad Pro 10.5-inch 2nd Gen",
        "iPad7,5": "iPad 6th Gen (WiFi)",
        "iPad7,6": "iPad 6th Gen (WiFi+Cellular)",
        "iPad7,11": "iPad 7th Gen 10.2-inch (WiFi)",
        "iPad7,12": "iPad 7th Gen 10.2-inch (WiFi+Cellular)",
        "iPad8,1": "iPad Pro 11 inch 3rd Gen (WiFi)",
        "iPad8,2": "iPad Pro 11 inch 3rd Gen (1TB, WiFi)",
        "iPad8,3": "iPad Pro 11 inch 3rd Gen (WiFi+Cellular)",
        "iPad8,4": "iPad Pro 11 inch 3rd Gen (1TB, WiFi+Cellular)",
        "iPad8,5": "iPad Pro 12.9 inch 3rd Gen (WiFi)",
        "iPad8,6": "iPad Pro 12.9 inch 3rd Gen (1TB, WiFi)",
        "iPad8,7": "iPad Pro 12.9 inch 3rd Gen (WiFi+Cellular)",
        "iPad8,8": "iPad Pro 12.9 inch 3rd Gen (1TB, WiFi+Cellular)",
        "iPad8,9": "iPad Pro 11 inch 4th Gen (WiFi)",
        "iPad8,10": "iPad Pro 11 inch 4th Gen (WiFi+Cellular)",
        "iPad8,11": "iPad Pro 12.9 inch 4th Gen (WiFi)",
        "iPad8,12": "iPad Pro 12.9 inch 4th Gen (WiFi+Cellular)",
        "iPad11,1": "iPad mini 5th Gen (WiFi)",
        "iPad11,2": "iPad mini 5th Gen",
        "iPad11,3": "iPad Air 3rd Gen (WiFi)",
        "iPad11,4": "iPad Air 3rd Gen",
        "iPad11,6": "iPad 8th Gen (WiFi)",
        "iPad11,7": "iPad 8th Gen (WiFi+Cellular)",
        "iPad12,1": "iPad 9th Gen (WiFi)",
        "iPad12,2": "iPad 9th Gen (WiFi+Cellular)",
        "iPad13,1": "iPad Air 4th Gen (WiFi)",
        "iPad13,2": "iPad Air 4th Gen (WiFi+Cellular)",
        "iPad13,4": "iPad Pro 11 inch 5th Gen",
        "iPad13,5": "iPad Pro 11 inch 5th Gen",
        "iPad13,6": "iPad Pro 11 inch 5th Gen",
        "iPad13,7": "iPad Pro 11 inch 5th Gen",
        "iPad13,8": "iPad Pro 12.9 inch 5th Gen",
        "iPad13,9": "iPad Pro 12.9 inch 5th Gen",
        "iPad13,10": "iPad Pro 12.9 inch 5th Gen",
        "iPad13,11": "iPad Pro 12.9 inch 5th Gen",
        "iPad13,16": "iPad Air 5th Gen",
        "iPad13,17": "iPad Air 5th Gen",
        "iPad14,1": "iPad mini 6th Gen (WiFi)",
        "iPad14,2": "iPad mini 6th Gen (WiFi+Cellular)",
        "iPad13,18": "iPad 10th Gen (WiFi)",
        "iPad13,19": "iPad 10th Gen (WiFi+Cellular)",
        "iPad14,3": "iPad Pro 11 inch 6th Gen",
        "iPad14,4": "iPad Pro 11 inch 6th Gen",
        "iPad14,5": "iPad Pro 12.9 inch 6th Gen",
        "iPad14,6": "iPad Pro 12.9 inch 6th Gen",
        "AppleTV1,1": "Apple TV",
        "AppleTV2,1": "Apple TV 2nd Gen",
        "AppleTV3,1": "Apple TV 3rd Gen Early 2012",
        "AppleTV3,2": "Apple TV 3rd Gen Early 2013",
        "AppleTV5,3": "Apple TV 4th Gen 2015",
        "AppleTV6,2": "Apple TV 4K",
        "AppleTV11,1": "Apple TV 4K (2nd Gen)",
        "AppleTV14,1": "Apple TV 4K (3rd Gen)",
        "Watch1,1": "Apple Watch 38mm case",
        "Watch1,2": "Apple Watch 42mm case",
        "Watch2,6": "Apple Watch Series 1 38mm case",
        "Watch2,7": "Apple Watch Series 1 42mm case",
        "Watch2,3": "Apple Watch Series 2 38mm case",
        "Watch2,4": "Apple Watch Series 2 42mm case",
        "Watch3,1": "Apple Watch Series 3 38mm case (GPS+Cellular)",
        "Watch3,2": "Apple Watch Series 3 42mm case (GPS+Cellular)",
        "Watch3,3": "Apple Watch Series 3 38mm case (GPS)",
        "Watch3,4": "Apple Watch Series 3 42mm case (GPS)",
        "Watch4,1": "Apple Watch Series 4 40mm case (GPS)",
        "Watch4,2": "Apple Watch Series 4 44mm case (GPS)",
        "Watch4,3": "Apple Watch Series 4 40mm case (GPS+Cellular)",
        "Watch4,4": "Apple Watch Series 4 44mm case (GPS+Cellular)",
        "Watch5,1": "Apple Watch Series 5 40mm case (GPS)",
        "Watch5,2": "Apple Watch Series 5 44mm case (GPS)",
        "Watch5,3": "Apple Watch Series 5 40mm case (GPS+Cellular)",
        "Watch5,4": "Apple Watch Series 5 44mm case (GPS+Cellular)",
        "Watch5,9": "Apple Watch SE 40mm case (GPS)",
        "Watch5,10": "Apple Watch SE 44mm case (GPS)",
        "Watch5,11": "Apple Watch SE 40mm case (GPS+Cellular)",
        "Watch5,12": "Apple Watch SE 44mm case (GPS+Cellular)",
        "Watch6,1": "Apple Watch Series 6 40mm case (GPS)",
        "Watch6,2": "Apple Watch Series 6 44mm case (GPS)",
        "Watch6,3": "Apple Watch Series 6 40mm case (GPS+Cellular)",
        "Watch6,4": "Apple Watch Series 6 44mm case (GPS+Cellular)",
        "Watch6,6": "Apple Watch Series 7 41mm case (GPS)",
        "Watch6,7": "Apple Watch Series 7 45mm case (GPS)",
        "Watch6,8": "Apple Watch Series 7 41mm case (GPS+Cellular)",
        "Watch6,9": "Apple Watch Series 7 45mm case (GPS+Cellular)",
        "Watch6,10": "Apple Watch SE 40mm case (GPS)",
        "Watch6,11": "Apple Watch SE 44mm case (GPS)",
        "Watch6,12": "Apple Watch SE 40mm case (GPS+Cellular)",
        "Watch6,13": "Apple Watch SE 44mm case (GPS+Cellular)",
        "Watch6,14": "Apple Watch Series 8 41mm case (GPS)",
        "Watch6,15": "Apple Watch Series 8 45mm case (GPS)",
        "Watch6,16": "Apple Watch Series 8 41mm case (GPS+Cellular)",
        "Watch6,17": "Apple Watch Series 8 45mm case (GPS+Cellular)",
        "Watch6,18": "Apple Watch Ultra 49mm case (GPS+Cellular)",
        "Watch6,19": "Apple Watch Ultra 2 49mm case (GPS+Cellular)",
        "Watch6,20": "Apple Watch SE 40mm case (GPS)",
        "Watch6,21": "Apple Watch SE 44mm case (GPS)",
        "Watch6,22": "Apple Watch SE 40mm case (GPS+Cellular)",
        "Watch6,23": "Apple Watch SE 44mm case (GPS+Cellular)"
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
        #if targetEnvironment(simulator)
        return true
        #else
        return false
        #endif
//        return TARGET_OS_SIMULATOR != 0
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
        if let extraCode = Airflex.globalOptions?.extraCode as String?, extraCode != "" {
            return "\(Bundle.main.bundleIdentifier ?? "").\(extraCode)"
        }
        return Bundle.main.bundleIdentifier ?? ""
    }
    
    public static func getFingerprint() {
        var data : [String: Any] = [:]
//        data += DeviceInfo.getDeviceInfo()
        data.merged(with: DeviceInfo.getDeviceInfo())
        if let userId = StorageHelper.shared.getValue(forKey: "LinkID_MMP_UserID") as String?, userId != "" {
            data["userId"] = userId
        }

        let fingerprinter = FingerprinterFactory.getInstance()
        fingerprinter.getFingerprint { fingerprint in
            data["fingerprint"] = fingerprint
//            SessionManager.shared?.saveData(data: data)
        }
        fingerprinter.getDeviceId { deviceId in
            data["fingerprintDeviceId"] = deviceId
//            SessionManager.shared?.saveData(data: data)
        }
        
        fingerprinter.getFingerprintTree { fingerprintTree in
            fingerprintTree.children?.forEach({ child in
                if child.info.label == "Hardware" {
                    data["deviceHadwareId"] = child.fingerprint
                }
                if child.info.label == "Operating System" {
                    data["deviceOSId"] = child.fingerprint
                }
                if child.info.label == "Identifiers" {
                    data["iOSIdentifiers"] = child.fingerprint
                }
                child.children?.forEach({ item in
                    if case let .info(value) = item.info.value {
//                        if item.info.label=="Display resolution" {
//                            data["deviceRegularScreen"] = value
//                        }
//                        if item.info.label=="Physical memory" {
//                            data["deviceRam"] = value
//                        }
//                        if item.info.label=="Processor count" {
//                            data["deviceCpuCountCore"] = value
//                        }
//                        if item.info.label=="OS type" {
//                            data["deviceiOSType"] = value.replaceAll(of: "\0", with: "")
//                        }
//                        if item.info.label=="OS version" {
//                            data["deviceiOSVersionCode"] = value.replaceAll(of: "\0", with: "")
//                        }
//                        if item.info.label=="Device model" {
//                            data["deviceiOSModel"] = value.replaceAll(of: "\0", with: "")
//                        }
//                        if item.info.label=="OS release" {
//                            data["deviceiOSRelease"] = value.replaceAll(of: "\0", with: "")
//                        }
//                        if item.info.label=="Kernel version" {
//                            data["deviceiOSKernelVersion"] = value.replaceAll(of: "\0", with: "")
//                        }
                        if item.info.label=="Vendor identifier" {
                            data["deviceiOSVendorId"] = value
                        }
                        SessionManager.updateInfo(data: data)
                    }
                    
                })
            })
//            SessionManager.shared?.saveData(data: data)
        }
//        SessionManager.shared?.saveData(data: data)
        
//        DeviceInfo.getDeviceSpecByCode("iphone 11 pro max")
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
        return UIDevice.current.batteryState == UIDevice.BatteryState.charging
    }
    
    public static func getDeviceBatteryStatus() -> String {
        if(UIDevice.current.batteryState == UIDevice.BatteryState.charging) {
            return "CHAGRING"
        } else if(UIDevice.current.batteryState == UIDevice.BatteryState.full) {
            return "FULL"
        } else if(UIDevice.current.batteryState == UIDevice.BatteryState.unplugged) {
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
        Logger.log(deviceInfo)
        return deviceInfo
    }
    
    public static func getIPAddress(for network: Network) -> String? {
        var address: String?
        
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else {
            return nil
        }
        guard let firstAddr = ifaddr else {
            return nil
        }
        
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
            
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                let name = String(cString: interface.ifa_name)
                if name == network.rawValue {
                    var hostName = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len), &hostName, socklen_t(hostName.count), nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostName)
                }
            }
        }
        freeifaddrs(ifaddr)
        
        return address
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
