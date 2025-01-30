//
//  RemoteImageLoader.swift
//  ImageLoader
//
//  Created by Peter Wu on 1/29/25.
//

import Foundation

public actor RemoteImageLoader: ImageLoaderProtocol {
    private let cache: NSCacheContainer
    
    public init(cache: NSCacheContainer) {
        self.cache = cache
    }
    public func fetch(_ url: String) async throws -> (String, Data) {
        // check if we have image data in cache
        guard let url = URL(string: url) else {
            throw ImageLoaderError.invalidUrl(url)
        }
        if let imageData = cache.item(for: url as NSURL){
            #if DEBUG
            print("\(url) retrieved from cache")
            #endif
            return (url.absoluteString, imageData as Data)
        } else {
            // download data
            let (data, response) = try await URLSession.shared.data(for: .init(url: url))
            guard let response = response as? HTTPURLResponse,
                    (200..<300).contains(
                response.statusCode
            ) else {
                throw ImageLoaderError.invalidServerResponse(response)
            }
            // cache data
            cache.set(data as NSData, for: url as NSURL)
            // return data
            #if DEBUG
            print("\(url) downloaded and saved to cache")
            #endif
            return (url.absoluteString, data)
        }
    }
}
