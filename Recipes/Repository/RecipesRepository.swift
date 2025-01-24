//
//  RecipesRepository.swift
//  Recipes
//
//  Created by Peter Wu on 1/22/25.
//

import Foundation

protocol RecipesRepository {
    associatedtype Recipe: RecipesModel
    
    // TODO: Implements pagination
    func fetchAllRecipes() async throws -> [Recipe]
}

protocol RecipesModel: Sendable & Codable & Identifiable & Hashable { }
