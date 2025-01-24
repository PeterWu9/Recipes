//
//  RemoteRecipesRepository.swift
//  Recipes
//
//  Created by Peter Wu on 1/24/25.
//

import Foundation
import APIClient

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
        let response: RecipesResponseDTO = try await client.fetch(path: recipesPath)
        return response.recipes.map(Recipe.init(from:))
    }
}

extension RemoteRecipesRepository {
    static let defaultHost = "d3jbb8n5wk0qxi.cloudfront.net"
    static let allRecipes = RemoteRecipesRepository(host: defaultHost, recipesPath: "recipes.json")
    static let malFormed = RemoteRecipesRepository(host: defaultHost, recipesPath: "recipes-malformed.json")
    static let empty = RemoteRecipesRepository(host: defaultHost, recipesPath: "recipes-empty.json")
}
