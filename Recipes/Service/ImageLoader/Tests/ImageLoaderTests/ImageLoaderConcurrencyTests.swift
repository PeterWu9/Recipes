//
//  ImageLoaderConcurrencyTests.swift
//  ImageLoader
//
//  Created by Peter Wu on 1/29/25.
//

@testable import Cache
@testable import ImageLoader
import Foundation
import Testing
import UIKit

struct ImageLoaderConcurrencyTests {
    let loader = BundleImageLoader(cache: InMemoryCache())
    let imageFileNames: [String] = (1...100).map { "UIImage_\($0)" }
    

    @Test func parallelLoadingImages() async throws {
        let images = try await withThrowingTaskGroup(
            of: (String, UIImage).self
        ) { group in
            var accumulated = [(String, UIImage)]()
            for name in imageFileNames {
                group.addTask {
                    return try await loader.fetch(name)
                }
            }
            
            for try await image in group {
                accumulated.append(image)
            }
            return accumulated
        }
        
        #expect(images.count == 100)
        let urls = Set(images.map { $0.0 })
        #expect(urls.count == 100)
    }

}
