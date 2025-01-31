//
//  RemoteImageLoader.swift
//  ImageLoader
//
//  Created by Peter Wu on 1/29/25.
//

import Cache
import Foundation

public actor RemoteImageLoader: ImageLoaderProtocol {
    private let cache: any CacheProtocol<String, Data>
    
    public init(cache: any CacheProtocol<String, Data>) {
        self.cache = cache
    }
    public func fetch(_ url: String) async throws -> (String, Data) {
        // check if we have image data in cache
        guard let unwrappedUrl = URL(string: url) else {
            throw ImageLoaderError.invalidUrl(url)
        }
        if let imageData = cache.item(for: url) {
            #if DEBUG
            print("\(unwrappedUrl) retrieved from cache")
            #endif
            return (unwrappedUrl.absoluteString, imageData)
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
            // cache data
            cache.set(data, for: url)
            // return data
            #if DEBUG
            print("\(unwrappedUrl) downloaded and saved to cache")
            #endif
            return (unwrappedUrl.absoluteString, data)
        }
    }
}
