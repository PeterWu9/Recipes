//
//  UIIMageDictionaryContainer.swift
//  ImageLoader
//
//  Created by Peter Wu on 1/29/25.
//

import UIKit
import Synchronization

public final class UIIMageDictionaryContainer: CacheProtocol {
    let lock = Mutex<[String: UIImage]>([:])
    public init() { }
    
    public func item(for key: String) -> UIImage? {
        lock.withLock { $0[key] }
    }
    public func set(_ item: UIImage, for key: String) {
        lock.withLock {
            $0[key] = item
        }
    }
    public func removeAll() {
        lock.withLock { $0.removeAll() }
    }
    public func removeItem(for key: String) {
        lock.withLock { $0[key] = nil }
    }
}
