//
//  ImageLoadManager.swift
//  ImageCrowlerApp
//
//  Created by Sandeep kushwaha on 17/04/24.
//

import Foundation
import UIKit

class ImageLoadManager {
    static let shared = ImageLoadManager()
    private let imageLoadingQueue = OperationQueue()
    private var apiService = APIFetchServiceImpl<FeedDataModel>()
    private init() {
        imageLoadingQueue.maxConcurrentOperationCount = 100
    }
    func fetchImageData(url: URL, completion: @escaping (UIImage?) -> Void) -> Operation {
        let operation = ImageLoadOperation(url: url, completion: completion)
        imageLoadingQueue.addOperation(operation)
        return operation
    }
}

fileprivate class ImageLoadOperation: Operation {
    let url: URL
    let completion: (UIImage?) -> Void
    
    init(url: URL, completion: @escaping (UIImage?) -> Void) {
        self.url = url
        self.completion = completion
        super.init()
    }
    
    override func main() {
        // Check if the operation is cancelled before starting
        if isCancelled {
            return
        }
        // first get from cache
        if let image = ImageCacheManager.shared.getImage(forKey: url.absoluteString) {
            completion(image)
        }
        if isCancelled {
            return
        }
        // Load image from URL
        if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
            ImageCacheManager.shared.saveImage(image, forKey: url.absoluteString)
            if isCancelled {
                return
            }
            completion(image)
        } else {
            completion(nil)
        }
    }
}
