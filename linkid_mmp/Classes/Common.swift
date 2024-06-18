//
//  Common.swift
//  linkid_mmp
//
//  Created by Tuan Dinh on 31/01/2023.
//

import Foundation
//@_implementationOnly import CryptoSwift
import CommonCrypto

public class Common {
    
    static func sha256(_ data: String) -> String {
        let inputData = Data(data.utf8)
        var hashData = Data(count: Int(CC_SHA256_DIGEST_LENGTH))
        
        _ = hashData.withUnsafeMutableBytes { hashBytes in
            inputData.withUnsafeBytes { messageBytes in
                CC_SHA256(messageBytes.baseAddress, CC_LONG(inputData.count), hashBytes.bindMemory(to: UInt8.self).baseAddress)
            }
        }
        
        return hashData.map { String(format: "%02hhx", $0) }.joined()
    }
    
    static func md5(_ string: String) -> String {
        //        let inputData = Data(string.utf8)
        //        let md5Data = inputData.md5()
        //        let md5String = md5Data.map { String(format: "%02hhx", $0) }.joined()
        //        return md5String
        
        let length = Int(CC_MD5_DIGEST_LENGTH)
        let messageData = string.data(using:.utf8)!
        var digestData = Data(count: length)
        
        _ = digestData.withUnsafeMutableBytes { digestBytes -> UInt8 in
            messageData.withUnsafeBytes { messageBytes -> UInt8 in
                if let messageBytesBaseAddress = messageBytes.baseAddress, let digestBytesBlindMemory = digestBytes.bindMemory(to: UInt8.self).baseAddress {
                    let messageLength = CC_LONG(messageData.count)
                    CC_MD5(messageBytesBaseAddress, messageLength, digestBytesBlindMemory)
                }
                return 0
            }
        }
        return digestData.map { String(format: "%02hhx", $0) }.joined()
    }
    
    //    static func encrypt(message: String, key: String) -> String {
    //        let keyData = Data(md5(key).utf8)
    //        let messageData = Data(message.utf8)
    //
    //        do {
    //            let encryption = try AES(key: keyData.bytes, blockMode: ECB(), padding: Padding.noPadding)
    //            let blockSize = 16
    //            let paddingLength = blockSize - messageData.count % blockSize
    //            let paddingData = Data(count: paddingLength)
    //            let paddedData = messageData + paddingData
    //            let encryptedData = try encryption.encrypt(paddedData.bytes)
    //            return encryptedData.toHexString()
    //        } catch {
    //            print("Error encrypting: \(error)")
    //            return ""
    //        }
    //    }
    
//        static func decrypt(encrypted: String, key: String) -> String {
//            do {
//                let keyData = Data(md5(key).utf8)
//                let keyBytes = keyData.bytes
//    
//                let cipherData = Data(hex: encrypted)
//    
//                let decryption = try AES(key: keyBytes, blockMode: ECB(), padding: Padding.noPadding)
//                let decryptedData = try decryption.decrypt(cipherData.bytes)
//    
//                let decryptedString = String(bytes: decryptedData, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "\0", with: "") ?? ""
//                return decryptedString
//            } catch {
//                Logger.log("error \(error)")
//                return ""
//            }
//        }
    
    static func decrypt(encrypted: String, key: String) -> String {
        do {
            let keyData = Data(md5(key).utf8)
            // Convert encrypted hex string to Data
            guard let cipherData = Data(hexString: encrypted) else {
                Logger.log("Invalid encrypted data")
                return ""
            }
            
            // Ensure the length of the cipher data is a multiple of the block size (16 bytes for AES)
            guard cipherData.count % kCCBlockSizeAES128 == 0 else {
                Logger.log("Invalid encrypted data length")
                return ""
            }
            
            var decryptedData = Data(count: cipherData.count)
            var numBytesDecrypted: size_t = 0
            let count = decryptedData.count
            
            let cryptStatus = decryptedData.withUnsafeMutableBytes { decryptedBytes -> CCCryptorStatus in
                return cipherData.withUnsafeBytes { cipherBytes -> CCCryptorStatus in
                    return keyData.withUnsafeBytes { keyBytes -> CCCryptorStatus in
                        return CCCrypt(
                            CCOperation(kCCDecrypt),            // Decrypt operation
                            CCAlgorithm(kCCAlgorithmAES),      // AES algorithm
                            CCOptions(kCCOptionECBMode),       // ECB mode, no padding
                            keyBytes.baseAddress!,             // Key
                            keyData.count,                     // Key length
                            nil,                               // No IV for ECB mode
                            cipherBytes.baseAddress!,          // Encrypted data bytes
                            cipherData.count,                  // Encrypted data length
                            decryptedBytes.baseAddress!,       // Decrypted data buffer
                            count,               // Decrypted data buffer size
                            &numBytesDecrypted                // Number of bytes decrypted
                        )
                    }
                }
            }
            
            if cryptStatus == kCCSuccess {
                // Trim the decrypted data to the actual size of the decrypted content
                decryptedData.removeSubrange(numBytesDecrypted..<decryptedData.count)
                if let decryptedString = String(data: decryptedData, encoding: .utf8) {
                    return decryptedString.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "\0", with: "")
                } else {
                    Logger.log("Decryption resulted in non-UTF8 data: \(decryptedData as NSData)")
                    return ""
                }
            } else {
                Logger.log("Decryption failed with status \(cryptStatus)")
                return ""
            }
        } catch {
            Logger.log("Error during decryption: \(error)")
            return ""
        }
    }
}

extension Data {
    init?(hexString: String) {
        let len = hexString.count / 2
        var data = Data(capacity: len)
        var index = hexString.startIndex
        for _ in 0..<len {
            let nextIndex = hexString.index(index, offsetBy: 2)
            guard let b = UInt8(hexString[index..<nextIndex], radix: 16) else { return nil }
            data.append(b)
            index = nextIndex
        }
        self = data
    }
}
