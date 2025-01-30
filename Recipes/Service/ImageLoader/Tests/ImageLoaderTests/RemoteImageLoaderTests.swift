//
//  RemoteImageLoaderTests.swift
//  ImageLoader
//
//  Created by Peter Wu on 1/29/25.
//
@testable import ImageLoader
import Foundation
import Testing

struct RemoteImageLoaderTests {
    let cache: InMemoryCache
    let loader: RemoteImageLoader
    
    init() {
        self.cache = InMemoryCache()
        self.loader = .init(cache: cache)
    }

    @Test func remoteImageFirstLoad() async throws {
        let urlString = "https://d3jbb8n5wk0qxi.cloudfront.net/photos/b9ab0071-b281-4bee-b361-ec340d405320/small.jpg"
        let (_, data) = try await loader.fetch(urlString)
        let cachedData = try #require(cache.item(for: urlString))
        #expect(data == (cachedData as Data))
    }
}
