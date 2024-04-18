//
//  ImageCacheManager.swift
//  ImageCrowlerApp
//
//  Created by Sandeep kushwaha on 17/04/24.
//

import Foundation
import UIKit

class ImageCacheManager {
    static let shared = ImageCacheManager()
    private let memoryCache = NSCache<NSString, NSData>() // default eviction policy is LRU (Least recently used)
    private let fileManager = FileManager.default
    private let memoryCacheCapacity: Int = 500
    private let cacheDirectory = "ImageCache"
    
    private init() {
        memoryCache.totalCostLimit = memoryCacheCapacity
    }
    
    func getImage(forKey key: String) -> UIImage? {
        // get from in memory cache
        if let cachedImage = memoryCache.object(forKey: key as NSString) {
            return UIImage(data: cachedImage as Data)
        }
        // get from file manager
        if let filePath = filePath(for: key), let data = fileManager.contents(atPath: filePath), let image = UIImage(data: data) {
            memoryCache.setObject(data as NSData, forKey: key as NSString, cost: data.count)
            return image
        }
        return nil
    }
    
    func saveImage(_ image: UIImage, forKey key: String) {
        if let data = image.jpegData(compressionQuality: 0.5), let filePath = filePath(for: key) {
            memoryCache.setObject(data as NSData, forKey: key as NSString, cost: 1)
            fileManager.createFile(atPath: filePath, contents: data, attributes: nil)
        }
    }
    
    func removeImage(forKey key: String) {
        memoryCache.removeObject(forKey: key as NSString)
        if let filePath = filePath(for: key) {
            try? fileManager.removeItem(atPath: filePath)
        }
    }
    
    func clearCache() {
        memoryCache.removeAllObjects()
        guard let cacheDirectoryURL = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent(cacheDirectory) else {
            return
        }
        try? fileManager.removeItem(at: cacheDirectoryURL)
    }
    
    private func filePath(for key: String) -> String? {
        guard let cacheDirectoryURL = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent(cacheDirectory) else {
            return nil
        }
        if !fileManager.fileExists(atPath: cacheDirectoryURL.path) {
            try? fileManager.createDirectory(at: cacheDirectoryURL, withIntermediateDirectories: true, attributes: nil)
        }
        return cacheDirectoryURL.appendingPathComponent(key).path
    }
}
