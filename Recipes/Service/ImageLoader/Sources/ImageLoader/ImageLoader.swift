import Cache
import Foundation

public protocol ImageLoaderProtocol<ImageType>: Sendable {
    associatedtype ImageType: Sendable
    init(transform: @Sendable @escaping (Data) throws -> ImageType)
    /// Fetches image from a given url string, and returns an image of `ImageType`
    func fetch(_ url: String) async throws -> (String, ImageType)
}

enum ImageLoaderError: Error {
    case invalidUrl(String)
    case invalidServerResponse(URLResponse)
    case failToConvertImageFrom(Data)
}




