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
            let fileName = if case .allRecipes = mode {
                "RecipesResponseAllRecipes"
            } else {
                "RecipesResponseMalformed"
            }

            return try SharedResources.decode(
                type: RecipesResponseDTO.self,
                fileName: fileName,
                fileExtension: ".json"
            )
            .recipes
            .map(Recipe.init(from:))
        }
    }
    let mode: Mode
    
    public init(mode: Mode) {
        self.mode = mode
    }
    
    public enum Mode: Sendable {
        case allRecipes, empty, malformed
    }
    
    public func fetchAllRecipes() async throws -> [Recipe] {
        switch mode {
        case .allRecipes, .malformed:
            try allRecipes
        case .empty:
            []
        }
    }
}
