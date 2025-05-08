//
//  UserInfo.swift
//  linkid_mmp
//
//  Created by Tuan Dinh on 22/02/2023.
//

import Foundation

@objcMembers
public class UserInfo {
    var userId: String
    var name: String
    var gender: String
    var email: String
    var phone: String
    var age: Int32
    var country: String
    var city: String
    var deviceToken: String
    
    init(userId: String, name: String, gender: String, email: String, phone: String, age: Int32, country: String, city: String, deviceToken: String) {
        self.userId = userId
        self.name = name
        self.gender = gender
        self.email = email
        self.phone = phone
        self.age = age
        self.country = country
        self.city = city
        self.deviceToken = deviceToken
    }
    
    public class func create(userId: String, name: String, gender: String, email: String, phone: String, age: Int32, country: String, city: String, deviceToken: String) -> UserInfo {
        let user = UserInfo(userId: userId, name: name, gender: gender, email: email, phone: phone, age: age, country: country, city: city, deviceToken: deviceToken)
        return user
    }

    public func toDictionary() -> [String: Any] {
        let data: [String: Any] = [
            "userId": userId,
            "name": name,
            "gender": gender,
            "email": email,
            "phone": phone,
            "age": age,
            "country": country,
            "city": city,
            "firebaseToken": deviceToken,
        ]        
        return data
    }
    
    public class func fromDictionary(data: [String: Any]) -> UserInfo {
        let userId = (data["userId"] as? String ?? "")
        let name = (data["name"] as? String ?? "")
        let gender = (data["gender"] as? String ?? "")
        let email = (data["email"] as? String ?? "")
        let phone = (data["phone"] as? String ?? "")
        let age = (data["age"] as? Int32 ?? 0)
        let country = (data["country"] as? String ?? "")
        let city = (data["city"] as? String ?? "")
        let deviceToken = (data["firebaseToken"] as? String ?? "")
        return UserInfo(userId: userId, name: name, gender: gender, email: email, phone: phone, age: age, country: country, city: city, deviceToken: deviceToken)
    }
    
    public func isEqual(user: UserInfo) -> Bool {
        return dictionariesAreEqual(user.toDictionary(), toDictionary())
    }
    
    private func dictionariesAreEqual(_ dict1: [String: Any], _ dict2: [String: Any]) -> Bool {
        // Check if both dictionaries have the same number of keys
        guard dict1.keys == dict2.keys else { return false }

        for (key, value1) in dict1 {
            guard let value2 = dict2[key] else { return false } // Key must exist in both

            switch (value1, value2) {
            case let (v1 as Int, v2 as Int):
                if v1 != v2 { return false }
            case let (v1 as String, v2 as String):
                if v1 != v2 { return false }
            case let (v1 as Double, v2 as Double):
                if v1 != v2 { return false }
            case let (v1 as Bool, v2 as Bool):
                if v1 != v2 { return false }

            case let (v1 as [String: Any], v2 as [String: Any]):
                if !dictionariesAreEqual(v1, v2) { return false } // Recursive call for nested dictionaries

            case let (v1 as [Any], v2 as [Any]):
                if !arraysAreEqual(v1, v2) { return false } // Compare arrays separately

            default:
                return false // If types don't match or unsupported type
            }
        }
        return true
    }

    private func arraysAreEqual(_ arr1: [Any], _ arr2: [Any]) -> Bool {
        guard arr1.count == arr2.count else { return false }
        for (index, value1) in arr1.enumerated() {
            let value2 = arr2[index]

            switch (value1, value2) {
            case let (v1 as Int, v2 as Int):
                if v1 != v2 { return false }
            case let (v1 as String, v2 as String):
                if v1 != v2 { return false }
            case let (v1 as Double, v2 as Double):
                if v1 != v2 { return false }
            case let (v1 as Bool, v2 as Bool):
                if v1 != v2 { return false }

            case let (v1 as [String: Any], v2 as [String: Any]):
                if !dictionariesAreEqual(v1, v2) { return false } // Recursive call for nested dictionaries

            case let (v1 as [Any], v2 as [Any]):
                if !arraysAreEqual(v1, v2) { return false } // Recursive call for nested arrays

            default:
                return false
            }
        }
        return true
    }
}
