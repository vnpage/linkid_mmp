//
//  SHA256FingerprintFunction.swift
//  FingerprintJS
//
//  Created by Petr Palata on 10.03.2022.
//

import CryptoKit
//import CryptoSwift
import Foundation

class SHA256HashingFunction: FingerprintFunction {
    public func fingerprint(data: Data) -> String {
        if #available(iOS 13.0, *) {
            let digest = SHA256.hash(data: data)
            return digest.hexStr
        } else {
//            let sha256 = data.sha256()
//            return sha256.bytes.map { String(format: "%02x", $0) }.joined()
            return "not_support"
        }
        
    }
}
