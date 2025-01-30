//
//  NSCacheContainer.swift
//  ImageLoader
//
//  Created by Peter Wu on 1/29/25.
//

import Foundation

// `NSCache` is thread-safe, ok to declare conformance to Sendable requirement without compiler enforcement
public final class NSCacheContainer: @unchecked Sendable, CacheProtocol {
    private let cache = NSCache<NSURL, NSData>()
    public init() { }
    public func item(for key: NSURL) -> NSData? {
        cache.object(forKey: key)
    }
    public func set(_ item: NSData, for key: NSURL) {
        cache.setObject(item, forKey: key)
    }
    public func removeAll() {
        cache.removeAllObjects()
    }
    public func removeItem(for key: NSURL) {
        cache.removeObject(forKey: key)
    }
}
