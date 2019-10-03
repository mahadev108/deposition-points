//
//  Download.swift
//  deposition-points
//
//  Created by laGrunge on 10/3/19.
//  Copyright © 2019 MSU. All rights reserved.
//

import Foundation

protocol ImageDownloaderType {
    func imageData(path: String, completion: @escaping (Data?, Error?) -> Void)
}

final class ImageDownloader: ImageDownloaderType {
    
    let endPoint: String
    let session: URLSession
    
    init(endPoint: String) {
        self.endPoint = endPoint
        self.session = URLSession(configuration: .default)
    }
    
    func imageData(path: String, completion: @escaping (Data?, Error?) -> Void) {
        let absolutePath = "\(endPoint)/\(ScreenScale.main.dpi)/\(path)"
        guard let url = URL(string: absolutePath) else {
            completion(nil, DefaultError.urlError)
            return
        }
        let task = session.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                completion(nil, DefaultError.networkUnavailable)
                return
            }
            completion(data, nil)
        }
        task.resume()
    }
    
}
