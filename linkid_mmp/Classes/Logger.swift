//
//  Logger.swift
//  linkid_mmp
//
//  Created by Tuan Dinh on 31/05/2023.
//

import Foundation

public class Logger {
    private static var devMode = false
    static func setDevMode(_ devMode: Bool) {
        Logger.devMode = devMode
    }
    static func isDevMode() -> Bool {
        return Logger.devMode
    }
    static func log(_ msg: Any) {
        if devMode {
            print("MMP: \(msg)")
        }
    }
}
