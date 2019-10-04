//
//  Download.swift
//  deposition-points
//
//  Created by laGrunge on 10/3/19.
//  Copyright © 2019 MSU. All rights reserved.
//

import Foundation

protocol ImageDownloaderType {
    func imageData(path: String, completion: @escaping (Result<(Data, String), Error>) -> Void)
    func lastModifiedDate(at path: String, completion: @escaping (Result<String, Error>) -> Void)
}

final class ImageDownloader: ImageDownloaderType {
    
    let endPoint: String
    let session: URLSession
    
    init(endPoint: String) {
        self.endPoint = endPoint
        self.session = URLSession(configuration: .default)
    }
    
    func imageData(path: String, completion: @escaping (Result<(Data, String), Error>) -> Void) {
        let absolutePath = "\(endPoint)/\(ScreenScale.main.dpi)/\(path)"
        guard let url = URL(string: absolutePath) else {
            completion(.failure(DefaultError.urlError))
            return
        }
        let task = session.dataTask(with: url) { (data, response, error) in
            guard let data = data, let response = response as? HTTPURLResponse, let lastModifiedString = response.allHeaderFields["Last-Modified"] as? String else {
                completion(.failure(DefaultError.networkUnavailable))
                return
            }
            completion(.success((data, lastModifiedString)))
        }
        task.resume()
    }
    
    func lastModifiedDate(at path: String, completion: @escaping (Result<String, Error>) -> Void) {
        let absolutePath = "\(endPoint)/\(ScreenScale.main.dpi)/\(path)"
        guard let url = URL(string: absolutePath) else {
            completion(.failure(DefaultError.urlError))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "HEAD"
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(DefaultError.networkUnavailable))
                return
            }
            guard let lastModifiedString = response.allHeaderFields["Last-Modified"] as? String else {
                completion(.failure(DefaultError.wrongDataFormat))
                return
            }
            completion(.success(lastModifiedString))
        }
        task.resume()
    }
    
}
