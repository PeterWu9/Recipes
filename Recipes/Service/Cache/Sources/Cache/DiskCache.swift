//
//  DiskCache.swift
//  Cache
//
//  Created by Peter Wu on 1/30/25.
//

import Foundation

// `FileManager` is thread-safe, ok to declare conformance to Sendable requirement without compiler enforcement
public final class DiskCache: @unchecked Sendable, CacheProtocol {
    
    private let fileManager: FileManager
    private let appCacheDirectory: URL
    
    public init(fileManager: FileManager = .default, directoryName: String) throws {
        // TODO: Separate module for File IO
        self.fileManager = fileManager
        let cacheDirectoryUrl = try fileManager.url(
            for: .cachesDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )
        let appCacheDirectory = cacheDirectoryUrl.appending(
            path: directoryName,
            directoryHint: .isDirectory
        )
        if !fileManager.fileExists(atPath: appCacheDirectory.relativePath) {
            try fileManager
                .createDirectory(
                    at: appCacheDirectory,
                    withIntermediateDirectories: false
                )
        }
        self.appCacheDirectory = appCacheDirectory
    }
    
    
    // construct URL from key
    
    public func item(for key: String) -> Data? {
        print(#function, key)
        do {
            return try Data(contentsOf: fileUrl(for: key))
        } catch {
            print(
                "Unable to retrieve data for \(key) from \(appCacheDirectory.absoluteString) due to \(error.localizedDescription)"
            )
            return nil
        }
    }

    public func set(_ item: Data, for key: String) {
        print(#function, key)
        let url = fileUrl(for: key)
        do {
            try item.write(to: url, options: .atomic)
        } catch {
            print("Unable to write data to \(url.path()) due to \(error.localizedDescription)")
        }
    }

    public func removeItem(for key: String) {
        print(#function, key)
        do {
            try fileManager.removeItem(at: fileUrl(for: key))
        } catch {
            print(
                "Unable to remove data for \(key) from \(appCacheDirectory.absoluteString) due to \(error.localizedDescription)"
            )
        }
    }

    public func removeAll() {
        print(#function)
        do {
            let fileUrls = try fileManager.contentsOfDirectory(
                at: appCacheDirectory,
                includingPropertiesForKeys: []
            )
            for url in fileUrls {
                do {
                    try fileManager.removeItem(at: url)
                } catch {
                    print(
                        "Unable to remove files in directory \(appCacheDirectory.absoluteString) due to \(error.localizedDescription)"
                    )
                    continue
                }
            }
        } catch {
            print(
                "Unable to remove files in directory \(appCacheDirectory.absoluteString) due to \(error.localizedDescription)"
            )
        }
    }
    
    private func fileUrl(for key: String) -> URL {
        appCacheDirectory.appending(path: key, directoryHint: .notDirectory)
    }
}
