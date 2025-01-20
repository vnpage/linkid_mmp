//
//  http.swift
//  linkid_mmp
//
//  Created by Tuan Dinh on 30/12/2022.
//

import Foundation

//class HttpClient {
//    static let shared = HttpClient()
//    private let httpQueue = DispatchQueue(label: "com.lynkid.airflex.HttpClientQueue")
//
//    
//    func get(with urlString: String, params: [String: String]?, completion: @escaping (Data?, Error?) -> Void) {
//        httpQueue.async {
//            
//            var newUrl = urlString
//            if newUrl.hasPrefix("http") == false {
//                newUrl = SessionManager.baseUrl + newUrl
//            }
//            guard var urlComponents = URLComponents(string: newUrl) else {
//                completion(nil, NSError(domain: "Invalid URL", code: 0, userInfo: nil))
//                return
//            }
//            
//            Logger.log("---- GET URL ----")
//            Logger.log(newUrl)
//            
//            var queryItems = [URLQueryItem]()
//            if let params = params {
//                for (key, value) in params {
//                    queryItems.append(URLQueryItem(name: key, value: value))
//                }
//            }
//            urlComponents.queryItems = queryItems
//            Logger.log("---- PARAMS ----")
//            Logger.log(queryItems)
//            
//            guard let url = urlComponents.url else {
//                completion(nil, NSError(domain: "Invalid URL", code: 0, userInfo: nil))
//                return
//            }
//            
//            // Create URLRequest and set headers
//            var request = URLRequest(url: url)
//            request.httpMethod = "GET"
//            let authData = StorageHelper.shared.getAuthData()
//            if let authData = authData, let sessionData = authData.data {
//                //            request.addValue("Bearer \(sessionData.token)", forHTTPHeaderField: "Authorization")
//                request.allHTTPHeaderFields = [
//                    "Authorization": "\(sessionData.token)",
//                    "Content-Type": "application/json",
//                    "Platform": "iOS"
//                ]
//            }
//            
//            
//            Logger.log("---- HEADERS ----")
//            Logger.log(request.allHTTPHeaderFields ?? [:])
//            
//            let task = URLSession.shared.dataTask(with: request) { data, response, error in
//                completion(data, error)
//            }
//            task.resume()
//        }
//    }
//    
//    func post(with urlString: String, params: [String: Any]?, completion: @escaping (Data?, Error?) -> Void) {
//        httpQueue.async {
//            var newUrl = urlString
//            if newUrl.startsWith("http") == false {
//                newUrl = SessionManager.baseUrl + newUrl
//            }
//            guard let url = URL(string: newUrl) else {
//                completion(nil, NSError(domain: "Invalid URL", code: 0, userInfo: nil))
//                return
//            }
//            
//            var request = URLRequest(url: url)
//            request.httpMethod = "POST"
//            Logger.log("---- POST URL ----")
//            Logger.log(newUrl)
//            
//            
//            do {
//                if params != nil {
//                    Logger.log("---- PARAMS ----")
//                    Logger.log(params!)
//                    let _data = try JSONSerialization.data(withJSONObject: params!, options: .prettyPrinted)
//                    request.httpBody = _data
//                }
//            } catch {
//                Logger.log(error)
//            }
//            if newUrl.endsWith("/partner/auth") {
//                let timestamp = Int64(Date().timeIntervalSince1970)
//                let str = "\(StorageHelper.shared.getPartnerCode())\(DeviceInfo.getAppId())\(StorageHelper.shared.getDeviceId())\(timestamp)IJODNVU@OJIFOISJF"
//                //            let auth = str.sha256()
//                let auth = Common.sha256(str)
//                let tokenDecode = "\(auth.suffix(10))\(auth.prefix(10))";
//                request.allHTTPHeaderFields = [
//                    "t": "\(timestamp)",
//                    "v": tokenDecode,
//                    "Content-Type": "application/json",
//                    "Platform": "iOS"
//                ]
//            } else {
//                let authData = StorageHelper.shared.getAuthData()
//                if let authData = authData, let sessionData = authData.data {
//                    request.allHTTPHeaderFields = [
//                        "Authorization": "\(sessionData.token)",
//                        "Content-Type": "application/json",
//                        "Platform": "iOS"
//                    ]
//                }
//            }
//            
//            Logger.log("---- HEADER ----")
//            Logger.log(request.allHTTPHeaderFields)
//            
//            let task = URLSession.shared.dataTask(with: request) { data, response, error in
//                completion(data, error)
//            }
//            task.resume()
//        }
//    }
//}


class HttpClient {
    static let shared = HttpClient()
    private let httpQueue = DispatchQueue(label: "com.lynkid.airflex.HttpClientQueue")

    func get(with urlString: String, params: [String: String]?, completion: @escaping (Data?, Error?) -> Void) {
        httpQueue.async {
            // Build URL
            var newUrl = urlString
            if !newUrl.hasPrefix("http") {
                newUrl = SessionManager.baseUrl + newUrl
            }
            guard var urlComponents = URLComponents(string: newUrl) else {
                Logger.log("Invalid URL: \(newUrl)")
                completion(nil, NSError(domain: "Invalid URL", code: 0, userInfo: nil))
                return
            }

            // Add query parameters
            if let params = params {
                urlComponents.queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }
                Logger.log("---- PARAMS ----")
                Logger.log(params)
            }

            guard let url = urlComponents.url else {
                Logger.log("Invalid URL Components: \(newUrl)")
                completion(nil, NSError(domain: "Invalid URL Components", code: 0, userInfo: nil))
                return
            }

            // Create request
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            if let authData = StorageHelper.shared.getAuthData(), let sessionData = authData.data {
                request.allHTTPHeaderFields = [
                    "Authorization": "\(sessionData.token)",
                    "Content-Type": "application/json",
                    "Platform": "iOS"
                ]
            }

            Logger.log("---- GET URL ----")
            Logger.log(url.absoluteString)
            Logger.log("---- HEADERS ----")
            Logger.log(request.allHTTPHeaderFields ?? [:])

            // Perform request
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                completion(data, error)
            }
            task.resume()
        }
    }

    func post(with urlString: String, params: [String: Any]?, completion: @escaping (Data?, Error?) -> Void) {
        httpQueue.async {
            // Build URL
            var newUrl = urlString
            if !newUrl.startsWith("http") {
                newUrl = SessionManager.baseUrl + newUrl
            }
            guard let url = URL(string: newUrl) else {
                Logger.log("Invalid URL: \(newUrl)")
                completion(nil, NSError(domain: "Invalid URL", code: 0, userInfo: nil))
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"

            Logger.log("---- POST URL ----")
            Logger.log(newUrl)

            // Add request body
            if let params = params {
                do {
                    Logger.log("---- PARAMS ----")
                    Logger.log(params)
                    request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
                } catch {
                    Logger.log("Error serializing POST parameters: \(error)")
                    completion(nil, error)
                    return
                }
            }

            // Add headers
            if newUrl.endsWith("/partner/auth") {
                let timestamp = Int64(Date().timeIntervalSince1970)
                let str = "\(StorageHelper.shared.getPartnerCode())\(DeviceInfo.getAppId())\(StorageHelper.shared.getDeviceId())\(timestamp)IJODNVU@OJIFOISJF"
                let auth = Common.sha256(str)
                let tokenDecode = "\(auth.suffix(10))\(auth.prefix(10))"
                request.allHTTPHeaderFields = [
                    "t": "\(timestamp)",
                    "v": tokenDecode,
                    "Content-Type": "application/json",
                    "Platform": "iOS"
                ]
            } else if let authData = StorageHelper.shared.getAuthData(), let sessionData = authData.data {
                request.allHTTPHeaderFields = [
                    "Authorization": "\(sessionData.token)",
                    "Content-Type": "application/json",
                    "Platform": "iOS"
                ]
            }

            Logger.log("---- HEADERS ----")
            Logger.log(request.allHTTPHeaderFields ?? [:])

            // Perform request
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                completion(data, error)
            }
            task.resume()
        }
    }
}
