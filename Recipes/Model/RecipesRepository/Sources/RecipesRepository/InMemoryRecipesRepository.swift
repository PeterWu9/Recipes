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
            let fileName = if case .allRecipes = configuration.mode {
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
    let configuration: Configuration
    
    public init(configuration: Configuration) {
        self.configuration = configuration
    }
    
    public struct Configuration: Sendable {
        let delay: ContinuousClock.Duration
        let mode: Mode
        
        public init(delay: ContinuousClock.Duration = .milliseconds(500), mode: Mode) {
            self.delay = delay
            self.mode = mode
        }
    }
    public enum Mode: Sendable {
        case allRecipes, empty, malformed
    }
    
    public func fetchAllRecipes() async throws -> [Recipe] {
        try await ContinuousClock().sleep(for: configuration.delay)
        return switch configuration.mode {
        case .allRecipes, .malformed:
            try allRecipes
        case .empty:
            []
        }
    }
}
