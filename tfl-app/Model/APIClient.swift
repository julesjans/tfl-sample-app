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
    static func get(id: String, api: APIClient, completion: @escaping (Bool, Array<Self>?, APIError?) -> Void) {
        guard let param = id.lowercased().addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            assertionFailure()
            return
        }
        api.get(urlString: "\(String(describing: Self.self).capitalized)/\(param)", completion: completion)
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
    func get<T:APIAccessible>(urlString: String, completion: @escaping (Bool, Array<T>?, APIError?) -> Void)
}

struct APIError: Error {
    
    let statusCode: Int?
    let statusMessage: String?
    
}

// MARK: - Live API

final class APIClientLive: APIClient {

    func get<T:APIAccessible>(urlString: String, completion: @escaping (Bool, Array<T>?, APIError?) -> Void) {
        
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
                completion(false, nil, APIError(statusCode: nil, statusMessage: error!.localizedDescription))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(false, nil, APIError(statusCode: nil, statusMessage: "Response error"))
                return
            }
            
            guard response.statusCode == 200  else {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    let dictionary = json as! [String: Any]
                    let message = dictionary["message"] as! String
                    completion(false, nil, APIError(statusCode: response.statusCode, statusMessage: message))
                }
                catch {
                    completion(false, nil, APIError(statusCode: response.statusCode, statusMessage: "Unable to parse error message"))
                }
                return
            }
        
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                let array = json as! [[String: Any]]
                completion(true, array.map({T(dict: $0)}).compactMap {$0}, nil)
            }
            catch {
                completion(false, nil, APIError(statusCode: response.statusCode, statusMessage: "Unable to parse JSON response"))
            }
        }
        task.resume()
    }
    
}
