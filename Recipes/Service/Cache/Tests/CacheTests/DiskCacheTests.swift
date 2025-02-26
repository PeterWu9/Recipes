//
//  DiskCacheTests.swift
//  Cache
//
//  Created by Peter Wu on 1/31/25.
//

@testable import Cache
import Foundation
import Testing

@Suite struct DiskCacheTests {
    
    let fileManager = FileManager.default
    let cache: DiskCache
    
    init() {
        cache = try! .init(directoryName: "DiskCacheTest")
    }
    
    @Test("Cache item", arguments: ["TestItem.txt"])
    func cacheItem(item: String) async throws {
        await cache.removeAll()
        let itemData = try #require(item.data(using: .utf8))
        await cache.set(itemData, for: item)
        let data = try #require(await cache.item(for: item))
        #expect(itemData == data)
    }
    
    @Test func removeItem() async throws {
        await cache.removeAll()
        let testItemToRemove = "TestItemToRemove.txt"
        try await cacheItem(item: testItemToRemove)
        await cache.removeItem(for: testItemToRemove)
        await #expect(cache.item(for: testItemToRemove) == nil)
    }
    
    @Test func removeAll() async throws {
        await cache.removeAll()
        let items = (1...10).map({ String.init("TestRemoveAllItem_\($0).txt") })
        for item in items {
            let data = try #require(item.data(using: .utf8))
            await cache.set(data, for: item)
        }
        for item in items {
            await #expect(cache.item(for: item) != nil)
        }
        await cache.removeAll()
        for item in items {
            await #expect(cache.item(for: item) == nil)
        }
    }
}
