//
//  RemoteRecipesRepository.swift
//  Recipes
//
//  Created by Peter Wu on 1/24/25.
//

import APIClient
import Foundation

final class RemoteRecipesRepository: RecipesRepository {
    let host: String
    let recipesPath: String
    private let client: APIClient
    
    init(host: String, recipesPath: String) {
        self.host = host
        self.recipesPath = recipesPath
        self.client = .init(host: host)
    }
    
    func fetchAllRecipes() async throws -> [Recipe] {
        do {
            let response: RecipesResponseDTO = try await client.fetch(path: recipesPath)
            return response.recipes.map(Recipe.init(from:))
        } catch let APIClient.APIError.errorDecoding(data, description, decodingError) {
            // deserialize jsonstring from data
            let jsonObject = try JSONSerialization.jsonObject(with: data)
            let jsonData = try JSONSerialization.data(
                withJSONObject: jsonObject,
                options: .prettyPrinted
            )
            let jsonString = String.init(data: jsonData, encoding: .utf8)
            let errorString = """
            Error Decoding Data! \n
            Description: \(description)\n
            Data: \n
            \(jsonString ?? "")
            """
            
            throw RemoteRecipesError(
                error: decodingError,
                description: errorString
            )
        } catch {
            throw error
        }
    }
    
    struct RemoteRecipesError: Error {
        let error: Error
        let description: String
    }
}

extension RemoteRecipesRepository {
    static var defaultHost: String { "d3jbb8n5wk0qxi.cloudfront.net" }
    static var allRecipes: RemoteRecipesRepository { .init(host: defaultHost, recipesPath: "recipes.json") }
    static var malFormed: RemoteRecipesRepository { .init(host: defaultHost, recipesPath: "recipes-malformed.json") }
    static var empty:RemoteRecipesRepository { .init(host: defaultHost, recipesPath: "recipes-empty.json") }
}
