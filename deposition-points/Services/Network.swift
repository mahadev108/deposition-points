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
    
    func getItems(path: String, parameters: [AnyHashable: Any]?, completion: @escaping (Result<[T], Error>) -> Void) {
        let absolutePath = "\(endPoint)/\(path)"
        guard var components = URLComponents(string: absolutePath) else {
            completion(.failure(DefaultError.urlError))
            return
        }
        components.queryItems = parameters?.map({ (dict) -> URLQueryItem in
            return URLQueryItem(name: "\(dict.key)", value: "\(dict.value)")
        })
        guard let url = components.url else {
            completion(.failure(DefaultError.urlError))
            return
        }
        let task = session.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                completion(.failure(DefaultError.networkUnavailable))
                return
            }
            do {
                let decoder = JSONDecoder()
                let serializedResponse = try decoder.decode(DefaultResponse<T>.self, from: data)
                completion(.success(serializedResponse.payload))
            } catch {
                completion(.failure(DefaultError.wrongDataFormat))
            }
        }
        task.resume()
    }
}
