//
//  DiskCache.swift
//  Cache
//
//  Created by Peter Wu on 1/30/25.
//

import Foundation

// `FileManager` is thread-safe, ok to declare conformance to Sendable requirement without compiler enforcement
public actor DiskCache: CacheProtocol {
    
    private let fileManager: FileManager
    private let appCacheDirectory: URL
    let ioQueue = DispatchSerialQueue(label: "FileIO")
    
    public nonisolated var unownedExecutor: UnownedSerialExecutor {
        ioQueue.asUnownedSerialExecutor()
    }
    
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
    
    public func item(for key: String) async -> Data? {
        print(#function, key)
        let url = await urlStore[key]
        guard fileManager.fileExists(atPath: url.path()) else {
            print("Data not found for \(key)")
            return nil
        }
        do {
            if let data = await urlStore.data(forKey: key) {
                print("Retrieved from URL Cache")
                return data
            } else {
                let data = try Data(contentsOf: url)
                // cache data to URL resource
                await urlStore.cache(data, forKey: key)
                return data
            }
        } catch {
            print(
                "Unable to retrieve data for \(key) from \(appCacheDirectory.absoluteString) due to \(error.localizedDescription)"
            )
            return nil
        }
    }

    public func set(_ item: Data, for key: String) async {
        print(#function, key)
        let url = await urlStore[key]

        do {
            try item.write(to: url, options: .atomic)
            await urlStore.cache(item, forKey: key)
        } catch {
            print("Unable to write data to \(url.path()) due to \(error.localizedDescription)")
        }
    }

    public func removeItem(for key: String) async {
        print(#function, key)
        do {
            try await fileManager.removeItem(at: urlStore[key])
            await urlStore.removeFromCache(key: key)
        } catch {
            print(
                "Unable to remove data for \(key) from \(appCacheDirectory.absoluteString) due to \(error.localizedDescription)"
            )
        }
    }

    public func removeAll() async {
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
            await urlStore.removeAll()
        } catch {
            print(
                "Unable to remove files in directory \(appCacheDirectory.absoluteString) due to \(error.localizedDescription)"
            )
        }
    }
    
    private lazy var urlStore = URLStore(directory: appCacheDirectory)
    
    actor URLStore {
        var cache = [String: URL]()
        var appCacheDirectory: URL
        init(directory: URL) {
            self.appCacheDirectory = directory
        }
        
        subscript(key: String) -> URL {
            if let url = cache[key] {
                return url
            } else {
                let url = fileUrl(for: key)
                cache[key] = url
                return url
            }
        }
        
        func data(forKey key: String) -> Data? {
            let resourceKey = URLResourceKey(key)
            let cached = try? self.cache[key]?.resourceValues(forKeys: [resourceKey])
            let dataValue = cached?.allValues[resourceKey]
            return dataValue as? Data
        }
        
        func cache(_ data: Data, forKey key: String) {
            let resourceKey = URLResourceKey(key)
            cache[key]?.setTemporaryResourceValue(data, forKey: resourceKey)
        }
        
        func removeFromCache(key: String) {
            cache[key] = nil
        }
        
        func removeAll() {
            cache = [:]
        }
        
        private func fileUrl(for key: String) -> URL {
            appCacheDirectory.appending(path: key, directoryHint: .notDirectory)
        }
    }
    
}
