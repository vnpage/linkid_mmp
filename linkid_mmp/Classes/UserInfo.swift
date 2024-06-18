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
    
}
