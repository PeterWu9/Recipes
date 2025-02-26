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
    private var transform: (Data) throws -> UIImage
    public init(transform: @escaping @Sendable (Data) throws -> UIImage) {
        self.transform = transform
        self.cache = InMemoryCache()
    }
    public init(
        cache: any CacheProtocol<String, Data>,
        transform: @escaping @Sendable (Data) throws -> UIImage = BundleImageLoader.transform
    ) {
        self.cache = cache
        self.transform = transform
    }
    
    public init(
        maxLoadingTime: Int,
        cache: any CacheProtocol<String, Data>,
        transform: @escaping @Sendable (Data) throws -> UIImage = BundleImageLoader.transform
    ) {
        self.maxLoadingTime = maxLoadingTime
        self.cache = cache
        self.transform = transform
    }
    
    public func fetch(_ url: String) async throws -> (String, UIImage) {
        // check if we have image data in cache
        guard let image = UIImage(
            named: url,
            in: Bundle.module, with: nil
        ) else {
            throw ImageLoaderError.invalidUrl(url)
        }
        
        if let imageData = await cache.item(for: url) {
            let image = try transform(imageData)
            return (url, image)
        } else {
            try await Task.sleep(for: .seconds(maxLoadingTime))
            let data = image.pngData()!
            let image = try transform(data)
            await cache.set(data, for: url)
            return (url, image)
        }
    }
    
}
