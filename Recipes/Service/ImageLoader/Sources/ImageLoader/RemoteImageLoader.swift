//
//  RemoteImageLoader.swift
//  ImageLoader
//
//  Created by Peter Wu on 1/29/25.
//

import Cache
import Foundation
import UIKit

public actor RemoteImageLoader: ImageLoaderProtocol {
    private let cache: any CacheProtocol<String, Data>
    private let transform: (Data) throws -> UIImage
    
    public init(
        transform: @escaping @Sendable (
            Data
        ) throws -> UIImage = RemoteImageLoader.transform
    ) {
        self.cache = InMemoryCache()
        self.transform = transform
    }

    public init(cache: any CacheProtocol<String, Data>) {
        self.cache = cache
        transform = RemoteImageLoader.transform
    }
    
    public func fetch(_ url: String) async throws -> (String, UIImage) {
        // check if we have image data in cache
        guard let unwrappedUrl = URL(string: url) else {
            throw ImageLoaderError.invalidUrl(url)
        }
        
        if let fileName = Self.fileName(from: unwrappedUrl),
           let imageData = cache.item(for: fileName) {
            print("\(unwrappedUrl) retrieved from cache, under \(fileName)")
            let image = try transform(imageData)
            return (unwrappedUrl.absoluteString, image)
        } else {
            // download data
            let (data, response) = try await URLSession.shared.data(for: .init(url: unwrappedUrl))
            
            // TODO: actor reentrancy
            guard let response = response as? HTTPURLResponse,
                  (200..<300).contains(
                    response.statusCode
                  ) else {
                throw ImageLoaderError.invalidServerResponse(response)
            }
            print("\(unwrappedUrl) downloaded")
            // cache data
            let image = try transform(data)
            if let fileName = Self.fileName(from: unwrappedUrl) {
                cache.set(data, for: fileName)
                print("\(unwrappedUrl) saved to cache, under \(fileName)")
            }
            return (unwrappedUrl.absoluteString, image)
        }
    }
    
    public static func fileName(from url: URL) -> String? {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return nil
        }
        return components.path.replacingOccurrences(of: "/", with: "@")
    }
}
