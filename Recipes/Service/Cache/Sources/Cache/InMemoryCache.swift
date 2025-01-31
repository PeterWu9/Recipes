//
//  InMemoryCache.swift
//  ImageLoader
//
//  Created by Peter Wu on 1/29/25.
//

import Foundation

// `NSCache` is thread-safe, ok to declare conformance to Sendable requirement without compiler enforcement
public final class InMemoryCache: @unchecked Sendable, CacheProtocol {
    private let cache = NSCache<NSString, NSData>()
    public func item(for key: String) -> Data? {
        return cache.object(forKey: key as NSString) as? Data
    }
    public func set(_ item: Data, for key: String) {
        cache.setObject(item as NSData, forKey: key as NSString)
    }
    public func removeAll() {
        cache.removeAllObjects()
    }
    public func removeItem(for key: String) {
        cache.removeObject(forKey: key as NSString)
    }
}
