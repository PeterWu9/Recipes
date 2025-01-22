//
//  InMemoryRecipesRepository.swift
//  Recipes
//
//  Created by Peter Wu on 1/22/25.
//

import Foundation

final class InMemoryRecipesRepository: RecipesRepository {
    private var allRecipes: [Recipe] {
        get throws {
            try Bundle.main.decode(
                type: RecipesResponseDTO.self,
                fileName: "RecipesResponseAllRecipes",
                fileExtension: ".json"
            )
            .recipes
            .map(Recipe.init(from:))
        }
    }
    func fetchAllRecipes() async throws -> [Recipe] {
        try allRecipes
    }
    
    func fetch(by id: Recipe.ID) async throws -> Recipe {
        try allRecipes.first(where: { $0.id == id })!
    }
}
