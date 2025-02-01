//
//  RemoteImageLoaderTests.swift
//  ImageLoader
//
//  Created by Peter Wu on 1/29/25.
//

@testable import Cache
@testable import ImageLoader
import Foundation
import Testing
import UIKit

struct RemoteImageLoaderTests {
    let cache: InMemoryCache
    let loader: RemoteImageLoader
    
    init() {
        self.cache = InMemoryCache()
        self.loader = .init(cache: cache)
    }

    @Test func remoteImageFirstLoad() async throws {
        let urlString = "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg"
        let (_, image) = try await loader.fetch(urlString)
        let cachedData = try #require(
            cache.item(for: RemoteImageLoader.fileName(from: URL(string: urlString)!)!)
        )
        let cachedImage = try #require(UIImage(data: cachedData))
        // TODO: Research ways to reliably compare UIImage.
        // Comparing image size is by no means a robust way of testing image equality, but it appears to be
        // a difficult problem to try to compare UIImages. UIImage.pngData() does not appear to maintain all metadata
        #expect(cachedImage.size == image.size)
        
    }
}
