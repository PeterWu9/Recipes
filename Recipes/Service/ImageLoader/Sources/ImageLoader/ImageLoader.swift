import Foundation

public protocol ImageLoaderProtocol {
    /// Fetches image from a given url string, and returns `Data` that could be used to reconstruct an image
    func fetch(_ url: String) async throws -> (String, Data)
    /*
     TODO: batch fetch operation?
     TODO: clear all operation?
     TODO: remove image (by url) operation?
     TODO: Disk cache module
     TODO: size limit
     TODO: eviction
    */
}

enum ImageLoaderError: Error {
    case invalidUrl(String)
    case invalidServerResponse(URLResponse)
}

public actor RemoteImageLoader: ImageLoaderProtocol {
    private let cache = NSCache<NSURL, NSData>()
    
    public func fetch(_ url: String) async throws -> (String, Data) {
        // check if we have image data in cache
        guard let url = URL(string: url) else {
            throw ImageLoaderError.invalidUrl(url)
        }
        if let imageData = cache.object(forKey: url as NSURL) {
            return (url.absoluteString, imageData as Data)
        } else {
            // download data
            let (data, response) = try await URLSession.shared.data(for: .init(url: url))
            guard let response = response as? HTTPURLResponse,
                    (200..<300).contains(
                response.statusCode
            ) else {
                throw ImageLoaderError.invalidServerResponse(response)
            }
            // cache data
            cache.setObject(data as NSData, forKey: url as NSURL)
            // return data
            return (url.absoluteString, data)
        }
    }
}

import UIKit
/// Simulates downloading data from network by loading from Bundle, with random loading time delay
/// introduced
public actor BundleImageLoader: ImageLoaderProtocol {
    private var cache = [String: UIImage]()
    // Max loading time in seconds
    private(set) var maxLoadingTime: Int
    
    init(maxLoadingTime: Int = 5) {
        self.maxLoadingTime = maxLoadingTime
    }
    
    public func fetch(_ url: String) async throws -> (String, Data) {
        // check if we have image data in cache
        guard let image = UIImage(
            named: url,
            in: Bundle.module, with: nil
        ) else {
            throw ImageLoaderError.invalidUrl(url)
        }
        
        if let imageData = cache[url]?.pngData() {
            return (url, imageData)
        } else {
            try await Task.sleep(for: .seconds(maxLoadingTime))
            cache[url] = image
            return (url, image.pngData()!)
        }
    }
}
