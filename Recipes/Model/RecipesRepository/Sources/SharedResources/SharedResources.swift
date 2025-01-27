//
//  SharedResources.swift
//  RecipesRepository
//
//  Created by Peter Wu on 1/25/25.
//

import Foundation

public enum SharedResources {
    enum ResourceError: Error {
        case unableToLocateResource(
            name: String,
            extension: String
        )
    }
    private static let decoder = JSONDecoder()
    
    public static func decode<T: Decodable>(type: T.Type, fileName: String, fileExtension: String) throws -> T {
        guard let url = url(fileName: fileName, fileExtension: fileExtension) else {
            throw ResourceError
                .unableToLocateResource(
                    name: fileName,
                    extension: fileExtension
                )
        }
        // Fetch data from resource
        let data = try Data(contentsOf: url)
        // Deserialize data and decode into Recipes Response DTO
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    }
    
    public static func url(fileName: String, fileExtension: String) -> URL? {
        // Bundle.module is only available when the target in manifest include resources
#if SWIFT_PACKAGE
        Bundle.module.url(forResource: fileName, withExtension: fileExtension)
#else
        url = url(forResource: fileName, withExtension: fileExtension)
#endif
    }
}
