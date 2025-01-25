//
//  Bundle+.swift
//  Recipes
//
//  Created by Peter Wu on 1/22/25.
//

import Foundation

public extension Bundle {
    enum BundleError: Error {
        case unableToLocateResource(
            name: String,
            extension: String
        )
    }
    func decode<T: Decodable>(type: T.Type, fileName: String, fileExtension: String) throws -> T {
        guard let url = url(forResource: fileName, withExtension: fileExtension) else {
            throw BundleError
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
}
