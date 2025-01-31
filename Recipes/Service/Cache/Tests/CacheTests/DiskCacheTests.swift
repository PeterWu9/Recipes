//
//  DiskCacheTests.swift
//  Cache
//
//  Created by Peter Wu on 1/31/25.
//

@testable import Cache
import Foundation
import Testing

struct DiskCacheTests {
    
    let fileManager = FileManager.default
    let cache: DiskCache
    
    init() {
        cache = try! .init(fileManager: fileManager, directoryName: "DiskCacheTest")
    }
    
    @Test func cacheItem() async throws {
        cache.removeAll()
        let item = "TestItem.txt"
        let itemData = try #require(item.data(using: .utf8))
        cache.set(itemData, for: item)
        let data = try #require(cache.item(for: item))
        #expect(itemData == data)
    }
}
