//
//  RemoteRecipesRepository.swift
//  Recipes
//
//  Created by Peter Wu on 1/24/25.
//

import APIClient
import Foundation

public final class RemoteRecipesRepository: RecipesRepository {
    let host: String
    let recipesPath: String
    private let client: APIClient
    
    public init(
        host: String,
        recipesPath: String,
        urlSessionConfiguration: URLSessionConfiguration? = nil
    ) {
        self.host = host
        self.recipesPath = recipesPath
        let session = if let urlSessionConfiguration {
            URLSession(configuration: urlSessionConfiguration)
        } else {
            URLSession.shared
        }
        self.client = .init(session: session, host: host)
    }
    
    public func fetchAllRecipes() async throws -> [Recipe] {
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
    public static var defaultHost: String { "d3jbb8n5wk0qxi.cloudfront.net" }
    public static var allRecipesNoCache: RemoteRecipesRepository {
        .init(
            host: defaultHost,
            recipesPath: "recipes.json",
            urlSessionConfiguration: .ephemeral
        )
    }
    public static var allRecipes: RemoteRecipesRepository { .init(host: defaultHost, recipesPath: "recipes.json") }
    public static var malFormed: RemoteRecipesRepository { .init(host: defaultHost, recipesPath: "recipes-malformed.json") }
    public static var empty:RemoteRecipesRepository { .init(host: defaultHost, recipesPath: "recipes-empty.json") }
}
