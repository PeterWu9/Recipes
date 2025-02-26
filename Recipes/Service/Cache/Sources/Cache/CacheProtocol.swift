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
    associatedtype Key: Hashable & Sendable
    associatedtype Value: Codable & Sendable
    func item(for key: Key) async -> Value?
    func set(_ item: Value, for key: Key) async
    func removeItem(for key: Key) async
    func removeAll() async
}
