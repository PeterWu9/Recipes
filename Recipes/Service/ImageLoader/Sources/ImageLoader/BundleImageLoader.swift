//
//  BundleImageLoader.swift
//  ImageLoader
//
//  Created by Peter Wu on 1/29/25.
//

import Cache
import UIKit
/// Simulates downloading data from network by loading from Bundle, with random loading time delay
/// introduced for testing purposes
public actor BundleImageLoader: ImageLoaderProtocol {
    /// Max loading time in seconds
    public var maxLoadingTime: Int = 5
    private let cache: any CacheProtocol<String, Data>
    public init(cache: any CacheProtocol<String, Data>) {
        self.cache = cache
    }
    
    public init(maxLoadingTime: Int, cache: any CacheProtocol<String, Data>) {
        self.maxLoadingTime = maxLoadingTime
        self.cache = cache
    }
    
    public func fetch(_ url: String) async throws -> (String, Data) {
        // check if we have image data in cache
        guard let image = UIImage(
            named: url,
            in: Bundle.module, with: nil
        ) else {
            throw ImageLoaderError.invalidUrl(url)
        }
        
        if let imageData = cache.item(for: url) {
            return (url, imageData)
        } else {
            try await Task.sleep(for: .seconds(maxLoadingTime))
            let data = image.pngData()!
            cache.set(data, for: url)
            return (url, data)
        }
    }
}
