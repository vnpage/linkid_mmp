//
//  http.swift
//  linkid_mmp
//
//  Created by Tuan Dinh on 30/12/2022.
//

import Foundation
//import CryptoSwift

//
//// HtppError enum which shows all possible Network errors
//enum HtppError: Error {
//    case networkError(Error)
//    case dataNotFound
//    case jsonParsingError(Error)
//    case invalidStatusCode(Int)
//    case badURL(String)
//}
//
//// HttpResult enum to show success or failure
//enum HttpResult<T> {
//    case success(T)
//    case failure(HtppError)
//}
//
//// dataRequest which sends request to given URL and convert to Decodable Object
//func HttpRequest<T: Decodable>(with url: String, objectType: T.Type, completion: @escaping (HttpResult<T>) -> Void) {
//
//    // create the url with NSURL
//    guard let dataURL = URL(string: url) else {
//       completion(.failure(HtppError.badURL(url)))
//       return
//    }
//
//    // create the session object
//    let session = URLSession.shared
//
//    // now create the URLRequest object using the url object
//    let request = URLRequest(url: dataURL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)
//
//    // create dataTask using the session object to send data to the server
//    let task = session.dataTask(with: request, completionHandler: { data, response, error in
//
//        guard error == nil else {
//            completion(HttpResult.failure(HtppError.networkError(error!)))
//            return
//        }
//
//        guard let data = data else {
//            completion(HttpResult.failure(HtppError.dataNotFound))
//            return
//        }
//
//        do {
//            // create decodable object from data
//            let decodedObject = try JSONDecoder().decode(objectType.self, from: data)
//            completion(HttpResult.success(decodedObject))
//        } catch let error {
//            completion(HttpResult.failure(HtppError.jsonParsingError(error as! DecodingError)))
//        }
//    })
//
//    task.resume()
//}

class HttpClient {
    static let shared = HttpClient()
    
    func get(with urlString: String, params: [String: String]?, completion: @escaping (Data?, Error?) -> Void) {
        var newUrl = urlString
        if newUrl.startWiths("http") == false {
            newUrl = SessionManager.baseUrl + newUrl
        }
        print("newUrl \(newUrl)")
        guard var urlComponents = URLComponents(string: newUrl) else {
            completion(nil, NSError(domain: "Invalid URL", code: 0, userInfo: nil))
            return
        }
        
        var queryItems = [URLQueryItem]()
        if params != nil {
            for (key, value) in params! {
                queryItems.append(URLQueryItem(name: key, value: value))
            }
        }
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            completion(nil, NSError(domain: "Invalid URL", code: 0, userInfo: nil))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, error)
        }
        task.resume()
    }
    
    func post(with urlString: String, params: [String: Any]?, completion: @escaping (Data?, Error?) -> Void) {
        var newUrl = urlString
        if newUrl.startWiths("http") == false {
            newUrl = SessionManager.baseUrl + newUrl
        }
        print("newUrl \(newUrl)")
        guard let url = URL(string: newUrl) else {
            completion(nil, NSError(domain: "Invalid URL", code: 0, userInfo: nil))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        do {
            if params != nil {
                print(params!)
                let _data = try JSONSerialization.data(withJSONObject: params!, options: .prettyPrinted)
                request.httpBody = _data
            }
        } catch {
            print(error)
        }
        if newUrl.endWiths("/partner/auth") {
            let timestamp = Int64(Date().timeIntervalSince1970)
            let str = "\(StorageHelper.shared.getPartnerCode())\(DeviceInfo.getAppId())\(StorageHelper.shared.getDeviceId())\(timestamp)IJODNVU@OJIFOISJF"
            let auth = str.sha256()
            let tokenDecode = "\(auth.suffix(10))\(auth.prefix(10))";
            print("tokenDecode \(tokenDecode)")
            request.allHTTPHeaderFields = [
                "t": "\(timestamp)",
                "v": tokenDecode,
                "Content-Type": "application/json"
            ]
//            request.addValue("t", forHTTPHeaderField: "\(timestamp)")
//            request.addValue("v", forHTTPHeaderField: "\(auth.suffix(10))\(auth.prefix(10))")
        } else {
            let authData = StorageHelper.shared.getAuthData()
            if let authData = authData, let sessionData = authData.data {
//                request.addValue("Authorization", forHTTPHeaderField: "\(authData.data?.token)")
                print("authToken \(sessionData.token)")
                request.allHTTPHeaderFields = [
                    "Authorization": "\(sessionData.token)",
                    "Content-Type": "application/json"
                ]
            }
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            completion(data, error)
        }
        task.resume()
    }
}
