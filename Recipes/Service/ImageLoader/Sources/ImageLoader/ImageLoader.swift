import Cache
import Foundation

public protocol ImageLoaderProtocol: Sendable {
    /// Fetches image from a given url string, and returns `Data` that could be used to reconstruct an image
    func fetch(_ url: String) async throws -> (String, Data)
}

enum ImageLoaderError: Error {
    case invalidUrl(String)
    case invalidServerResponse(URLResponse)
}




