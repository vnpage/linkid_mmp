//
//  http.swift
//  linkid_mmp
//
//  Created by Tuan Dinh on 30/12/2022.
//

import Foundation

// HtppError enum which shows all possible Network errors
enum HtppError: Error {
    case networkError(Error)
    case dataNotFound
    case jsonParsingError(Error)
    case invalidStatusCode(Int)
    case badURL(String)
}

// HttpResult enum to show success or failure
enum HttpResult<T> {
    case success(T)
    case failure(HtppError)
}

// dataRequest which sends request to given URL and convert to Decodable Object
func HttpRequest<T: Decodable>(with url: String, objectType: T.Type, completion: @escaping (HttpResult<T>) -> Void) {
    
    // create the url with NSURL
    guard let dataURL = URL(string: url) else {
       completion(.failure(HtppError.badURL(url)))
       return
    }
    
    // create the session object
    let session = URLSession.shared
    
    // now create the URLRequest object using the url object
    let request = URLRequest(url: dataURL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)
    
    // create dataTask using the session object to send data to the server
    let task = session.dataTask(with: request, completionHandler: { data, response, error in
        
        guard error == nil else {
            completion(HttpResult.failure(HtppError.networkError(error!)))
            return
        }
        
        guard let data = data else {
            completion(HttpResult.failure(HtppError.dataNotFound))
            return
        }
        
        do {
            // create decodable object from data
            let decodedObject = try JSONDecoder().decode(objectType.self, from: data)
            completion(HttpResult.success(decodedObject))
        } catch let error {
            completion(HttpResult.failure(HtppError.jsonParsingError(error as! DecodingError)))
        }
    })
    
    task.resume()
}
