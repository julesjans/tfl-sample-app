//
//  APIClient.swift
//  tfl-app
//
//  Created by Julian Jans on 26/07/2018.
//  Copyright © 2018 Julian Jans. All rights reserved.
//

import Foundation

// MARK: - APIAccessible

/**
 APIAccessible protocol.
 Classes that conform to this protocol can be accessed using an APIClient.
 */
protocol APIAccessible {
    init?(dict: [String: Any])
}

extension APIAccessible {
    /**
     GET Request for data. Dependency injection of APIClient to enable testing.
     - parameter id: String id/search term for request.
     - parameter api: The APIClient to use.
     - parameter completion: Completion block with success status, array of APIAccessibles, or APIError.
     */
    static func get(id: String?, api: APIClient, completion: @escaping (Array<Self>?, APIError?) -> Void) {
        var urlString = String(describing: Self.self).lowercased()
        if let idString = id {urlString.append("/\(idString.lowercased())")}
        api.get(urlString: urlString, completion: completion)
    }
    
}

// MARK: - APIClient

/**
 APIClient protocol.
 Classes that conform to this protocol can be used to fetch APIAccessible items.
 */
protocol APIClient {
    /**
     GET Request for data using generic types.
     - parameter urlString: Specific url for resource.
     - parameter completion: Completion block with success status, array of APIAccessibles, or APIError
     */
    func get<T:APIAccessible>(urlString: String, completion: @escaping (Array<T>?, APIError?) -> Void)
}

struct APIError: Error {
    
    let statusCode: Int?
    let statusMessage: String?
    
}

// MARK: - Live API

final class APIClientLive: APIClient {

    func get<T:APIAccessible>(urlString: String, completion: @escaping (Array<T>?, APIError?) -> Void) {
        
        var query = URLComponents(string: "https://api.tfl.gov.uk")
        query?.path = "/\(urlString)"
        let appID = URLQueryItem(name: "app_id", value: APICredentials.app)
        let appKey = URLQueryItem(name: "app_key", value: APICredentials.key)
        query?.queryItems = [appID, appKey]
    
        guard let url = query?.url else {
            assertionFailure("Invalid API URL")
            return
        }

        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { (data, response, error) in
            
            guard error == nil else {
                completion(nil, APIError(statusCode: nil, statusMessage: error!.localizedDescription))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(nil, APIError(statusCode: nil, statusMessage: "No valid response"))
                return
            }
            
            guard response.statusCode == 200  else {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    let dictionary = json as! [String: Any]
                    let message = dictionary["message"] as! String
                    completion(nil, APIError(statusCode: response.statusCode, statusMessage: message))
                }
                catch {
                    completion(nil, APIError(statusCode: response.statusCode, statusMessage: "Unable to process that request"))
                }
                return
            }
        
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                let array = json as! [[String: Any]]
                completion(array.map({T(dict: $0)}).compactMap {$0}, nil)
            }
            catch {
                completion(nil, APIError(statusCode: response.statusCode, statusMessage: "Unable to process that request"))
            }
        }
        task.resume()
    }
    
}

// MARK: - Mock API, for use in tests

final class APIClientMock: APIClient {
    
    func get<T>(urlString: String, completion: @escaping (Array<T>?, APIError?) -> Void) where T : APIAccessible {
        let bundle = Bundle.main
        
        let urlComponents = URLComponents(string: urlString)
        
        let url = bundle.url(forResource: (urlComponents?.path == "road" ? "All" : "Failure"), withExtension: "json")!
        let data = try! Data(contentsOf: url)
        let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments)
        
        if urlComponents?.path == "road" {
            let rawSuccessData = json as! [[String: Any]]
            completion(rawSuccessData.map({T(dict: $0)}).compactMap {$0}, nil)
        } else {
            let rawFailureData = json as! [String: Any]
            completion(nil, APIError(statusCode: 404, statusMessage: (rawFailureData["message"] as! String)))
        }
    }
    
}
