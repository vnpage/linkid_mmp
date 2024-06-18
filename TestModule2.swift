//
//  TestModule2.swift
//  linkid_mmp
//
//  Created by Tuan Dinh on 21/02/2023.
//

import Foundation
import KeychainSwift
import CryptoSwift

class TestModule2 {
    
    static let shared = TestModule2()
    
    func hihi() {
        print("TestModule2 hihi")
        print("TestModule2 hihi".sha256())
    }
    
    func hihi2() {
        let keychain = KeychainSwift()
        keychain.set("hello", forKey: "test")
        print("TestModule2 hihi2 saved")
    }
}
