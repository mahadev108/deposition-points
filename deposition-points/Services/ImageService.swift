//
//  ImageService.swift
//  deposition-points
//
//  Created by laGrunge on 10/3/19.
//  Copyright © 2019 MSU. All rights reserved.
//

import Foundation
import CoreData

protocol ImageServiceType {
    func imageData(path: String, completion: @escaping (Result<Data, Error>) -> Void)
}

final class ImageService: ImageServiceType {
    let downloader: ImageDownloaderType
    let persistentContainer: NSPersistentContainer
    let repository: Repository<ImageResource>
    
    init(downloader: ImageDownloaderType, persistentContainer: NSPersistentContainer) {
        self.downloader = downloader
        self.repository = Repository(context: persistentContainer.viewContext)
        self.persistentContainer = persistentContainer
    }
    
    func imageData(path: String, completion: @escaping (Result<Data, Error>) -> Void) {
        let predicate = NSPredicate(format: "uniqueId == %@", path)
        if let resource = try? repository.query(with: predicate).first,
            let data = imageDataFromDisk(resource: resource) {
            completion(.success(data))
            downloader.lastModifiedDate(at: path) { (result) in
                switch result {
                case .success(let dateString):
                    if resource.lastModified != dateString {
                        self.downloadImage(path: path, completion: completion)
                    }
                case .failure(_):
                    break
                }
            }
            return
        }
        
        downloadImage(path: path, completion: completion)
    }
    
    private func downloadImage(path: String, completion: @escaping (Result<Data, Error>) -> Void) {
        downloader.imageData(path: path) { [unowned self] result in
            switch result {
            case .success(let tuple):
                let data = tuple.0
                let lastModified = tuple.1
                guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as URL else {
                    completion(.success(data))
                    return
                }
                completion(.success(data))
                do {
                    let fullPath = directory.appendingPathComponent(path)
                    try data.write(to: fullPath)
                    let resource = ImageResource(name: path, localPath: fullPath.absoluteString, lastModified: lastModified)
                    let taskContext = self.persistentContainer.newBackgroundContext()
                    taskContext.performAndWait {
                        resource.sync(in: taskContext)
                        do {
                            try taskContext.save()
                        } catch {
                            NSLog("Context save failed")
                        }
                        taskContext.reset()
                    }
                    
                } catch {
                    NSLog("File writing failed")
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func imageDataFromDisk(resource: ImageResource) -> Data? {
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) else { return nil }
        let url = URL(fileURLWithPath: directory.absoluteString).appendingPathComponent(resource.name)
        return try? Data(contentsOf: url)
    }
}
