//
//  ImageService.swift
//  deposition-points
//
//  Created by laGrunge on 10/3/19.
//  Copyright © 2019 MSU. All rights reserved.
//

import Foundation

protocol ImageServiceType {
    func imageData(path: String, completion: @escaping (Data?, Error?) -> Void)
}

final class ImageService: ImageServiceType {
    let downloader: ImageDownloaderType
    
    init(downloader: ImageDownloaderType) {
        self.downloader = downloader
    }
    
    func imageData(path: String, completion: @escaping (Data?, Error?) -> Void) {
        downloader.imageData(path: path, completion: completion)
    }
}
