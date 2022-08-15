//
//  ImageLoader.swift
//  GluUpMovyDB
//
//  Created by Denis on 11.08.2022.
//

import UIKit

typealias ImageLoadingCompletion = (UIImage?) -> ()

class ImageLoader {
    
    // MARK: - Singleton
    
    static let shared = ImageLoader()
    
    // MARK: - Constants
    
    private let postersRoot = "https://image.tmdb.org/t/p/w185"
    
    private let maxSimultaneousDownloads = 7
    
    // MARK: - Properties
    
    private var cachedImages = [String: UIImage]()
    private var completions = [String: [ImageLoadingCompletion]]()
    private var downloadTasks = [String: URLSessionDataTask]()
    private var queuedDownloadPaths = [String]()

    // MARK: - Public
    
    func getImage(from path: String, completion: @escaping ImageLoadingCompletion) {
        if let cachedImage = cachedImages[path] {
            completion(cachedImage)
            
            return
        }
        
        if completions[path] != nil {
            completions[path]?.append(completion)
            
            return
        } else {
            completions[path] = [completion]
        }
        
        startOrQueueTask(for: path)
    }
    
    // MARK: - Private
    
    private func startOrQueueTask(for path: String) {
        if downloadTasks.count >= maxSimultaneousDownloads {
            queuedDownloadPaths.append(path)
            
            return
        }
        
        let urlString = postersRoot + path
        guard let url = URL(string: urlString) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, _, error) in
            guard let self = self else {
                return
            }
            
            guard error == nil,
                  let data = data,
                  let image = UIImage(data: data) else {
                self.performCompletions(for: path, image: nil)
                
                return
            }

            self.performCompletions(for: path, image: image)
            self.downloadTasks.removeValue(forKey: path)
            self.checkQueuedTasks()
        }
        
        downloadTasks[path] = task
        task.resume()
    }
    
    private func performCompletions(for path: String, image: UIImage?) {
        for completion in completions[path] ?? [] {
            DispatchQueue.main.async {
                completion(image)
            }
        }
        
        completions.removeValue(forKey: path)
    }
    
    private func checkQueuedTasks() {
        guard let path = queuedDownloadPaths.first else {
            return
        }
        
        queuedDownloadPaths.removeFirst()
        startOrQueueTask(for: path)
    }
}
