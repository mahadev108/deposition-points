//
//  Network.swift
//  deposition-points
//
//  Created by laGrunge on 9/29/19.
//  Copyright © 2019 MSU. All rights reserved.
//

import Foundation

final class Network<T: Decodable> {
    
    private let endPoint: String
    private let session: URLSession
    
    init(endPoint: String) {
        self.endPoint = endPoint
        self.session = URLSession(configuration: .default)
    }
    
    func getItems(path: String, parameters: [AnyHashable: Any]?, completion: @escaping ([T]?, Error?) -> Void) {
        let absolutePath = "\(endPoint)/\(path)"
        guard var components = URLComponents(string: absolutePath) else {
            print("Networking Error: Wrong request path: \(absolutePath)")
            completion(nil, DefaultError.urlError)
            return
        }
        components.queryItems = parameters?.map({ (dict) -> URLQueryItem in
            return URLQueryItem(name: "\(dict.key)", value: "\(dict.value)")
        })
        guard let url = components.url else {
            print("Networking Error: Wrong request parameters: \(parameters ?? [:])")
            completion(nil, DefaultError.urlError)
            return
        }
        let task = session.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                print("Networking Error: Server unavailable")
                completion(nil, DefaultError.networkUnavailable)
                return
            }
            do {
                let decoder = JSONDecoder()
                let serializedResponse = try decoder.decode(DefaultResponse<T>.self, from: data)
                print("Network request at path \(path): SUCCESS")
                completion(serializedResponse.payload, nil)
            } catch {
                print("Networking Error: Wrong response format")
                completion(nil, DefaultError.wrongDataFormat)
            }
        }
        task.resume()
    }
}
