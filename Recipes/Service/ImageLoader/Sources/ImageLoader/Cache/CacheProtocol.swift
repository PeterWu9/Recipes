//
//  CacheProtocol.swift
//  ImageLoader
//
//  Created by Peter Wu on 1/29/25.
//

public protocol CacheProtocol: Sendable {
    associatedtype Key: Hashable
    associatedtype Value
    func item(for key: Key) -> Value?
    func set(_ item: Value, for key: Key)
    func removeItem(for key: Key)
    func removeAll()
}
