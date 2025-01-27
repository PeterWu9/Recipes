//
//  RecipesRepository.swift
//  Recipes
//
//  Created by Peter Wu on 1/22/25.
//


public protocol RecipesRepository {
    // TODO: Implements pagination
    func fetchAllRecipes() async throws -> [Recipe]
}

enum RecipesRepositoryError: Error {
    case decodingError(String)
}
