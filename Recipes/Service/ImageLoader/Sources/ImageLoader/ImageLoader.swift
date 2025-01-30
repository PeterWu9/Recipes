import Foundation

public protocol ImageLoaderProtocol {
    associatedtype Cache: CacheProtocol
    init(cache: Cache)
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




