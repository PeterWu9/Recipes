//
//  BundleImageLoader.swift
//  ImageLoader
//
//  Created by Peter Wu on 1/29/25.
//


import UIKit
/// Simulates downloading data from network by loading from Bundle, with random loading time delay
/// introduced
public actor BundleImageLoader: ImageLoaderProtocol {
    // Max loading time in seconds
    private(set) var maxLoadingTime: Int
    private let cache: UIIMageDictionaryContainer
    public init(cache: UIIMageDictionaryContainer) {
        self.cache = cache
        self.maxLoadingTime = 5
    }
    
    public init(maxLoadingTime: Int = 5) {
        self.maxLoadingTime = maxLoadingTime
        self.cache = UIIMageDictionaryContainer()
    }
    
    public func fetch(_ url: String) async throws -> (String, Data) {
        // check if we have image data in cache
        guard let image = UIImage(
            named: url,
            in: Bundle.module, with: nil
        ) else {
            throw ImageLoaderError.invalidUrl(url)
        }
        
        if let imageData = cache.item(for: url)?.pngData() {
            return (url, imageData)
        } else {
            try await Task.sleep(for: .seconds(maxLoadingTime))
            cache.set(image, for: url)
            return (url, image.pngData()!)
        }
    }
}
