//
//  RecipesRepository.swift
//  Recipes
//
//  Created by Peter Wu on 1/22/25.
//

import Foundation

protocol RecipesRepository {
    associatedtype Recipe: RecipesModel
    
    func fetchAllRecipes() async throws -> [Recipe]
    func fetch(by id: Recipe.ID) async throws -> Recipe
}

protocol RecipesModel: Sendable & Codable & Identifiable & Hashable { }
