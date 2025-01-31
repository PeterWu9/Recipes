//
//  CacheProtocol.swift
//  ImageLoader
//
//  Created by Peter Wu on 1/29/25.
//
import Foundation

public protocol CacheProtocol<Key, Value>: Sendable {
    // TODO: Memory size
    // TODO: Cache eviction
    associatedtype Key: Hashable
    associatedtype Value: Codable
    func item(for key: Key) -> Value?
    func set(_ item: Value, for key: Key)
    func removeItem(for key: Key)
    func removeAll()
}
