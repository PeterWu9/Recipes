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
        transform: @escaping @Sendable (Data) throws -> UIImage = RemoteImageLoader.transform
    ) {
        self.cache = InMemoryCache()
        self.transform = transform
    }

    public init(
        cache: any CacheProtocol<String, Data>,
        transform: @escaping @Sendable (Data) throws -> UIImage = RemoteImageLoader.transform
    ) {
        self.cache = cache
        self.transform = transform
    }
    
    
    /// Fetches an image from URL
    /// - Parameter url: URL of the image resource
    /// - Returns: The fetched image and the url source
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
                // MARK: Will suspend.  Access to cache is serialized.
                cache.set(data, for: fileName)
                print("\(unwrappedUrl) saved to cache, under \(fileName)")
            }
            return (unwrappedUrl.absoluteString, image)
        }
    }
    
    
    /// Parses file name from URL.  The parser replaces `/` character with `@` character to avoid conflict when caching in file system
    /// - Parameter url: URL for the image resource
    /// - Returns: File name extracted from the URL, if successfully parsed
    public static func fileName(from url: URL) -> String? {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return nil
        }
        return components.path.replacingOccurrences(of: "/", with: "@")
    }
}
