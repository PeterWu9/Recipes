//
//  ImageLoaderConcurrencyTests.swift
//  ImageLoader
//
//  Created by Peter Wu on 1/29/25.
//

@testable import ImageLoader
import Foundation
import Testing

struct ImageLoaderConcurrencyTests {
    let cache: UIImageDictionaryContainer
    let loader: BundleImageLoader
    let imageFileNames: [String] = (1...100).map { "UIImage_\($0)" }
    
    init() {
        cache = .init()
        loader = .init(cache: cache)
    }

    @Test func parallelLoadingImages() async throws {
        let imageData = try await withThrowingTaskGroup(of: (String, Data).self) { group in
            var accumulated = [(String, Data)]()
            for name in imageFileNames {
                group.addTask {
                    return try await loader.fetch(name)
                }
            }
            
            for try await data in group {
                accumulated.append(data)
            }
            return accumulated
        }
        
        #expect(imageData.count == 100)
        let urls = Set(imageData.map { $0.0 })
        #expect(urls.count == 100)
    }

}
