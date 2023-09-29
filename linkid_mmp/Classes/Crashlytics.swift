//
//  Crashlytics.swift
//  linkid_mmp
//
//  Created by Tuan Dinh on 27/04/2023.
//

import Foundation

public class Crashlytics {
    public static func setup() {
        NSSetUncaughtExceptionHandler { exception in
            Crashlytics.handleException(exception)
        }

        signal(SIGABRT) { signal in
            Crashlytics.signalHandler(signal)
        }

        signal(SIGILL) { signal in
            Crashlytics.signalHandler(signal)
        }

        signal(SIGSEGV) { signal in
            Crashlytics.signalHandler(signal)
        }

        signal(SIGFPE) { signal in
            Crashlytics.signalHandler(signal)
        }

        signal(SIGBUS) { signal in
            Crashlytics.signalHandler(signal)
        }
//        NSSetUncaughtExceptionHandler { (exception) in
//            let stackTrace = exception.callStackSymbols.joined(separator: "\n")
//            let crashLog = "Exception: \(exception)\nStack Trace:\n\(stackTrace)"
//            Crashlytics.saveCrashLog(crashLog)
//        }
//
//        signal(SIGABRT) { s in
//            let stackTrace = Thread.callStackSymbols.joined(separator: "\n")
//            let crashLog = "Exception: \(s)\nStack Trace:\n\(stackTrace)"
//            Crashlytics.saveCrashLog(crashLog)
//            exit(s)
//        }
//
//        signal(SIGILL) { s in
//            let stackTrace = Thread.callStackSymbols.joined(separator: "\n")
//            let crashLog = "Exception: \(s)\nStack Trace:\n\(stackTrace)"
//            Crashlytics.saveCrashLog(crashLog)
//            exit(s)
//        }
//
//        signal(SIGSEGV) { s in
//            let stackTrace = Thread.callStackSymbols.joined(separator: "\n")
//            let crashLog = "Exception: \(s)\nStack Trace:\n\(stackTrace)"
//            Crashlytics.saveCrashLog(crashLog)
//            exit(s)
//        }
//        NSSetUncaughtExceptionHandler { exception in
//            let stackTrace = exception.callStackSymbols.joined(separator: "\n")
//            let crashLog = "Exception: \(exception)\nStack Trace:\n\(stackTrace)"
//            Crashlytics.saveCrashLog(crashLog)
//        }
    }
    
    private static func signalHandler(_ signal: Int32) {
//        print("LinkIdMMP Signal \(signal) caught")
        saveCrashLog("Signal \(signal) caught", hash: Common.md5("\(signal)"))
        // Handle the signal here, such as logging it or showing an alert to the user.
    }
    
    private static func handleException(_ exception: NSException) {
//        print("LinkIdMMP Unhandled exception: \(exception)")
        // Handle the exception here, such as logging it or showing an alert to the user.
        saveCrashLog("Unhandled exception: \(exception)\n\(exception.callStackSymbols)", hash: Common.md5("\(exception.hash)"))
    }

    private static func saveCrashLog(_ crashLog: String, hash: String) {
        UserDefaults.standard.set(crashLog, forKey: "LinkIdMMP_last_crash")
        UserDefaults.standard.set(hash, forKey: "LinkIdMMP_last_crash_hash")
        UserDefaults.standard.synchronize()
    }
    
    public static func recordError(name: String, stackTrace: String) {
        if StorageHelper().getAuthData() != nil {
            sendCrashLogToServer(stackTrace, hash: Common.md5(name))
        } else {
            saveCrashLog(stackTrace, hash: Common.md5(name))
        }
    }
    
    public static func check() {
        if let exception = UserDefaults.standard.object(forKey: "LinkIdMMP_last_crash") as? String {
            if exception != "" {
                let hash = (UserDefaults.standard.object(forKey: "LinkIdMMP_last_crash_hash") as? String) ?? Common.md5(exception)
                sendCrashLogToServer(exception, hash: hash)
            }
        }
    }
    
    private static func sendCrashLogToServer(_ crashLog: String, hash: String) {
        let bugs = [
            "platform": "ios",
            "hash": hash,
            "deviceModel": DeviceInfo.getDeviceIdentifier(),
            "osVersion": DeviceInfo.getSystemVersion(),
            "appVersion": DeviceInfo.getAppVersionName(),
            "stackTrace": crashLog
        ]
        HttpClient.shared.post(with: "/partner/crash/log", params: bugs) { data, _error in
            if let data = data {
                do {
                    let result = try JSONDecoder().decode(ResultData.self, from: data)
                    if result.responseCode >= 200 && result.responseCode <= 299 {
                        saveCrashLog("", hash: "")
                        return
                    } else {
                        Logger.log(result.responseText)
                        
                    }
                } catch {
                    Logger.log(error)
                }
            } else {
                Logger.log(_error ?? "")
            }
            saveCrashLog(crashLog, hash: hash)
        }
//        let url = URL(string: "https://yourserver.com/api/crashlogs")!
//        let parameters: [String: Any] = [
//            "crash_log": crashLog
//        ]
    }
}



