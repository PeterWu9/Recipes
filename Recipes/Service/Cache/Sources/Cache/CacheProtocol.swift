//
//  CacheProtocol.swift
//  ImageLoader
//
//  Created by Peter Wu on 1/29/25.
//
import Foundation

public protocol CacheProtocol: Sendable {
    init()
    func item(for key: String) -> Data?
    func set(_ item: Data, for key: String)
    func removeItem(for key: String)
    func removeAll()
}
