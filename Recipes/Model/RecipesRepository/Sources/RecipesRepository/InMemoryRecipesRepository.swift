//
//  InMemoryRecipesRepository.swift
//  Recipes
//
//  Created by Peter Wu on 1/22/25.
//

import Foundation
import SharedResources

public final class InMemoryRecipesRepository: RecipesRepository {
    private var allRecipes: [Recipe] {
        get throws {
            try SharedResources.decode(
                type: RecipesResponseDTO.self,
                fileName: "RecipesResponseAllRecipes",
                fileExtension: ".json"
            )
            .recipes
            .map(Recipe.init(from:))
        }
    }
    public init() { }
    public func fetchAllRecipes() async throws -> [Recipe] {
        try allRecipes
    }
}
