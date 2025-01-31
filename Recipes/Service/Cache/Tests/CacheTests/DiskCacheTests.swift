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
    
    @Test("Cache item", arguments: ["TestItem.txt"])
    func cacheItem(item: String) throws {
        cache.removeAll()
        let itemData = try #require(item.data(using: .utf8))
        cache.set(itemData, for: item)
        let data = try #require(cache.item(for: item))
        #expect(itemData == data)
    }
    
    @Test func removeItem() throws {
        cache.removeAll()
        let testItemToRemove = "TestItemToRemove.txt"
        try cacheItem(item: testItemToRemove)
        cache.removeItem(for: testItemToRemove)
        #expect(cache.item(for: testItemToRemove) == nil)
    }
}
